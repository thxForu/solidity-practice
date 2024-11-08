// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "./TokenV1.sol";

contract TokenV2 is TokenV1 {
    uint256 public maxSupply;

    function setMaxSupply(uint256 _maxSupply) public onlyOwner {
        maxSupply = _maxSupply;
    }

    function mint(address to, uint256 amount) public override onlyOwner {
        require(totalSupply() + amount <= maxSupply, "Exceeds max supply");
        super.mint(to, amount);
    }
}
