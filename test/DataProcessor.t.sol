// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/Test.sol";
import "../src/calldata/DataProcessor.sol";

contract DataProcessorTest is Test {
    DataProcessor processor;

    function setUp() public {
        processor = new DataProcessor();
    }

    function testGasOptimizationProcessArray() public view {
        uint256[] memory smallArray = new uint256[](10);
        uint256[] memory mediumArray = new uint256[](100);
        uint256[] memory largeArray = new uint256[](1000);

        for (uint256 i = 0; i < smallArray.length; i++) {
            smallArray[i] = i + 1;
        }
        for (uint256 i = 0; i < mediumArray.length; i++) {
            mediumArray[i] = i + 1;
        }
        for (uint256 i = 0; i < largeArray.length; i++) {
            largeArray[i] = i + 1;
        }

        // Small array (10 elements)
        uint256 gasStartCalldata = gasleft();
        processor.processArray(smallArray);
        uint256 gasCalldata = gasStartCalldata - gasleft();

        uint256 gasStartMemory = gasleft();
        processor.processArrayMemory(smallArray);
        uint256 gasMemory = gasStartMemory - gasleft();

        console.log("Small Array (10 elements) - processArray:");
        console.log("Calldata gas used:", gasCalldata);
        console.log("Memory gas used:", gasMemory);
        console.log(
            "Gas difference:",
            gasCalldata > gasMemory ? "Memory saves: " : "Calldata saves: ",
            gasCalldata > gasMemory ? gasCalldata - gasMemory : gasMemory - gasCalldata
        );
        console.log("");

        // Medium array (100 elements)
        gasStartCalldata = gasleft();
        processor.processArray(mediumArray);
        gasCalldata = gasStartCalldata - gasleft();

        gasStartMemory = gasleft();
        processor.processArrayMemory(mediumArray);
        gasMemory = gasStartMemory - gasleft();

        console.log("Medium Array (100 elements) - processArray:");
        console.log("Calldata gas used:", gasCalldata);
        console.log("Memory gas used:", gasMemory);
        console.log(
            "Gas difference:",
            gasCalldata > gasMemory ? "Memory saves: " : "Calldata saves: ",
            gasCalldata > gasMemory ? gasCalldata - gasMemory : gasMemory - gasCalldata
        );
        console.log("");

        // Large array (1000 elements)
        gasStartCalldata = gasleft();
        processor.processArray(largeArray);
        gasCalldata = gasStartCalldata - gasleft();

        gasStartMemory = gasleft();
        processor.processArrayMemory(largeArray);
        gasMemory = gasStartMemory - gasleft();

        console.log("Large Array (1000 elements) - processArray:");
        console.log("Calldata gas used:", gasCalldata);
        console.log("Memory gas used:", gasMemory);
        console.log(
            "Gas difference:",
            gasCalldata > gasMemory ? "Memory saves: " : "Calldata saves: ",
            gasCalldata > gasMemory ? gasCalldata - gasMemory : gasMemory - gasCalldata
        );
        console.log("");
    }

    function testGasOptimizationCalculateSum() public view {
        uint256[] memory smallArray = new uint256[](10);
        uint256[] memory mediumArray = new uint256[](100);
        uint256[] memory largeArray = new uint256[](1000);

        for (uint256 i = 0; i < smallArray.length; i++) {
            smallArray[i] = i + 1;
        }
        for (uint256 i = 0; i < mediumArray.length; i++) {
            mediumArray[i] = i + 1;
        }
        for (uint256 i = 0; i < largeArray.length; i++) {
            largeArray[i] = i + 1;
        }

        console.log("Testing calculateSum function:");
        testSumGasUsage(smallArray, "Small Array (10 elements)");
        console.log("");
        testSumGasUsage(mediumArray, "Medium Array (100 elements)");
        console.log("");
        testSumGasUsage(largeArray, "Large Array (1000 elements)");
        console.log("");
    }

    function testGasOptimizationFindMax() public view {
        uint256[] memory smallArray = new uint256[](10);
        uint256[] memory mediumArray = new uint256[](100);
        uint256[] memory largeArray = new uint256[](1000);

        for (uint256 i = 0; i < smallArray.length; i++) {
            smallArray[i] = i + 1;
        }
        for (uint256 i = 0; i < mediumArray.length; i++) {
            mediumArray[i] = i + 1;
        }
        for (uint256 i = 0; i < largeArray.length; i++) {
            largeArray[i] = i + 1;
        }

        console.log("Testing findMax function:");
        testMaxGasUsage(smallArray, "Small Array (10 elements)");
        console.log("");
        testMaxGasUsage(mediumArray, "Medium Array (100 elements)");
        console.log("");
        testMaxGasUsage(largeArray, "Large Array (1000 elements)");
        console.log("");
    }

    function testSumGasUsage(uint256[] memory array, string memory label) internal view {
        uint256 gasStartCalldata = gasleft();
        processor.calculateSum(array);
        uint256 gasCalldata = gasStartCalldata - gasleft();

        uint256 gasStartMemory = gasleft();
        processor.calculateSumMemory(array);
        uint256 gasMemory = gasStartMemory - gasleft();

        console.log(label, "- calculateSum:");
        console.log("Calldata gas used:", gasCalldata);
        console.log("Memory gas used:", gasMemory);
        console.log(
            "Gas difference:",
            gasCalldata > gasMemory ? "Memory saves: " : "Calldata saves: ",
            gasCalldata > gasMemory ? gasCalldata - gasMemory : gasMemory - gasCalldata
        );
    }

    function testMaxGasUsage(uint256[] memory array, string memory label) internal view {
        uint256 gasStartCalldata = gasleft();
        processor.findMax(array);
        uint256 gasCalldata = gasStartCalldata - gasleft();

        uint256 gasStartMemory = gasleft();
        processor.findMaxMemory(array);
        uint256 gasMemory = gasStartMemory - gasleft();

        console.log(label, "- findMax:");
        console.log("Calldata gas used:", gasCalldata);
        console.log("Memory gas used:", gasMemory);
        console.log(
            "Gas difference:",
            gasCalldata > gasMemory ? "Memory saves: " : "Calldata saves: ",
            gasCalldata > gasMemory ? gasCalldata - gasMemory : gasMemory - gasCalldata
        );
    }
}
