// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Stack {
    uint256[] private arr;

    function setArray(uint256[] memory _arr) public {
        delete arr;
        for (uint256 i = 0; i < _arr.length; i++) {
            arr.push(_arr[i]);
        }
    }

    function bubbleSort() external {
        uint256 len = arr.length;
        for (uint256 i; i < len; i++) {
            bool swapped = false;

            for (uint256 j; j < len - i - 1; j++) {
                if (arr[j] > arr[j + 1]) {
                    (arr[j], arr[j + 1]) = (arr[j + 1], arr[j]);
                    swapped = true;
                }
            }

            if (!swapped) {
                break;
            }
        }
    }

    function getArray() external view returns (uint256[] memory) {
        return arr;
    }
}
