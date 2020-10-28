pragma solidity >=0.5.0 <= 0.7.0;
pragma experimental ABIEncoderV2;

import "./AddressLinkedList.sol";
import "./TokenInfoModel.sol";
import "./ICreateToken.sol";
import "./ITokenExtend.sol";
import "./ITokenBank.sol";
import "./ISensitive.sol";
import "./IUserToken.sol";

contract TokenBank is ITokenBank {

    using AddressLinkedList for AddressLinkedList.LinkedList;

    AddressLinkedList.LinkedList homeTokenList;
    AddressLinkedList.LinkedList topTokenList;

    mapping(address => string) topTokenMap;

    mapping(string => address) shorthandNameToTokenMap;
    mapping(address => uint) tokenToIndexMap;

    struct Token {
        bool exist;
    }

    mapping(address => Token) tokenMap;

    address owner;
    ICreateToken createTokenContract;
    ISensitive sensitiveContract;
    IUserToken userTokenContract;

    constructor() public {
        owner = msg.sender;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "onlyOwner");
        _;
    }

    function setCreateToken(ICreateToken createTokenAddr, ISensitive sensitiveAddr, IUserToken userTokenAddr) public onlyOwner {
        createTokenContract = createTokenAddr;
        sensitiveContract = sensitiveAddr;
        userTokenContract = userTokenAddr;
    }

    function getTopToken(uint index, uint pageSize) public view returns(address[] memory, string[] memory) {
        (address[] memory items, uint[] memory indexs) = topTokenList.getList(index, pageSize);
        string[] memory notes = new string[](items.length);
        for (uint i = 0; i < items.length; i ++) {
            notes[i] = topTokenMap[items[i]];
        }
        return (items, notes);
    }

    function addTopToken(address token, string memory note) public onlyOwner {
        topTokenList.add(token);
        topTokenMap[token] = note;
    }

    function removeTopToken(uint index) public onlyOwner {
        AddressLinkedList.Node memory node = topTokenList.get(index);
        if (!node.exist) {
            return;
        }
        delete topTokenMap[node.item];
        topTokenList.remove(index);
    }

    function getHomeTokenList(uint index, uint pageSize) public view returns(address[] memory tokens, uint[] memory indexs) {
        return homeTokenList.getList(index, pageSize);
    }

    function getTokenInfo(address userAccount, address tokenAddr) public view returns(TokenInfoModel.TokenInfo memory tokenInfo, bool collection) {
        
        Token memory token = tokenMap[tokenAddr];
        if (!token.exist) {
            return (tokenInfo, false);
        }
        tokenInfo = ITokenExtend(tokenAddr).getInfo();
        collection = userTokenContract.isCollection(userAccount, tokenAddr);
    }

    function getTokenByShorthandName(string memory shorthandName, address userAccount) public view returns(TokenInfoModel.TokenInfo memory tokenInfo, bool collection) {
        address token = shorthandNameToTokenMap[shorthandName];
        if (token == address(0x0)) {
            return (tokenInfo, false);
        }
        return getTokenInfo(userAccount, token);
    }

    function checkShorthandName(string memory shorthandName) public view returns(bool result) {
        
        if (sensitiveContract.checkWords(shorthandName)) {
            return false;
        }

        address token = shorthandNameToTokenMap[shorthandName];
        return token == address(0x0);
    }

    function publishToken(TokenInfoModel.CreateToken memory createToken) public {
        
        require(checkShorthandName(createToken.shorthandName), "shorthandName is error");

        address token = createTokenContract.publishToken(msg.sender, owner, createToken);
        // todo token 调用 UserToken.addMyToken(token, owner);
        
        userTokenContract.addMyToken(token, msg.sender);

        tokenToIndexMap[token] = homeTokenList.add(token);
        shorthandNameToTokenMap[createToken.shorthandName] = token;
        tokenMap[token] = Token(true);
    }

    function removeToken(string memory shorthandName) public override {
        require(msg.sender == address(sensitiveContract), "only sensitive");
        
        address token = shorthandNameToTokenMap[shorthandName];
        if (token == address(0x0)) {
            return;
        }
        uint index = tokenToIndexMap[token];
        homeTokenList.remove(index);
        delete shorthandNameToTokenMap[shorthandName];
        delete tokenMap[token];
    }

}