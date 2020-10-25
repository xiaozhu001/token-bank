pragma solidity >=0.5.0 <0.7.0;
pragma experimental ABIEncoderV2;

contract BizMarket{
    string bannerListStr;
    string hotSearchListStr;
    //11、设置banner 
    function setBanner(string memory _bannerListStr) public {
        
        bannerListStr = _bannerListStr;
    }
    
    //10、查询banner  出参格式是json字符串，由前端进行自行定义。
    function getBanner() public view returns(string memory){
        
        return bannerListStr;
    }
    
     //13、设置热门搜索
    function setHotSearch(string memory _hotSearchListStr) public {
        
        hotSearchListStr = _hotSearchListStr;
    }
    
    //12、查询热门搜索  出参格式是json字符串，由前端进行自行定义。
    function getHotSearch() public view returns(string memory){
        
        return hotSearchListStr;
    }
    
    
    
    //
    
    
}