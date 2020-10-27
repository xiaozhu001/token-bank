pragma solidity >=0.5.0 <= 0.7.0;

interface ITokenBank {
	function removeToken(string memory shorthandName) external;
}
