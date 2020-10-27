pragma solidity >=0.5.0 <= 0.7.0;
pragma experimental ABIEncoderV2;

import "./TokenInfoModel.sol";

interface ITokenExtend {

  function getInfo() external view returns (TokenInfoModel.TokenInfo memory);
}