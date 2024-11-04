// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "forge-std/console.sol";

contract TransparentTokenV2 is ERC20Upgradeable, ReentrancyGuardUpgradeable, OwnableUpgradeable {
    uint256 public maxSupply;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize() public reinitializer(2) {
        maxSupply = 1000000 * 10**18;
    }

    function mint(address to, uint256 amount) public onlyOwner nonReentrant {
        require(totalSupply() + amount <= maxSupply, "Exceeds max supply");
        _mint(to, amount);
    }

    function burn(uint256 amount) public nonReentrant {
        _burn(msg.sender, amount);
    }
}