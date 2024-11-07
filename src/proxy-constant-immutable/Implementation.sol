// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Implementation {
    string public constant constantValue = "constant";
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
        userAccess[user] = access;
    }
}
