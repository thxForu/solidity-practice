// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";
import "@openzeppelin/contracts/proxy/transparent/ProxyAdmin.sol";

contract MyProxy is TransparentUpgradeableProxy {
    constructor(address _logic, address initialOwner, bytes memory _data)
        TransparentUpgradeableProxy(_logic, initialOwner, _data)
    {}
}