pragma solidity >=0.4.0 <0.7.0;
import "./AddressLinkedList.sol";

contract UserToken{
    using AddressLinkedList for AddressLinkedList.LinkedList;
    
    address owner;
    constructor() public {
        owner = msg.sender;
    }
    
    struct userToken{
        bool exist;
        AddressLinkedList.LinkedList userTokenList;
    }
    struct user20Token{
        bool exist;
        AddressLinkedList.LinkedList userTokenList;
    }
    struct user721Token{
        bool exist;
        AddressLinkedList.LinkedList userTokenList;
    }
    
    struct collectionToken{
        bool exist;
        AddressLinkedList.LinkedList collectionTokenList;

    }
    struct collection20Token{
        bool exist;
        AddressLinkedList.LinkedList collectionTokenList;

    }
    struct collection721Token{
        bool exist;
        AddressLinkedList.LinkedList collectionTokenList;

    }
    
    mapping(address => userToken)  userToTokenMap;//映射usertoken
    mapping(address => user20Token)  user20ToTokenMap;//映射usertoken
    mapping(address => user721Token)  user721ToTokenMap;//映射usertoken
    
    mapping(address => collectionToken)  userToCollectionMap;//映射collectiontoken
    mapping(address => collection20Token)  user20ToCollectionMap;//映射collectiontoken
    mapping(address => collection721Token)  user721ToCollectionMap;//映射collectiontoken
   
    
    //入参：(uint _range, uint _option, address _userAccount, uint pageNo, uint pageSize)
    //出参： (address[] tokens)
    //注释： > range 1：全部；2：erc20；3：erc721 。 option 1：我的收藏；2：我的创建
    
    function getUserTokenList(uint _range, uint _option, address _userAccount, uint pageNo, uint pageSize) public view returns(address[] memory tokens) {
       require(_option == 1 || _option == 2,"ption require 1 or 2");
       require(_range == 1 || _option == 2 || _option == 3,"require 1、2、3");
       
       if(_option == 1){
            if(_range == 1){
                
                (address[] memory items, uint[] memory indexs) = userToCollectionMap[_userAccount].collectionTokenList.getList(pageNo, pageSize);
                //string[] memory notes = new string[](items.length);
                //for (uint i = 0; i < items.length; i ++) {
                //   notes[i] = userToCollectionMap[_userAccount].collectionTokenList.indexToNodeMap[i].item;
                //}
                return items;
                
            }
            
            else  if (_range == 2){
                
                (address[] memory items, uint[] memory indexs) = user20ToCollectionMap[_userAccount].collectionTokenList.getList(pageNo, pageSize);
                
                return items;
            }
            else{
                 (address[] memory items, uint[] memory indexs) = user721ToCollectionMap[_userAccount].collectionTokenList.getList(pageNo, pageSize);
                
                return items;
            }
            
           
        }
        else {
            if(_range == 1){
                
                (address[] memory items, uint[] memory indexs) = userToTokenMap[_userAccount].userTokenList.getList(pageNo, pageSize);
                //string[] memory notes = new string[](items.length);
                //for (uint i = 0; i < items.length; i ++) {
                //   notes[i] = userToCollectionMap[_userAccount].userTokenList.indexToNodeMap[i].item;
                //}
                return items;
                
            }
            
            else  if (_range == 2){
                
                (address[] memory items, uint[] memory indexs) = user20ToTokenMap[_userAccount].userTokenList.getList(pageNo, pageSize);
                
                return items;
            }
            else{
                 (address[] memory items, uint[] memory indexs) = user721ToTokenMap[_userAccount].userTokenList.getList(pageNo, pageSize);
                
                return items;
            }
        }
        
    }
    
    
    //入参： (address _token, uint _option, uint _tokenType)   1：erc20，2：erc721
    //出参： (string result)
    //注释：> _option 1：收藏； 2：取消收藏。 result 'success'：成功；'not exists'：token不存在。
    
    function collectionToken(address _token, uint _option, uint _tokenType) public  returns(string memory result){
        
        require(_option == 1 || _option == 2,"optionrequire 1 or 2");
        require(_tokenType == 1 || _tokenType == 2,"tokenTyperequire 1 or 2");
        
        collectionToken memory collectiontoken = userToCollectionMap[owner];
        collection20Token memory collection20token = user20ToCollectionMap[owner];
        collection721Token memory collection721token = user721ToCollectionMap[owner];
        
        if(!collectiontoken.exist ){
            
           if(_option == 1){
               
                userToCollectionMap[owner] = collectiontoken;
                userToCollectionMap[owner].exist = true ;
                userToCollectionMap[owner].collectionTokenList.add(_token);
                
                if(_tokenType == 1) {
                    user20ToCollectionMap[owner] = collection20token;
                    user20ToCollectionMap[owner].exist = true ;
                    user20ToCollectionMap[owner].collectionTokenList.add(_token);
                }
                else {
                    user721ToCollectionMap[owner] = collection721token;
                    user721ToCollectionMap[owner].exist = true ;
                    user721ToCollectionMap[owner].collectionTokenList.add(_token);
                }
                
                return 'success';
            }
            else{
                
                return 'not Collection';
                
            }
        }
        else{
            
            if(_option == 1){
                 
                return 'exist,not Collection';
                
            }
            else{
                
                uint  index = userToCollectionMap[owner].CollectionTokenList.addressToIndexMap[_token];
                userToCollectionMap[owner].CollectionTokenList.remove(index);
                
                if(_tokenType == 1) {
                    
                    uint  index20 = user20ToCollectionMap[owner].CollectionTokenList.addressToIndexMap[_token];
                    user20ToCollectionMap[owner].CollectionTokenList.remove(index20);
                }
                else {
                    
                    uint  index721 = user721ToCollectionMap[owner].CollectionTokenList.addressToIndexMap[_token];
                    user721ToCollectionMap[owner].CollectionTokenList.remove(index721);
                }
                
                return 'success';
               
                
            }
            
        }

       
        
    }

    
    //入参：(address _token, address _userAccount, uint _tokenType)   1：erc20，2：erc721
    //出参：(bool result)
    function addMyToken(address _token, address _userAccount, uint _tokenType) public  returns(bool result){
        require(_tokenType == 1 || _tokenType == 2,"require 1、2");
        
        userToken memory usertoken = userToTokenMap[_userAccount];
        user20Token memory user20token = user20ToTokenMap[_userAccount];
        user721Token memory user721token = user721ToTokenMap[_userAccount];
        
        require(!usertoken.exist, "token is exist!");
        require(!user20token.exist, "token20 is exist!");
        require(!user721token.exist, "token721 is exist!");
            
        userToTokenMap[_userAccount] = usertoken;
        userToTokenMap[_userAccount].exist = true ;
        userToTokenMap[_userAccount].userTokenList.add(_token);
        
        if(_tokenType == 1) {
            
            user20ToTokenMap[_userAccount] = user20token;
            user20ToTokenMap[_userAccount].exist = true ;
            user20ToTokenMap[_userAccount].userTokenList.add(_token);
            
        }
        else {
            
            user721ToTokenMap[_userAccount] = user721token;
            user721ToTokenMap[_userAccount].exist = true ;
            user721ToTokenMap[_userAccount].userTokenList.add(_token);
           
        }
        
        return true;

    }
    
/*
#### 7、获取用户token列表

合约名称：UserToken

合约函数：getUserTokenList

入参：(uint _range, uint _option, address _userAccount, uint pageNo, uint pageSize)

出参： (address[] tokens)

注释： 
> range 1：全部；2：erc20；3：erc721 。 option 1：我的收藏；2：我的创建

#### 8、收藏token

合约名称：UserToken

合约函数：collectionToken

入参： (address _token, uint _option)

出参： (string result)

注释：
> _option 1：收藏； 2：取消收藏。 result 'success'：成功；'not exists'：token不存在。

#### 9、添加我的token(给TokenBank使用)

合约名称：UserToken

合约函数：addMyToken

入参：(address _token, address _userAccount)

出参：(bool result)

*/
    
}