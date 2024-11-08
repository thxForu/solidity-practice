// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract StorageOptimization {
    uint256[] public balances;

    mapping(address => uint256) public balanceIndex;

    event BalanceUpdated(address indexed user, uint256 newBalance);

    function updateBalance(address user, uint256 newBalance) public {
        uint256 index = balanceIndex[user];

        if (index == 0) {
            balances.push(newBalance);
            balanceIndex[user] = balances.length;
        } else {
            balances[index - 1] = newBalance;
        }

        emit BalanceUpdated(user, newBalance);
    }

    /**
     * @dev Get balance of a user
     * @param user Address of the user
     * @return Balance of the user
     */
    function getBalance(address user) public view returns (uint256) {
        uint256 index = balanceIndex[user];
        if (index == 0) return 0;
        return balances[index - 1];
    }

    /**
     * @dev Batch update balances to optimize gas usage
     * @param users Array of user addresses
     * @param newBalances Array of new balances
     */
    function batchUpdateBalances(address[] calldata users, uint256[] calldata newBalances) public {
        require(users.length == newBalances.length, "Arrays length mismatch");

        for (uint256 i = 0; i < users.length; i++) {
            updateBalance(users[i], newBalances[i]);
        }
    }
}
