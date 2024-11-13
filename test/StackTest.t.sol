// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/Test.sol";
import "../src/stack-optimization/Stack.sol";

contract StackTest is Test {
    Stack private stack;

    function setUp() public {
        stack = new Stack();
    }

    function testBubbleSort() public {
        uint256[] memory arr = new uint256[](5);
        arr[0] = 5;
        arr[1] = 2;
        arr[2] = 8;
        arr[3] = 1;
        arr[4] = 9;

        stack.setArray(arr);

        stack.bubbleSort();

        uint256[] memory sortedArr = stack.getArray();

        assertEq(sortedArr[0], 1);
        assertEq(sortedArr[1], 2);
        assertEq(sortedArr[2], 5);
        assertEq(sortedArr[3], 8);
        assertEq(sortedArr[4], 9);
    }
}
