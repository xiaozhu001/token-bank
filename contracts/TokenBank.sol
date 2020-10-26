pragma solidity >=0.5.0 <= 0.7.0;
pragma experimental ABIEncoderV2;

import "./AddressLinkedList.sol";
import "./TokenInfoModel.sol";
import "./ICreateToken.sol";
import "./ITokenExtend.sol";

contract TokenBank {

    using AddressLinkedList for AddressLinkedList.LinkedList;

    AddressLinkedList.LinkedList homeTokenList;
    AddressLinkedList.LinkedList topTokenList;

    mapping(address => string) topTokenMap;

    mapping(string => address) shorthandNameToTokenMap;

    struct Token {
        bool exist;
    }

    mapping(address => Token) tokenMap;

    address owner;
    ICreateToken createTokenContract;

    constructor() public {
        owner = msg.sender;
    }

    function setCreateToken(ICreateToken createTokenAddr) public {
        createTokenContract = createTokenAddr;
    }

    function getTopToken(uint index, uint pageSize) public view returns(address[] memory, string[] memory) {
        (address[] memory items, uint[] memory indexs) = topTokenList.getList(index, pageSize);
        string[] memory notes = new string[](items.length);
        for (uint i = 0; i < items.length; i ++) {
            notes[i] = topTokenMap[items[i]];
        }
        return (items, notes);
    }

    function addTopToken(address token, string memory note) public {
        topTokenList.add(token);
        topTokenMap[token] = note;
    }

    function removeTopToken(uint index) public {
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
        // 调用用户合约获取是否收藏
        // 返回

        Token memory token = tokenMap[tokenAddr];
        if (!token.exist) {
            return (tokenInfo, false);
        }
        
        return (ITokenExtend(tokenAddr).getInfo(), false);
    }

    function getTokenByShorthandName(string memory shorthandName, address userAccount) public view returns(TokenInfoModel.TokenInfo memory tokenInfo, bool collection) {
        address token = shorthandNameToTokenMap[shorthandName];
        if (token == address(0x0)) {
            return (tokenInfo, false);
        }
        return getTokenInfo(userAccount, token);
    }

    function checkShorthandName(string memory shorthandName) public view returns(bool result) {
        // 调用 Sensitive 校验；


        address token = shorthandNameToTokenMap[shorthandName];
        return token == address(0x0);
    }

    function publishToken(TokenInfoModel.CreateToken memory createToken) public {
        
        require(checkShorthandName(createToken.shorthandName), "shorthandName is error");

        address token = createTokenContract.publishToken(msg.sender, owner, createToken);
        // todo token 调用 UserToken.addMyToken(token, owner);

        homeTokenList.add(token);
        shorthandNameToTokenMap[createToken.shorthandName] = token;
        tokenMap[token] = Token(true);
    }

    function removeToken(string memory shorthandName) public {
        // todo 校验是 Sensitive 
        address token = shorthandNameToTokenMap[shorthandName];
        if (token == address(0x0)) {
            return;
        }

    }

}