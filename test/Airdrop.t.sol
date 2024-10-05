// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/Test.sol";
import "../src/Airdrop/Airdrop.sol";
import "../src/TestToken.sol";
import {Merkle} from "lib/murky/src/Merkle.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "forge-std/console2.sol";

contract AirdropTest is Test, Merkle, IAirdrop {
    Airdrop airdrop;
    TestToken token;

    address alice = address(0x123);
    address bob = address(0x234);
    bytes32 root;
    uint256 USER_LIMIT = 5;
    uint256 TOKEN_LIMIT_PER_USER = 1000 * 10 ** 18;

    bytes32[] leafs;

    function setUp() public {
        token = new TestToken();

        leafs.push(keccak256(abi.encodePacked(alice)));
        leafs.push(keccak256(abi.encodePacked(bob)));
        root = getRoot(leafs);

        airdrop = new Airdrop(IERC20(address(token)), USER_LIMIT, TOKEN_LIMIT_PER_USER, root);

        token.mint(address(airdrop), 5000 * 10 ** 18);
    }

    function testClaimTokens() public {
        uint256 aliceIndex = 0;
        bytes32[] memory proof = getProof(leafs, aliceIndex);

        vm.prank(alice);
        airdrop.claim(1000 * 10 ** 18, proof);

        assertEq(token.balanceOf(alice), 1000 * 10 ** 18);
    }

    function testOnlyOneClaimTokens() public {
        uint256 aliceIndex = 0;
        bytes32[] memory proof = getProof(leafs, aliceIndex);

        vm.prank(alice);
        airdrop.claim(1000 * 10 ** 18, proof);

        assertEq(token.balanceOf(alice), 1000 * 10 ** 18);

        vm.prank(alice);
        vm.expectRevert(AlreadyClaimed.selector);
        airdrop.claim(1000 * 10 ** 18, proof);

        assertEq(token.balanceOf(alice), 1000 * 10 ** 18);
    }

    function testClaimByNonWhitelisted() public {
        address notWhitelisted = address(0x999);
        bytes32[] memory proof = getProof(leafs, 1);

        vm.expectRevert(InvalidUser.selector);
        vm.prank(notWhitelisted);

        airdrop.claim(1000 * 10 ** 18, proof);
    }

    function testClaimWithInvalidProof() public {
        bytes32[] memory proof = getProof(leafs, 0);

        vm.expectRevert(InvalidUser.selector);
        vm.prank(bob);

        airdrop.claim(1000 * 10 ** 18, proof);
    }
}
