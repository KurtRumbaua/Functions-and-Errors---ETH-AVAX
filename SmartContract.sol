// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TestContract {
    address public owner;
    uint256 public value;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }

    function setValue(uint256 newValue) public onlyOwner {
        // Using require to validate the input
        require(newValue >= 0, "Value must be non-negative");
        value = newValue;
    }

    function incrementValue() public {
        // Using assert to ensure the value never exceeds a certain limit
        uint256 newValue = value + 1;
        assert(newValue > value); // This should always be true unless overflow occurs
        value = newValue;
    }

    function resetValue() public onlyOwner {
        // Using revert to handle an error condition
        if (value == 0) {
            revert("Value is already zero");
        }
        value = 0;
    }
}
