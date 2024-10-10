// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract PermitToken is ERC20, ERC20Permit {
    uint256 public constant initialSupply = 1000000 * 10 ** 18;

    constructor() ERC20("PermitToken", "PT") ERC20Permit("PermitToken") {
        _mint(msg.sender, initialSupply);
    }

    function transferWithPermit(address recipient, uint256 amount, uint256 deadline, uint8 v, bytes32 r, bytes32 s)
        external
    {
        permit(msg.sender, recipient, amount, deadline, v, r, s);

        _transfer(msg.sender, recipient, amount);
    }
}
