// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

interface IAirdrop {
    /**
     * @param toUser The address of the user receiving the airdrop
     * @param amount The amount of the airdrop
     */
    event TokensClaimed(address indexed toUser, uint256 amount);

    error AlreadyClaimed();
    error ExceedUserAirdropLimit();
    error InvalidUser();
    error NotEnoughBalance();
    error ExceedMaxMintAmount();
}