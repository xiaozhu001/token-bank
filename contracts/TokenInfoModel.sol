pragma solidity >=0.5.0 <= 0.7.0;
pragma experimental ABIEncoderV2;

library TokenInfoModel {
    enum TokenType {
        ERC20,
        ERC721
    }
    struct TokenInfo {
        string tokenName;
        string shorthandName;
        address token;
        address owner;
        uint total;
        uint totalSupply;
        uint holderNum;
        uint haveNum;
        string img;
        bool burning;
        bool increase;
        uint decimals;
        string note;
        string attribute;
        uint createTime;
    }
    // ["ERC20","ERC20", 1000,"/abc",false,false,10,"abc","def"]
    struct CreateToken {
        string tokenName;
        string shorthandName;
        uint total;
        string img;
        bool burning;
        bool increase;
        uint decimals;
        string note;
        string attribute;
    }
}