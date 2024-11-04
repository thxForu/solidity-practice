// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/Test.sol";
import "../src/UUPS/TokenV1.sol";
import "../src/UUPS/TokenV2.sol";
import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract TokenTest is Test {
    TokenV1 public implementationV1;
    TokenV2 public implementationV2;
    ERC1967Proxy public proxy;
    TokenV1 public proxyAsV1;
    TokenV2 public proxyAsV2;
    
    address owner = address(0x123);
    address user = address(0x456);

    function setUp() public {
        vm.startPrank(owner);

        implementationV1 = new TokenV1();
        
        bytes memory initData = abi.encodeWithSelector(TokenV1.initialize.selector);
        
        proxy = new ERC1967Proxy(
            address(implementationV1),
            initData
        );
        
        proxyAsV1 = TokenV1(address(proxy));
    }

    function test_InitialState() public {
        assertEq(proxyAsV1.name(), "MyToken");
        assertEq(proxyAsV1.symbol(), "MTK");
        assertEq(proxyAsV1.owner(), owner);
    }

    function test_Mint() public {
        uint256 amount = 1000 * 10**18;
        proxyAsV1.mint(user, 1000 * 10**18);
        
        assertEq(proxyAsV1.balanceOf(user), amount);
        assertEq(proxyAsV1.totalSupply(), amount);
    }

    function test_UpgradeToV2() public {
        implementationV2 = new TokenV2();
        
        proxyAsV1.upgradeToAndCall(address(implementationV2), "");
        
        proxyAsV2 = TokenV2(address(proxy));
        
        assertEq(proxyAsV2.name(), "MyToken");
        assertEq(proxyAsV2.symbol(), "MTK");
        
        uint256 maxSupply = 1000000 * 10**18;
        proxyAsV2.setMaxSupply(maxSupply);
        assertEq(proxyAsV2.maxSupply(), maxSupply);
        
        uint256 amount = maxSupply + 1;
        vm.expectRevert("Exceeds max supply");
        proxyAsV2.mint(user, amount);
        
        amount = maxSupply;
        proxyAsV2.mint(user, amount);
        assertEq(proxyAsV2.balanceOf(user), amount);
    }

    function test_OnlyOwnerCanUpgrade() public {
        implementationV2 = new TokenV2();
        
        vm.stopPrank();
        vm.startPrank(user);
        
        vm.expectRevert();
        proxyAsV1.upgradeToAndCall(address(implementationV2), "");
    }
}