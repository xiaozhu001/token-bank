pragma solidity >=0.5.0 <0.7.0;
pragma experimental ABIEncoderV2;
import "./ITokenBank.sol";
import "./ISensitive.sol";

contract Sensitive is ISensitive {
  
    ITokenBank tokenBank;
    address owner;
    
    mapping(string => bool) wordsMap;
    
    event del(string _words);
    
    constructor() public {
        owner = msg.sender;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner,"onlyOwner");
        _;
    }
    
    
    function setTokenBank(ITokenBank _tokenBank) public onlyOwner {
        tokenBank = _tokenBank;
    }
    
    //添加敏感词
    function addWords(string memory _words) public onlyOwner {
        
        if (wordsMap[_words]) {
            return;
        }
        
        wordsMap[_words] = true;
        

        tokenBank.removeToken(_words);
        
       
    }
    
    //判断是否敏感(给TokenBank合约使用)
    function checkWords(string calldata _words)  external override view returns(bool result) {
        
        return wordsMap[_words];
      
    }
    
    //移除敏感词
    function removeWord(string memory _words) public onlyOwner {
        if (!wordsMap[_words]) {
            return;
        }
        
        delete wordsMap[_words];
        emit del(_words);
        
    }

}