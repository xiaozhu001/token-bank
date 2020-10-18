pragma solidity >=0.5.0 <= 0.7.0;
pragma experimental ABIEncoderV2;

import "./model/TokenInfoModel.sol";

interface ICreateToken {
    function publishToken(address owner, address project, TokenInfoModel.CreateToken memory createToken) external returns(address);
}