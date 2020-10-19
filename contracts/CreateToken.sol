pragma solidity >=0.5.0 <= 0.7.0;
pragma experimental ABIEncoderV2;

import "./token/ERC20.sol";
import "./token/ERC721.sol";
import "./ICreateToken.sol";

contract CreateToken is ICreateToken {

    function publishToken(address owner, address project, TokenInfoModel.CreateToken memory createToken) external override returns(address) {

        address token;
        if (createToken.tokenType == 1) {
            ERC20 erc20 = new ERC20(owner, project, createToken);
            return address(erc20);
        } else if (createToken.tokenType == 2) {
            ERC721 erc721 = new ERC721(owner, createToken);
            return address(erc721);
        } else {
            require(false, "tokenType is error");
        }

    }
}