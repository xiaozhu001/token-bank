pragma solidity >=0.4.0 <0.7.0;
import "./lib/AddressLinkedList.sol";

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
    
    struct collectionToken{
        bool exist;
        AddressLinkedList.LinkedList CollectionTokenList;

    }
    
    
    mapping(address => userToken)  userToTokenMap;//映射usertoken
    
    mapping(address => collectionToken)  userToCollectionMap;//映射collectiontoken
   
    
    //入参：(uint _range, uint _option, address _userAccount, uint pageNo, uint pageSize)
    //出参： (address[] tokens)
    //注释： > range 1：全部；2：erc20；3：erc721 。 option 1：我的收藏；2：我的创建
    /*
    function getUserTokenList(uint _range, uint _option, address _userAccount, uint pageNo, uint pageSize) public view returns(address[] memory tokens) {
       
       if(_range == 1){
            if(_option == 1){
                 (address[] memory items, uint[] memory indexs) = userToCollectionMap[_userAccount].CollectionTokenList.getList(index, pageSize);
                string[] memory notes = new string[](items.length);
                for (uint i = 0; i < items.length; i ++) {
                    notes[i] = topTokenMap[items[i]];
                }
                return items;
                
            }
            else{
                 (address[] memory items, uint[] memory indexs) = topTokenList.getList(index, pageSize);
                string[] memory notes = new string[](items.length);
                for (uint i = 0; i < items.length; i ++) {
                    notes[i] = topTokenMap[items[i]];
                }
                return (items, notes);
                
            }
           
        }
        else if(_range == 2){
            //发ying'huyinghu
        }
        else if(_range == 3){
            
        }
        
    }
    */
    
    //入参： (address _token, uint _option)
    //出参： (string result)
    //注释：> _option 1：收藏； 2：取消收藏。 result 'success'：成功；'not exists'：token不存在。
    
    function collectionToken(address _token, uint _option) public  returns(string memory result){
        require(_option == 1 || _option == 2,"require 1 or 2");
        
        collectionToken memory collectiontoken = userToCollectionMap[owner];
        if(!collectiontoken.exist ){
            
           if(_option == 1){
               
                userToCollectionMap[owner] = collectiontoken;
                userToCollectionMap[owner].exist = true ;
                userToCollectionMap[owner].CollectionTokenList.add(_token);
                
                return 'success';
            }
            else{
                
                return 'not Collection';
                
            }
        }
        else{
            
            if(_option == 1){
                 
                userToCollectionMap[owner].CollectionTokenList.add(_token);
                
            }
            else{
                uint  index = userToCollectionMap[owner].CollectionTokenList.addressToIndexMap[_token];
                userToCollectionMap[owner].CollectionTokenList.remove(index);
                
            }
            return 'success';
        }

       
        
    }

    
    //入参：(address _token, address _userAccount)
    //出参：(bool result)
    function addMyToken(address _token, address _userAccount) public   returns(bool result){
        
        userToken memory usertoken = userToTokenMap[_userAccount];
        if (!usertoken.exist) {
            
            userToTokenMap[_userAccount] = usertoken;
            userToTokenMap[_userAccount].exist = true ;
            //userToTokenMap[_userAccount].userTokenList.add(_token);
        }
       
        userToTokenMap[_userAccount].userTokenList.add(_token);


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