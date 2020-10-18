pragma solidity >=0.5.0 <= 0.7.0;
pragma experimental ABIEncoderV2;

library TokenInfoModel {
    struct TokenInfo {
        uint8 tokenType;
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

    struct CreateToken {
        uint8 tokenType;
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