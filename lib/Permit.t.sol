// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/Permint/PermintToken.sol";
import {console} from "forge-std/console.sol";

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/cryptography/EIP712.sol";

contract Permit is Test, EIP712("PermitToken", "1")  {
    PermitToken token;
    address owner;
    address spender; 

    uint256 spenderPrivateKey; 
    uint256 ownerPrivateKey;

   bytes32 constant PERMIT_TYPEHASH = keccak256(
        "Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"
    );

    function setUp() public {
        token = new PermitToken();

        ownerPrivateKey = 0xA11CE;
        spenderPrivateKey = 0xB0B;

        owner = vm.addr(ownerPrivateKey);
        spender = vm.addr(spenderPrivateKey);
        deal(owner, 1 ether);
    }

    function testTransferWithPermit() public {
        uint256 value = 100 * 10**18;
        uint256 deadline = block.timestamp + 1 days;
        uint8 v;
        bytes32 r;
        bytes32 s;
        console.log("Owner:", owner);
        console.log("Spender:", spender);
        console.log("Contract address:", address(this));
        
        uint256 nonce = token.nonces(owner);
        console.log("Nonce:", nonce);

        bytes32 digest = _hashTypedDataV4(
            keccak256(
                abi.encode(
                    PERMIT_TYPEHASH,
                    owner,
                    spender,
                    value,
                    token.nonces(owner),
                    deadline
                )
            )
        );

        (v, r, s) = vm.sign(ownerPrivateKey, digest);
        console.log("v:", v);
        console.logBytes32(r);
        // console.log();
        console.logBytes32(s);
        vm.prank(spender);

        console.logBytes32(digest);

        token.transferWithPermit(spender, value, deadline, v, r, s);

        assertEq(token.balanceOf(spender), value);
    }
}