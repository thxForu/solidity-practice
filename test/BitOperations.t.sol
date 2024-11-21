// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Test, console2} from "forge-std/Test.sol";
import {BitOperations} from "../src/bitwise-operations/BitOperations.sol";

contract BitOperationsTest is Test {
    BitOperations public bitOps;

    function setUp() public {
        bitOps = new BitOperations();
    }

    function test_SetAndGetVariables() public {
        bool expectedIsContract = true;
        address expectedOwner = address(0x1234);
        uint16 expectedId = 123;

        bitOps.setVariables(expectedIsContract, expectedOwner, expectedId);
        (bool actualIsContract, address actualOwner, uint16 actualId) = bitOps.getVariables();

        assertEq(actualIsContract, expectedIsContract, "isContract mismatch");
        assertEq(actualOwner, expectedOwner, "owner mismatch");
        assertEq(actualId, expectedId, "id mismatch");
    }
}