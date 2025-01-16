// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title Wallet
 * @notice This contract implements a simple wallet functionality, allowing users to deposit, withdraw, and send funds.
 * @dev  The contract provides basic wallet operations, including balance checks, deposits, withdrawals, and transfers.
 */
contract wallet {

    /**
     * @notice Represents the balance and withdrawal limit for a user.
     * @param balance The current balance of the user.
     * @param moneyLimit The maximum amount of money that can be withdrawn by the user at one time.
     */
    struct balanceStatus {
        uint256 balance;
        uint256 moneyLimit;
    }

    /**
     * @notice Mapping of user addresses to their balance status.
     */
    mapping(address => balanceStatus) public wallet_users;

    /**
     * @notice Returns the balance and withdrawal limit for a given user address.
     * @param userAddress The address of the user.
     * @return The balance and withdrawal limit of the user.
     */
    function getUserInfo(address userAddress) public  view  returns(uint, uint) {
        return (wallet_users[userAddress].balance, wallet_users[userAddress].moneyLimit);
    }

    /**
     * @notice Allows a user to deposit funds into their wallet.
     * @dev If the user already has a balance, the deposited amount is added to it. Otherwise, the balance is set to the deposited amount.
     */
    function setUserBalance() public payable {
        (uint balance, ) = getUserInfo(msg.sender);
        if (balance > 0) {
            wallet_users[msg.sender].balance = balance + msg.value;
        }
        else {
            wallet_users[msg.sender].balance = msg.value;
        }
    }

    /**
     * @notice Allows the user to set a withdrawal limit for their account.
     * @param newLimit The new withdrawal limit.
     */
    function setMoneyLimit(uint newLimit) public  {
        wallet_users[msg.sender].moneyLimit = newLimit;
    }

    /**
     * @notice Allows a user to withdraw funds from their wallet.
     * @dev  Requires the user to have enough balance and the withdrawal amount to be within the user-defined limit.
     *       The function also updates the user's balance after the withdrawal.
     *       Reverts if the user's balance is less than the withdrawal amount or if the withdrawal amount exceeds the user's withdrawal limit.
     * @param drawedValue The amount of money to withdraw.
     */
    function drawFromWallet(uint drawedValue) public payable {
        (uint balance, uint moneyLimit) = getUserInfo(msg.sender);
        require(balance >= drawedValue, "Not enough money");
        require(drawedValue <= moneyLimit, "Transaction bigger than installed limit");
        wallet_users[msg.sender].balance = balance - drawedValue;
        address payable  _to = payable(msg.sender);
        _to.transfer(drawedValue);
    }

    /**
     * @notice Allows a user to send funds from their wallet to another user.
     * @dev Requires the sender to have enough balance and the transfer amount to be within the sender's withdrawal limit.
     *      Updates the sender's balance after the transfer.
     *      Reverts if the sender's balance is less than the transfer amount or if the transfer amount exceeds the sender's withdrawal limit.
     * @param userAddress The address of the recipient.
     * @param sendedValue The amount of money to send.
     */
    function sendFromWallet(address userAddress, uint sendedValue) public payable {
        (uint balance, uint moneyLimit) = getUserInfo(msg.sender);
        require(balance >= sendedValue, "Not enough money");
        require(sendedValue <= moneyLimit, "Transaction bigger than installed limit");
        wallet_users[msg.sender].balance = balance - sendedValue;
        address payable  _to = payable(userAddress);
        _to.transfer(sendedValue);
    }

    /**
     * @notice Allows a user to send funds from their wallet to multiple users.
     * @dev Requires the sender to have enough balance to cover all transfers. Each transfer amount must be within the sender's withdrawal limit.
     *      Reverts if the sender's balance is less than the transfer amount for any recipient or if the transfer amount exceeds the sender's withdrawal limit for any recipient.
     * @param usersAddresses An array of recipient addresses.
     * @param sendedValue The amount of money to send to each recipient.
     */
    function sendFromWalletForUsers(address[] memory usersAddresses, uint sendedValue) public payable {
        (uint balance, uint moneyLimit) = getUserInfo(msg.sender);
        require(balance >= sendedValue, "Not enough money");
        require(sendedValue <= moneyLimit, "Transaction bigger than installed limit");
        for (uint i; i < usersAddresses.length; i++) {
            require(balance >= sendedValue, "Not enough money");
            address payable _to = payable(usersAddresses[i]);
            _to.transfer(sendedValue);
        }
    }

}
