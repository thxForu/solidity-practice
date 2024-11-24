// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/Test.sol";
import "../src/yul-storage/YulStorage.sol";

contract YulStorageTest is Test {
    YulStorage public yulStorage;

    function setUp() public {
        yulStorage = new YulStorage();
    }

        function testSetAndGetBytes15() public {
        bytes15 testData = bytes15(hex"01234567890abcde");
        
        yulStorage.setBytes15(testData);
        bytes15 retrievedData = yulStorage.getBytes15();
        
        assertEq(retrievedData, testData);
    }

    function testSetAndGetUint88() public {
        uint88 maxValue = type(uint88).max;
        yulStorage.setUint88(maxValue);
        assertEq(yulStorage.getUint88(), maxValue);

        uint88 minValue = type(uint88).min;
        yulStorage.setUint88(minValue);
        assertEq(yulStorage.getUint88(), minValue);

        uint88 mediumValue = 123456789;
        yulStorage.setUint88(mediumValue);
        assertEq(yulStorage.getUint88(), mediumValue);
    }

    function testCombinedStorage() public {
        bytes15 testBytes = bytes15(hex"01234567890abcde");
        uint88 testUint = type(uint88).max;

        yulStorage.setBytes15(testBytes);
        yulStorage.setUint88(testUint);

        assertEq(yulStorage.getBytes15(), testBytes, "Bytes15 should remain intact after uint88 storage");
        assertEq(yulStorage.getUint88(), testUint, "Uint88 should remain intact after bytes15 storage");

        bytes15 newTestBytes = bytes15(hex"012345678999abcde0");
        uint88 newTestUint = type(uint88).min;

        yulStorage.setUint88(newTestUint);
        yulStorage.setBytes15(newTestBytes);

        assertEq(yulStorage.getBytes15(), newTestBytes, "Bytes15 should be stored correctly");
        assertEq(yulStorage.getUint88(), newTestUint, "Uint88 should remain intact after bytes15 update");
    }
}
