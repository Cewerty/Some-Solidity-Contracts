// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title Counter
 * @notice This contract implements a counter with increment, decrement, and reset functionalities, along with settable upper and lower bounds.
 * @dev The counter can be incremented or decremented within a defined range and can be reset to zero.
 */
contract Counter {
    /**
     * @notice The current value of the counter.
     */
    uint256 public count;

    /**
     * @notice The upper bound for the counter value.
     */
    uint internal biggestNumber;

    /**
     * @notice The lower bound for the counter value.
     */
    uint internal smallestNumber = 0;

    /**
     * @notice Emitted when the counter is incremented or decremented successfully.
     * @param number The new value of the counter after the operation.
     */
    event CountedTo(uint256 number);

    /**
     * @notice Emitted when the counter is reset to zero.
     */
    event CouterRestarted();

    /**
     * @notice Emitted when the upper bound of the counter is set.
     */
    event biggestNumberIsSetted();

    /**
     * @notice Emitted when the lower bound of the counter is set.
     */
    event smallestNumberIsSetted();

    /**
     * @notice Retrieves the current value of the counter.
     * @return The current counter value.
     */
    function getCount() public view returns (uint256) {
        return count;
    }

    /**
     * @notice Increments the counter by 1.
     * @dev Reverts if incrementing the counter would exceed the upper bound (`biggestNumber`).
     *      Emits a `CountedTo` event after successfully incrementing the counter.
     */
    function increment() public {
        require(count < biggestNumber, "Couter: count is bigger than biggest number");
        count += 1;
        emit CountedTo(count);
    }

    /**
     * @notice Decrements the counter by 1.
     * @dev Reverts if the counter is already at the lower bound (`smallestNumber`) or if attempting to decrement below it.
     * Emits a `CountedTo` event after successfully decrementing the counter.
     */
    function decrement() public {
        require(count > 0, "Counter: count cannot be negative");
        require(count > smallestNumber, "Couter: count is smaller than smallest number");
        count -= 1;
        emit CountedTo(count);
    }

    /**
     * @notice Resets the counter to zero.
     * @dev Emits a `CouterRestarted` event after resetting the counter.
     */
    function restartCounter () public {
        count = 0;
        emit CouterRestarted();
    }

    /**
     * @notice Sets the upper bound for the counter.
     * @dev Emits a `biggestNumberIsSetted` event after setting the upper bound.
     * @param value The new upper bound value.
     */
    function setBiggestNumber(uint256 value) public {
        biggestNumber = value;
        emit biggestNumberIsSetted();
    }

    /**
     * @notice Sets the lower bound for the counter.
     * @dev Emits a `smallestNumberIsSetted` event after setting the lower bound.
     * @param value The new lower bound value.
     */
    function setSmallestNumber(uint256 value) public {
        smallestNumber = value;
        emit smallestNumberIsSetted();
    }
}
