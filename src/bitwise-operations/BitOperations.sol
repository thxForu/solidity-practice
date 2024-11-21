// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract BitOperations {
    uint256 private slot;

    function getVariables() public view returns (bool, address, uint16) {
        bool isContract = (slot & 1) != 0; // get lowest bit

        uint256 ADDRESS_MASK = (1 << 160) - 1;
        address owner = address(uint160((slot >> 1) & ADDRESS_MASK)); // get next 160 bits

        uint16 id = uint16((slot >> 161) & 0xFFFF); // get next 16 bits
        return (isContract, owner, id);
    }

    function setVariables(bool _isContract, address _owner, uint16 _id) public {
        slot = uint256(_isContract ? 1 : 0) | (uint256(uint160(_owner)) << 1) // move owner by 1 bit to the left
            | (uint256(_id) << 161); // move id by 161 bits to the left
    }

    function getSlotValue() public view returns (uint256) {
        return slot;
    }
}
