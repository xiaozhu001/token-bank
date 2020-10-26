pragma solidity >=0.5.0 <= 0.7.0;
pragma experimental ABIEncoderV2;

contract StringLinkedListDemo {


    using StringLinkedList for StringLinkedList.LinkedList;
    StringLinkedList.LinkedList linkedList;

    function add(string memory item) public {
        linkedList.addTail(item);
    }

    function getList(uint index, uint pageSize) public view returns (string[] memory, uint[] memory) {
        return linkedList.getList(index, pageSize);
    }

    function getHeader() public view returns (uint index) {
        index = linkedList.header;
    }

}

library StringLinkedList {

    struct LinkedList {
        uint header;
        uint tail;
        uint index;
        uint size;
    
        mapping(uint => Node) indexToNodeMap;
        mapping(string => uint) stringToIndexMap;
    }
    

    struct Node {
        string item;
        
        uint curr;
        uint pre;
        uint next;
        bool exist;
    }


    function add(LinkedList storage linkedList, string memory item) internal returns (uint) {
        
        linkedList.index = linkedList.index + 1;
        linkedList.indexToNodeMap[linkedList.index] = Node(item, linkedList.index, 0, linkedList.header, true);
        linkedList.indexToNodeMap[linkedList.header].pre = linkedList.index;
        linkedList.header = linkedList.index;
        
        linkedList.stringToIndexMap[item]=linkedList.index;
        if (linkedList.size == 0) {
            linkedList.tail = linkedList.index;
        }
        linkedList.size = linkedList.size + 1;
        
        return linkedList.index;
    }

    function addTail(LinkedList storage linkedList, string memory item) internal returns (uint) {
        
        linkedList.index = linkedList.index + 1;
        linkedList.indexToNodeMap[linkedList.index] = Node(item, linkedList.index, linkedList.tail, 0, true);
        linkedList.indexToNodeMap[linkedList.tail].next = linkedList.index;
        linkedList.tail = linkedList.index;
        
        linkedList.stringToIndexMap[item]=linkedList.index;
        if (linkedList.size == 0) {
            linkedList.header = linkedList.index;
        }
        linkedList.size = linkedList.size + 1;
        return linkedList.index;
    }
    
    function insert(LinkedList storage linkedList, uint index,string memory item) internal returns (uint) {
        require(index != 0, "index can not 0");
        Node storage node = linkedList.indexToNodeMap[index];
        require(node.exist, "index is error");
        
        linkedList.index = linkedList.index + 1;
        
        linkedList.indexToNodeMap[linkedList.index] = Node(item, linkedList.index, index, node.next, true);
        node.next = linkedList.index;
        
        linkedList.size = linkedList.size + 1;
        
        linkedList.stringToIndexMap[item]=linkedList.index;
        return linkedList.index;
        
    }

    function remove(LinkedList storage linkedList, uint index) internal {
        require(index != 0, "index can not 0");
        
        Node memory node = linkedList.indexToNodeMap[index];
        if (!node.exist) {
            return;
        }
        uint pre = node.pre;
        uint next = node.next;
        if (pre != 0) {
            linkedList.indexToNodeMap[pre].next = next;
        }
        if (next != 0) {
            linkedList.indexToNodeMap[next].pre = pre;
        }
        if (linkedList.header == index) {
            linkedList.header = next;
        }
        if (linkedList.tail == index) {
            linkedList.tail = pre;
        }
        delete linkedList.indexToNodeMap[index];
        linkedList.size = linkedList.size - 1;
    }
    
    function get(LinkedList storage linkedList, uint index) internal view returns(Node memory node) {
        node = linkedList.indexToNodeMap[index];
    }

    function getList(LinkedList storage linkedList, uint index, uint pageSize) 
        internal view returns(string[] memory itemList, uint[] memory indexList) {
            
        itemList = new string[](pageSize);
        indexList = new uint[](pageSize);
        uint temp;
        if (index == 0) {
            temp = linkedList.header;
        } else {
            // todo 找到下一个节点
            temp = index;
        }
        
        for (uint i = 0; i < pageSize && temp != 0 && linkedList.indexToNodeMap[temp].exist; i ++) {
            indexList[i] = temp;
            itemList[i] = linkedList.indexToNodeMap[temp].item;
            temp = linkedList.indexToNodeMap[temp].next;
        }
    }

}