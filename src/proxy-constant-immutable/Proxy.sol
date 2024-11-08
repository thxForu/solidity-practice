// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Proxy {
    address public implementation;

    event ImplementationUpgraded(address indexed previousImpl, address indexed newImpl);

    constructor(address _implementation) {
        require(_implementation != address(0), "Invalid implementation address");
        implementation = _implementation;
    }

    function upgradeImplementation(address _newImplementation) external {
        require(_newImplementation != address(0), "Invalid new implementation address");
        address previousImpl = implementation;

        implementation = _newImplementation;
        emit ImplementationUpgraded(previousImpl, _newImplementation);
    }

    fallback() external payable {
        address _implementation = implementation;
        require(_implementation != address(0), "Implementation not set");

        assembly {
            calldatacopy(0, 0, calldatasize())
            let result := delegatecall(gas(), _implementation, 0, calldatasize(), 0, 0)
            returndatacopy(0, 0, returndatasize())

            switch result
            case 0 { revert(0, returndatasize()) }
            default { return(0, returndatasize()) }
        }
    }

    receive() external payable {}
}
