// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract ImplementationV2 {
    string public constant constantValue = "constant_v2";
    uint256 public immutable immutableValue;

    mapping(address => bool) public userAccess;

    constructor(uint256 _immutableValue) {
        immutableValue = _immutableValue;
    }

    function getConstant() public pure returns (string memory) {
        return constantValue;
    }

    function getImmutable() public view returns (uint256) {
        return immutableValue;
    }

    function setUserAccess(address user, bool access) external {
        require(user != address(0), "Zero address");
        userAccess[user] = access;
    }
}
