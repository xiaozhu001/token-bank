pragma solidity >=0.5.0 <0.7.0;
pragma experimental ABIEncoderV2;

contract BizMarket{
    string bannerListStr;
    string hotSearchListStr;

    address owner;

    
    constructor() public {
        owner = msg.sender;
    }

    //11设置banner 
    function setBanner(string memory _bannerListStr) public {
        require(owner == msg.sender,"only owner");
        bannerListStr = _bannerListStr;
    }
    
    //10查询banner 出参格式是json字符串，由前端进行自行定义
    function getBanner() public view returns(string memory){
        
        return bannerListStr;
    }
    
     //13设置热门搜索 入参格式是json字符串，由前端进行自行定义
    function setHotSearch(string memory _hotSearchListStr) public {
        require(owner == msg.sender,"only owner");
        hotSearchListStr = _hotSearchListStr;
    }
    
    //12查询热门搜索  出参格式是json字符串，由前端进行自行定义
    function getHotSearch() public view returns(string memory){
        
        return hotSearchListStr;
    }
    
    
    
    //
    
    
}