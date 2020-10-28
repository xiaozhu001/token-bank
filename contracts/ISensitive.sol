pragma solidity >=0.5.0 <0.7.0;

interface ISensitive {
    function checkWords(string calldata _words) external view returns(bool result);
}