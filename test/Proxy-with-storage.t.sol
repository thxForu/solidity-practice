// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/Test.sol";
import "../src/proxy-constant-immutable/Implementation.sol";
import "../src/proxy-constant-immutable/ImplementationV2.sol";
import "../src/proxy-constant-immutable/Proxy.sol";

contract ProxyTest is Test {
    Implementation implementation;
    ImplementationV2 implementationV2;
    Proxy proxy;
    address user;

    function setUp() public {
        implementation = new Implementation(100);
        proxy = new Proxy(address(implementation));
        implementationV2 = new ImplementationV2(200);
        user = makeAddr("user");
    }

    function testConstantAndImmutableBehavior() public {
        assertEq(Implementation(address(proxy)).getConstant(), "constant");
        assertEq(Implementation(address(proxy)).immutableValue(), 100);

        // set value in proxy storage
        Implementation(address(proxy)).setUserAccess(user, true);

        proxy.upgradeImplementation(address(implementationV2));

        // сonstant and immutable values should change because they are in bytecode
        assertEq(ImplementationV2(address(proxy)).getConstant(), "constant_v2");
        assertEq(ImplementationV2(address(proxy)).immutableValue(), 200);

        // storage value should be the same becouse it's stored in proxy
        assertTrue(ImplementationV2(address(proxy)).userAccess(user));
    }

    function testStorageConsistency() public {
        Implementation(address(proxy)).setUserAccess(user, true);

        proxy.upgradeImplementation(address(implementationV2));

        assertTrue(ImplementationV2(address(proxy)).userAccess(user));
    }
}
