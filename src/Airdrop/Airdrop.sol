// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

import {IAirdrop} from "src/interfaces/Airdrop/IAirdrop.sol";

contract Airdrop is IAirdrop {
    using SafeERC20 for IERC20;
    IERC20 public token;

    bytes32 public immutable ROOT;
    uint256 public immutable USER_LIMIT;
    uint256 public immutable TOKEN_LIMIT_PER_USER;
    uint256 public totalUsers;

    mapping(address => bool) public userHasClaimed;

    /**
     * @notice Constructor to initialize token and airdrop limits
     * @param _token The token to be distributed
     * @param user_limit The maximum number of users allowed to claim tokens
     * @param token_limit The maximum amount of tokens each user can claim
     * @param root The Merkle root of the whitelisted users for the airdrop
     */
    constructor(IERC20 _token, uint256 user_limit, uint256 token_limit, bytes32 root) {
        ROOT = root;
        token = _token;
        USER_LIMIT = user_limit;
        TOKEN_LIMIT_PER_USER = token_limit;
    }

    /**
     * @notice Allows eligible users to claim their airdrop tokens
     * @param amount The amount of the airdrop
     * @param proof The Merkle proof to verify the user
     */
    function claim(uint128 amount, bytes32[] calldata proof) public {
        if (userHasClaimed[msg.sender]) revert AlreadyClaimed();
        if (totalUsers >= USER_LIMIT) revert ExceedUserAirdropLimit();
        if (token.balanceOf(address(this)) < amount) revert NotEnoughBalance();
        if (amount > TOKEN_LIMIT_PER_USER) revert ExceedMaxMintAmount();

        bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
        if (!MerkleProof.verify(proof, ROOT, leaf)) revert InvalidUser();

        userHasClaimed[msg.sender] = true;
        totalUsers++;

        token.safeTransfer(msg.sender, amount);
        emit TokensClaimed(msg.sender, amount);
    }
}
