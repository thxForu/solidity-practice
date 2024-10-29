// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract LogicV1 is Initializable {
    uint256 public value;

   /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }
    
    function initialize() initializer public {
        value = 10;
    }

    function getValue() public view returns (uint256) {
        return value;
    }

    function setValue(uint256 newValue) public {
        value = newValue;
    }
}