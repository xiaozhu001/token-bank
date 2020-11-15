pragma solidity >=0.5.0 <= 0.7.0;
pragma experimental ABIEncoderV2;

import "./IERC20.sol";
import "./ITokenExtend.sol";
import "./SafeMath.sol";
import "./TokenInfoModel.sol";

contract ERC20 is IERC20,ITokenExtend {
  using SafeMath for uint256;

  mapping (address => uint256) private _balances;

  mapping (address => mapping (address => uint256)) private _allowed;
  
  TokenInfoModel.TokenInfo tokenInfo;

  modifier onlyOwner() {
    require(msg.sender == tokenInfo.owner, "only owner");
    _;
  }
  
  constructor (address owner, address project, TokenInfoModel.CreateToken memory createToken) public {
    tokenInfo.tokenName = createToken.tokenName;
    tokenInfo.shorthandName = createToken.shorthandName;
    tokenInfo.token = address(this);
    tokenInfo.owner = owner;
    tokenInfo.total = createToken.total;
    tokenInfo.img = createToken.img;
    tokenInfo.burning = createToken.burning;
    tokenInfo.increase = createToken.increase;
    tokenInfo.decimals = createToken.decimals;
    tokenInfo.note = createToken.note;
    tokenInfo.attribute = createToken.attribute;
    tokenInfo.createTime = now;
    _mint(project, tokenInfo.total.mul(6).div(10000));
  } 
  
  function getInfo() public override view returns (TokenInfoModel.TokenInfo memory) {
    return tokenInfo;
  }
  /**
  * @dev Total number of tokens in existence
  */
  function totalSupply() public override view returns (uint256) {
    return tokenInfo.totalSupply;
  }

  function name() public view returns (string memory) {
    return tokenInfo.tokenName;
  }

  function symbol() public view returns (string memory) {
    return tokenInfo.shorthandName;
  }
  /**
  * @dev Gets the balance of the specified address.
  * @param owner The address to query the balance of.
  * @return An uint256 representing the amount owned by the passed address.
  */
  function balanceOf(address owner) public override view returns (uint256) {
    return _balances[owner];
  }

  /**
   * @dev Function to check the amount of tokens that an owner allowed to a spender.
   * @param owner address The address which owns the funds.
   * @param spender address The address which will spend the funds.
   * @return A uint256 specifying the amount of tokens still available for the spender.
   */
  function allowance(address owner, address spender) public override view returns (uint256) {
    return _allowed[owner][spender];
  }

  /**
  * @dev Transfer token for a specified address
  * @param to The address to transfer to.
  * @param value The amount to be transferred.
  */
  function transfer(address to, uint256 value) public override returns (bool) {
    require(value <= _balances[msg.sender]);
    require(to != address(0));

    _statistics(to);
    _balances[msg.sender] = _balances[msg.sender].sub(value);
    _balances[to] = _balances[to].add(value);
    emit Transfer(msg.sender, to, value);
    return true;
  }

  /**
   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
   * Beware that changing an allowance with this method brings the risk that someone may use both the old
   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
   * @param spender The address which will spend the funds.
   * @param value The amount of tokens to be spent.
   */
  function approve(address spender, uint256 value) public override returns (bool) {
    require(spender != address(0));

    _allowed[msg.sender][spender] = value;
    emit Approval(msg.sender, spender, value);
    return true;
  }

  /**
   * @dev Transfer tokens from one address to another
   * @param from address The address which you want to send tokens from
   * @param to address The address which you want to transfer to
   * @param value uint256 the amount of tokens to be transferred
   */
  function transferFrom(address from, address to, uint256 value) public override returns (bool) {
    require(value <= _balances[from]);
    require(value <= _allowed[from][msg.sender]);
    require(to != address(0));

    _statistics(to);
    _balances[from] = _balances[from].sub(value);
    _balances[to] = _balances[to].add(value);
    _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
    emit Transfer(from, to, value);
    return true;
  }

  /**
   * @dev Increase the amount of tokens that an owner allowed to a spender.
   * approve should be called when allowed_[_spender] == 0. To increment
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   * @param spender The address which will spend the funds.
   * @param addedValue The amount of tokens to increase the allowance by.
   */
  function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
    require(spender != address(0));

    _allowed[msg.sender][spender] = ( _allowed[msg.sender][spender].add(addedValue));
    emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
    return true;
  }

  /**
   * @dev Decrease the amount of tokens that an owner allowed to a spender.
   * approve should be called when allowed_[_spender] == 0. To decrement
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   * @param spender The address which will spend the funds.
   * @param subtractedValue The amount of tokens to decrease the allowance by.
   */
  function decreaseAllowance(address spender,uint256 subtractedValue) public returns (bool) {
    require(spender != address(0));

    _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
    emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
    return true;
  }
  
  function airdrop(address account, uint256 amount) public onlyOwner {
      _mint(account, amount);
  }
  
  function burn(uint256 amount) public {
      _burn(msg.sender, amount);
  }

  /**
   * @dev Internal function that mints an amount of the token and assigns it to
   * an account. This encapsulates the modification of balances such that the
   * proper events are emitted.
   * @param account The account that will receive the created tokens.
   * @param amount The amount that will be created.
   */
  function _mint(address account, uint256 amount) internal {
    require(account != address(0));

    if (!tokenInfo.increase && tokenInfo.totalSupply.add(amount) > tokenInfo.total) {
      require(false, "can not increase");
    }
    _statistics(account);

    tokenInfo.totalSupply = tokenInfo.totalSupply.add(amount);
    _balances[account] = _balances[account].add(amount);
    emit Transfer(address(0), account, amount);
  }

  /**
   * @dev Internal function that burns an amount of the token of a given
   * account.
   * @param amount The amount that will be burnt.
   */
  function _burn(address account, uint256 amount) internal {
    require(amount <= _balances[account]);
    require(tokenInfo.burning, "can not burning");

    tokenInfo.totalSupply = tokenInfo.totalSupply.sub(amount);
    _balances[account] = _balances[account].sub(amount);
    emit Transfer(account, address(0), amount);
  }

  function _statistics(address account) internal {
    if (_balances[account] == 0) {
      tokenInfo.holderNum = tokenInfo.holderNum.add(1);
    }
  }
} 