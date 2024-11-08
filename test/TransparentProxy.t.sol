// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/Test.sol";
import "../src/Transparent Proxy/LogicV1.sol";
import "../src/Transparent Proxy/LogicV2.sol";
import "../src/Transparent Proxy/Proxy.sol";
import "@openzeppelin/contracts/proxy/transparent/ProxyAdmin.sol";

contract ProxyTest is Test {
    LogicV1 public implementationV1;
    LogicV2 public implementationV2;
    MyProxy public proxy;
    ProxyAdmin public proxyAdmin;
    LogicV1 public wrappedProxyV1;
    LogicV2 public wrappedProxyV2;

    function setUp() public {
        implementationV1 = new LogicV1();

        proxyAdmin = new ProxyAdmin(address(this));

        bytes memory initData = abi.encodeWithSelector(LogicV1.initialize.selector);

        proxy = new MyProxy(address(implementationV1), address(proxyAdmin), initData);

        wrappedProxyV1 = LogicV1(address(proxy));
    }

    /*
    function test_ProxyInitialDeployment() public {
        assertEq(wrappedProxyV1.getValue(), 10);
        
        wrappedProxyV1.setValue(100);
        
        assertEq(wrappedProxyV1.getValue(), 100);
    }

    function test_UpgradeToV2() public {
        assertEq(wrappedProxyV1.getValue(), 10);
        
        implementationV2 = new LogicV2();
        
        proxyAdmin.upgradeAndCall(
            ITransparentUpgradeableProxy(address(proxy)),
            address(implementationV2),
            ""
        );
        
        wrappedProxyV2 = LogicV2(address(proxy));
        
        assertEq(wrappedProxyV2.getValue(), 10);
        
        wrappedProxyV2.increment();
        assertEq(wrappedProxyV2.getValue(), 11);
        
        wrappedProxyV2.setValue(100);
        assertEq(wrappedProxyV2.getValue(), 100);
    }

    function test_StorageConsistency() public {
        wrappedProxyV1.setValue(42);
        
        implementationV2 = new LogicV2();
        proxyAdmin.upgradeAndCall(
            ITransparentUpgradeableProxy(address(proxy)),
            address(implementationV2),
            ""
        );
        wrappedProxyV2 = LogicV2(address(proxy));
        
        assertEq(wrappedProxyV2.getValue(), 42);
    }
    */
}
