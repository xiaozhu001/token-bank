pragma solidity >=0.4.0 <0.7.0;
pragma experimental ABIEncoderV2;

interface IUserToken {
    function isCollection(address account, address token) external view returns(bool);
    function addMyToken(address _token, address _userAccount) external;
}