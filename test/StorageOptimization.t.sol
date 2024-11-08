// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/Test.sol";
import "../src/storage-optimization/StorageOptimization.sol";

contract StorageOptimizationTest is Test {
    StorageOptimization public storage_;
    address public constant USER1 = address(0x1);
    address public constant USER2 = address(0x2);

    event BalanceUpdated(address indexed user, uint256 newBalance, uint256 gasUsed);

    function setUp() public {
        storage_ = new StorageOptimization();
    }


    function testGasFirstUpdate() public {
        uint256 startGas = gasleft();
        storage_.updateBalance(USER1, 100);
        uint256 gasUsed = startGas - gasleft();
        emit log_named_uint("Gas used for first update (cold)", gasUsed);
    }

    function testGasSecondUpdate() public {
        storage_.updateBalance(USER1, 100);

        uint256 startGas = gasleft();
        storage_.updateBalance(USER1, 200);
        uint256 gasUsed = startGas - gasleft();
        emit log_named_uint("Gas used for second update (warm)", gasUsed);
    }

    function testGasFirstRead() public {
        storage_.updateBalance(USER1, 100);

        uint256 startGas = gasleft();
        storage_.getBalance(USER2); // Cold read for new address
        uint256 gasUsed = startGas - gasleft();
        emit log_named_uint("Gas used for first read (cold)", gasUsed);
    }

    function testGasSecondRead() public {
        storage_.updateBalance(USER1, 100);
        storage_.getBalance(USER1); // Warm up the slot

        uint256 startGas = gasleft();
        storage_.getBalance(USER1);
        uint256 gasUsed = startGas - gasleft();
        emit log_named_uint("Gas used for second read (warm)", gasUsed);
    }

    function testGasBatchUpdate() public {
        address[] memory users = new address[](3);
        users[0] = USER1;
        users[1] = USER2;
        users[2] = address(0x3);

        uint256[] memory balances = new uint256[](3);
        balances[0] = 100;
        balances[1] = 200;
        balances[2] = 300;

        uint256 startGas = gasleft();
        storage_.batchUpdateBalances(users, balances);
        uint256 gasUsed = startGas - gasleft();
        emit log_named_uint("Gas used for batch update of 3 users", gasUsed);
    }
}
