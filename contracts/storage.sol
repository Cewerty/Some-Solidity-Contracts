// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title Storage
 * @notice This contract provides functionality to store and retrieve data hashed with SHA256, associating it with user addresses.
 * @dev It utilizes double SHA256 hashing for data storage and user ID creation for enhanced security.
 */
contract Storage {

    /**
     * @notice Mapping of user IDs (hashed addresses) to their stored data (hashed values).
     */
    mapping (bytes32 => bytes32) UsersStorage;

    /**
     * @notice Hashes a string value using double SHA256.
     * @dev  First, it hashes the input string using SHA256. Then, it hashes the resulting hash again using SHA256.
     * @param value The string value to be hashed.
     * @return The double SHA256 hash of the input string.
     */
    function hashStorage(string memory value) public pure returns(bytes32) {
        bytes32 hashed_value = sha256(abi.encodePacked(value));
        return sha256(abi.encodePacked(hashed_value));
    }

    /**
     * @notice Creates a unique user ID by hashing the user's address using double SHA256.
     * @dev The user's address is first hashed with SHA256, and then the result is hashed again with SHA256.
     * @param user The user's address.
     * @return The double SHA256 hash of the user's address, serving as a unique ID.
     */
    function createID(address user) public pure returns(bytes32) {
        bytes32 hashed_sender = sha256(abi.encodePacked(user));
        return sha256(abi.encodePacked(hashed_sender));
    }

    /**
     * @notice Creates a new storage entry for the sender, associating a hashed value with their ID.
     * @dev  The sender's address is used to generate a unique ID using `createID`.
     *       The provided string value is hashed using `hashStorage`.
     *       The hashed value is then stored in `UsersStorage` under the generated ID.
     * @param value The string value to be stored after hashing.
     */
    function createStorage(string memory value) public {
        bytes32 id = createID(msg.sender);
        bytes32 hashed_value = hashStorage(value);
        UsersStorage[id] = hashed_value;
    }

    /**
     * @notice Retrieves the hashed value associated with the sender's ID.
     * @dev The sender's address is used to generate their unique ID using `createID`.
     *      The function then returns the stored hashed value associated with that ID.
     * @return The hashed value stored for the sender.
     */
    function getHashedValue() public view returns(bytes32) {
        bytes32 id = createID(msg.sender);
        return UsersStorage[id];
    }

    /**
     * @notice Changes the hashed value associated with the sender's ID.
     * @dev Reverts if no storage exists for the sender.
     *      The sender's address is used to generate their unique ID using `createID`.
     *      The provided string value is hashed using `hashStorage`.
     *      The existing hashed value associated with the ID is overwritten with the new hashed value.
     * @param value The new string value to be stored after hashing.
     */
    function changeHashedValue(string memory value) public {
        bytes32 id = createID(msg.sender);
        require(UsersStorage[id] != '', "Storage from this user doest exist");
        UsersStorage[id] = hashStorage(value);
    }

    /**
     * @notice Deletes the storage entry associated with the sender's ID.
     * @dev Reverts if no storage exists for the sender.
     *      The sender's address is used to generate their unique ID using `createID`.
     *      The storage entry associated with that ID is deleted.
     */
    function deleteHashedValue() public {
        bytes32 id = createID(msg.sender);
        require(UsersStorage[id] != '', "Storage from this user doest exist");
        delete UsersStorage[id];
    }
}