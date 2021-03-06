pragma solidity >=0.4.0 <0.7.0;
pragma experimental ABIEncoderV2;

import "./AddressLinkedList.sol";
import "./IUserToken.sol";

contract UserToken is IUserToken {
    using AddressLinkedList for AddressLinkedList.LinkedList;
    address tokenBankAddress;
    
    address owner;
    
    enum UserOption {
        COLLECTION,
        CREATE
    }

    enum OperateOption {
        COLLECTION,
        CANCEL
    }

    constructor() public {
        owner = msg.sender;
    }
    
    function setTokenBank(address _tokenBankAddress) public {
        require(owner == msg.sender,"only owner");
        tokenBankAddress = _tokenBankAddress;
    }
    
    modifier onlyTokenBank() {
        require(tokenBankAddress == msg.sender,"onlyTokenBank");
        _;
    }
    
    // account =>option => list
    mapping(address => mapping(uint8 => AddressLinkedList.LinkedList)) userTokenListMap;
    // account =>option => token => index
    mapping(address => mapping(uint8 => mapping(address => uint))) userTokenIndexMap;
    

    // option 0：我的收藏；1：我的创建
    function getUserTokenList(uint8 _option, address _userAccount, uint index, uint pageSize) public view returns(address[] memory itemList, uint[] memory indexList) {
       require(_option == uint8(UserOption.COLLECTION) || _option == uint8(UserOption.CREATE),"require 0 1");
       
       return userTokenListMap[_userAccount][_option].getList(index,pageSize);
    }
    
    

    //_option 0：收藏； 1：取消收藏。 
    
    function collectionToken(address _token, uint _option) public {
        
        require(_option == uint8(OperateOption.COLLECTION) || _option == uint8(OperateOption.CANCEL),"optionrequire 0 or 1");
        
        _addUserToken(_token, uint8(UserOption.COLLECTION), msg.sender, _option == uint8(OperateOption.CANCEL));
        
        
    }

    

    function addMyToken(address _token, address _userAccount) external override onlyTokenBank {
        
        _addUserToken(_token, uint8(UserOption.CREATE), _userAccount, false);
        
    }
    
    function _addUserToken(address _token, uint8 _option, address _userAccount, bool isDelete) internal {
        uint index = userTokenIndexMap[_userAccount][_option][_token];
        if (!isDelete) {
            if(index != 0) {
                return;
            }
            
            uint addAllIndex = userTokenListMap[_userAccount][_option].add(_token);
            // account =>option =>range => token => index
            userTokenIndexMap[_userAccount][_option][_token]=addAllIndex;
        } else {
            if(index == 0) {
                return;
            }
            userTokenListMap[_userAccount][_option].remove(index);
            // account =>option =>range => token => index
            delete userTokenIndexMap[_userAccount][_option][_token];
        }
    }

    function isCollection(address account, address token) external override view returns(bool) {
        return userTokenIndexMap[account][uint8(UserOption.COLLECTION)][token] != 0;
    }
    
}