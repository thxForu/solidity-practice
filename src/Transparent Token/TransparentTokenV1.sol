// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract TransparentTokenV1 is ERC20Upgradeable, ReentrancyGuardUpgradeable, OwnableUpgradeable {
    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize() public initializer {
        __ERC20_init("TransparentToken", "TT");
        __ReentrancyGuard_init();
        __Ownable_init(msg.sender);
    }

    function mint(address to, uint256 amount) public onlyOwner nonReentrant {
        _mint(to, amount);
    }
}