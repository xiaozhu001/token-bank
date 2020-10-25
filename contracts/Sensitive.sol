pragma solidity >=0.5.0 <0.7.0;
pragma experimental ABIEncoderV2;
import "./lib/StringLinkedList.sol";
import "./TokenBank.sol";

contract Sensitive {
    //TOKEN��Լ��ַ
    using StringLinkedList for StringLinkedList.LinkedList;
    StringLinkedList.LinkedList linkedList;

    function getList(uint index, uint pageSize) public view returns (string[] memory, uint[] memory) {
        return linkedList.getList(index, pageSize);
    }

    function getHeader() public view returns (uint index) {
        index = linkedList.header;
    }
    
    function addWords(string memory _words) public{
        
        require(!checkWords(_words),"���д��Ѵ���");
       
        //�������
        linkedList.addTail(_words);
        
        //ɾ��token
        TokenBank.removeToken(_words);
        
        /*
        TokenBank public t;
         constructor(address t1) public {
             t = Test1(t1);
         }
         t.removeToken(_words);
      */
    }
    
    function checkWords(string memory _words)  public view returns(bool result){
        
        if(linkedList.stringToIndexMap[_words]==0) {
            return false;
        }
        else{
            return true;
        }
      
    }
    
    
    function removeWord(uint index) public{
        //����������   λ�ô���
       linkedList.remove(index);
        
    }

}