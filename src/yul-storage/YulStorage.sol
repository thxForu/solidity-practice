// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract YulStorage {
    // slot = | bytes15 (120 bits) | uint88 (88 bits) | = 208 bits total
    bytes32 private slot0;

    function setBytes15(bytes15 data) public {
        assembly {
            let value := sload(slot0.slot)
            let mask := sub(shl(88, 1), 1)
            let uint88Value := and(value, mask)

            mstore(0x00, data)
            let bytes15Value := mload(0x00)
            let newValue := or(bytes15Value, uint88Value)

            sstore(slot0.slot, newValue)
        }
    }

    function getBytes15() public view returns (bytes15) {
        bytes15 result;

        assembly {
            let value := sload(slot0.slot)
            let mask := not(sub(shl(88, 1), 1))
            let bytes15Value := and(value, mask)

            mstore(0x00, bytes15Value)
            result := mload(0x00)
        }

        return result;
    }

    function setUint88(uint88 value) public {
        assembly {
            let slotValue := sload(slot0.slot)
            let mask := sub(shl(88, 1), 1)
            let bytes15Value := and(slotValue, not(mask))
            let newValue := or(bytes15Value, and(value, mask))

            sstore(slot0.slot, newValue)
        }
    }

    function getUint88() public view returns (uint88) {
        uint88 result;

        assembly {
            let mask := sub(shl(88, 1), 1)
            result := and(sload(slot0.slot), mask)
        }

        return result;
    }
}
