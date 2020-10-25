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
    
    
    mapping(address => userToken)  userToTokenMap;//ӳ��usertoken
    
    mapping(address => collectionToken)  userToCollectionMap;//ӳ��collectiontoken
   
    
    //��Σ�(uint _range, uint _option, address _userAccount, uint pageNo, uint pageSize)
    //���Σ� (address[] tokens)
    //ע�ͣ� > range 1��ȫ����2��erc20��3��erc721 �� option 1���ҵ��ղأ�2���ҵĴ���
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
            //��ying'huyinghu
        }
        else if(_range == 3){
            
        }
        
    }
    */
    
    //��Σ� (address _token, uint _option)
    //���Σ� (string result)
    //ע�ͣ�> _option 1���ղأ� 2��ȡ���ղء� result 'success'���ɹ���'not exists'��token�����ڡ�
    
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

    
    //��Σ�(address _token, address _userAccount)
    //���Σ�(bool result)
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
#### 7����ȡ�û�token�б�

��Լ���ƣ�UserToken

��Լ������getUserTokenList

��Σ�(uint _range, uint _option, address _userAccount, uint pageNo, uint pageSize)

���Σ� (address[] tokens)

ע�ͣ� 
> range 1��ȫ����2��erc20��3��erc721 �� option 1���ҵ��ղأ�2���ҵĴ���

#### 8���ղ�token

��Լ���ƣ�UserToken

��Լ������collectionToken

��Σ� (address _token, uint _option)

���Σ� (string result)

ע�ͣ�
> _option 1���ղأ� 2��ȡ���ղء� result 'success'���ɹ���'not exists'��token�����ڡ�

#### 9������ҵ�token(��TokenBankʹ��)

��Լ���ƣ�UserToken

��Լ������addMyToken

��Σ�(address _token, address _userAccount)

���Σ�(bool result)

*/
    
}