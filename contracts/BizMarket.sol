pragma solidity >=0.5.0 <0.7.0;
pragma experimental ABIEncoderV2;

contract BizMarket{
    string bannerListStr;
    string hotSearchListStr;
    //11������banner 
    function setBanner(string memory _bannerListStr) public {
        
        bannerListStr = _bannerListStr;
    }
    
    //10����ѯbanner  ���θ�ʽ��json�ַ�������ǰ�˽������ж��塣
    function getBanner() public view returns(string memory){
        
        return bannerListStr;
    }
    
     //13��������������
    function setHotSearch(string memory _hotSearchListStr) public {
        
        hotSearchListStr = _hotSearchListStr;
    }
    
    //12����ѯ��������  ���θ�ʽ��json�ַ�������ǰ�˽������ж��塣
    function getHotSearch() public view returns(string memory){
        
        return hotSearchListStr;
    }
    
    
    
    //
    
    
}