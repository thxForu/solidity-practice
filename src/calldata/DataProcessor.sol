// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract DataProcessor {
    error EmptyArrayError();

    function processArray(uint256[] calldata numbers) external pure returns (uint256[] memory) {
        if (numbers.length == 0) revert EmptyArrayError();

        uint256[] memory result = new uint256[](numbers.length);
        for (uint256 i = 0; i < numbers.length; i++) {
            result[i] = numbers[i] * numbers[i];
        }
        return result;
    }

    function calculateSum(uint256[] calldata numbers) external pure returns (uint256) {
        if (numbers.length == 0) revert EmptyArrayError();

        uint256 sum = 0;
        for (uint256 i = 0; i < numbers.length; i++) {
            sum += numbers[i];
        }
        return sum;
    }

    function findMax(uint256[] calldata numbers) external pure returns (uint256) {
        if (numbers.length == 0) revert EmptyArrayError();

        uint256 maxNumber = numbers[0];
        for (uint256 i = 1; i < numbers.length; i++) {
            if (numbers[i] > maxNumber) {
                maxNumber = numbers[i];
            }
        }
        return maxNumber;
    }

    // memory
    function processArrayMemory(uint256[] calldata numbers) external pure returns (uint256[] memory) {
        if (numbers.length == 0) revert EmptyArrayError();

        uint256[] memory _numbers = numbers;
        uint256[] memory result = new uint256[](_numbers.length);
        for (uint256 i = 0; i < _numbers.length; i++) {
            result[i] = _numbers[i] * _numbers[i];
        }
        return result;
    }

    function calculateSumMemory(uint256[] memory numbers) external pure returns (uint256) {
        if (numbers.length == 0) revert EmptyArrayError();

        uint256 sum = 0;
        uint256[] memory _numbers = numbers;
        for (uint256 i = 0; i < _numbers.length; i++) {
            sum += _numbers[i];
        }
        return sum;
    }

    function findMaxMemory(uint256[] memory numbers) external pure returns (uint256) {
        if (numbers.length == 0) revert EmptyArrayError();

        uint256 maxNumber = numbers[0];
        uint256[] memory _numbers = numbers;
        for (uint256 i = 1; i < _numbers.length; i++) {
            if (_numbers[i] > maxNumber) {
                maxNumber = _numbers[i];
            }
        }
        return maxNumber;
    }
}
