pragma solidity >=0.4.0 <0.7.0;
pragma experimental ABIEncoderV2;
import "./AddressLinkedList.sol";
import "./ITokenExtend.sol";
import "./IUserToken.sol";

contract UserToken is IUserToken {
    using AddressLinkedList for AddressLinkedList.LinkedList;
    address tokenBankAddress;
    
    address owner;
    enum TypeRange {
        ALL,
        ERC20,
        ERC721
    }
    
    enum UserOption {
        COLLECTION,
        CREATE
    }
    
    
    
    constructor(address _tokenBankAddress) public {
        owner = msg.sender;
        tokenBankAddress = _tokenBankAddress;
    }
   
    
    modifier onlyTokenBank() {
        require(tokenBankAddress == msg.sender,"onlyTokenBank");
        _;
    }
    
    // account =>option =>range => list
    mapping(address => mapping(uint8 => mapping(uint8 => AddressLinkedList.LinkedList))) userTokenListMap;
    // account =>option =>range => token => index
    mapping(address => mapping(uint8 => mapping(uint8 => mapping(address => uint)))) userTokenIndexMap;
    
    

    //range 1：全部；2：erc20；3：erc721 。 option 1：我的收藏；2：我的创建
    
    function getUserTokenList(uint8 _range, uint8 _option, address _userAccount, uint index, uint pageSize) public view returns(address[] memory itemList, uint[] memory indexList) {
       require(_range == uint8(TypeRange.ERC20) || _range == uint8(TypeRange.ERC721) || _range == uint8(TypeRange.ALL) ,"range require 0 1 2 ");
       require(_option == uint8(UserOption.COLLECTION) || _option == uint8(UserOption.CREATE),"require 0 1");
       
       return userTokenListMap[_userAccount][_option][_range].getList(index,pageSize);
       
        
    }
    
    

    //_option 1：收藏； 2：取消收藏。 result 'success'：成功；'not exists'：token不存在。
    
    function collectionToken(address _token, uint _option) public {
        
        require(_option == 1 || _option == 2,"optionrequire 1 or 2");
        
        _addUserToken(_token, uint8(UserOption.COLLECTION), msg.sender, _option == 1);
        
        
    }

    

    function addMyToken(address _token, address _userAccount) external override onlyTokenBank {
        
        _addUserToken(_token,uint8(UserOption.CREATE),_userAccount,true);
        

    }
    
    function _addUserToken(address _token, uint8 _option, address _userAccount, bool isDelete) internal {
        uint index = userTokenListMap[_userAccount][_option][uint8(TypeRange.ALL)].add(_token);
        ITokenExtend tokenExtend = ITokenExtend(_token);
        TokenInfoModel.TokenInfo memory tokenInfo = tokenExtend.getInfo();
        if (!isDelete) {
            if(index != 0) {
                return;
            }
            
            uint addAllIndex = userTokenListMap[_userAccount][_option][uint8(TypeRange.ALL)].add(_token);
            // account =>option =>range => token => index
            userTokenIndexMap[_userAccount][_option][uint8(TypeRange.ALL)][_token]=addAllIndex;
            
            uint addIndex = userTokenListMap[_userAccount][_option][tokenInfo.tokenType].add(_token);
            // account =>option =>range => token => index
            userTokenIndexMap[_userAccount][_option][tokenInfo.tokenType][_token]=addIndex;
            
            
        } else {
            if(index == 0) {
                return;
            }
            
            userTokenListMap[_userAccount][_option][uint8(TypeRange.ALL)].remove(index);
            // account =>option =>range => token => index
            delete userTokenIndexMap[_userAccount][_option][uint8(TypeRange.ALL)][_token];
            
            uint index1 = userTokenIndexMap[_userAccount][_option][tokenInfo.tokenType][_token];
            userTokenListMap[_userAccount][_option][tokenInfo.tokenType].remove(index1);
            // account =>option =>range => token => index
            delete userTokenIndexMap[_userAccount][_option][tokenInfo.tokenType][_token];
             
            
        }
    }

    function isCollection(address account, address token) external override view returns(bool) {
        return userTokenIndexMap[account][uint8(UserOption.COLLECTION)][uint8(TypeRange.ALL)][token] != 0;
    }
    
}