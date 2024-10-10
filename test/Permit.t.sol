// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/Permit/PermitToken.sol";
import {console} from "forge-std/console.sol";

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract Permit is Test {
    PermitToken token;
    address owner;
    address recipient;

    uint256 recipientPrivateKey;
    uint256 ownerPrivateKey;

    bytes32 constant PERMIT_TYPEHASH =
        keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");

    function setUp() public {
        ownerPrivateKey = 0xA11CE;
        recipientPrivateKey = 0xB0B;

        owner = vm.addr(ownerPrivateKey);
        vm.prank(owner);
        token = new PermitToken();

        recipient = vm.addr(recipientPrivateKey);
        deal(owner, 1 ether);
    }

    function testTransferWithPermit() public {
        uint256 amount = 100 * 10 ** 18;
        uint256 deadline = block.timestamp + 1 days;

        (uint8 v, bytes32 r, bytes32 s) =
            _createPermitSignature(owner, recipient, amount, token.nonces(owner), deadline);

        uint256 initialOwnerBalance = token.balanceOf(owner);
        uint256 initialRecipientBalance = token.balanceOf(recipient);

        vm.prank(owner);
        token.transferWithPermit(recipient, amount, deadline, v, r, s);

        assertEq(token.balanceOf(owner), initialOwnerBalance - amount, "Owner balance not decreased correctly");
        assertEq(
            token.balanceOf(recipient), initialRecipientBalance + amount, "Recipient balance not increased correctly"
        );
    }

    function testTransferWithPermit_RevertOnFail() public {
        uint256 amount = 100 * 10 ** 18;
        uint256 deadline = block.timestamp + 1 days;

        (uint8 v, bytes32 r, bytes32 s) =
            _createPermitSignature(owner, recipient, amount, token.nonces(owner), deadline);

        // expire deadline
        vm.warp(block.timestamp + 2 days);
        vm.expectRevert();

        vm.prank(owner);
        token.transferWithPermit(recipient, amount, deadline, v, r, s);
    }

    function _createPermitSignature(address owner, address spender, uint256 value, uint256 nonce, uint256 deadline)
        internal
        view
        returns (uint8 v, bytes32 r, bytes32 s)
    {
        bytes32 structHash = keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonce, deadline));
        bytes32 digest = keccak256(abi.encodePacked("\x19\x01", token.DOMAIN_SEPARATOR(), structHash));
        (v, r, s) = vm.sign(ownerPrivateKey, digest);
    }
}
