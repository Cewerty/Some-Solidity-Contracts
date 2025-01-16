// SPDX-License-Identifier: MIT
import "remix_tests.sol"; // Import тестового фреймворка Remix
import {wallet as Wallet} from "../contracts/wallet.sol";   // Импортируем тестируемый контракт

pragma solidity ^0.8.0;


contract WalletTest {

    Wallet public walletInstance;

    address owner; // Адрес контракта-теста будет владельцем кошелька
    address user1 = address(0x123);

    constructor() {
      owner = msg.sender;
    }

    /// @notice Перед каждым тестом разворачиваем новый экземпляр контракта
    function beforeEach() public {
        walletInstance = new Wallet();
    }

    /// @notice Тестируем функцию setUserBalance с пополнением баланса
    function testSetUserBalance() public payable {
        // Пополняем баланс на 1 ETH
        walletInstance.setUserBalance{value: 1 ether}();

        (uint256 balance, ) = walletInstance.getUserInfo(owner);
        Assert.equal(balance, 1 ether, "Balance should be 1 ETH");
    }

    /// @notice Тестируем успешное снятие средств в пределах лимита
    function testDrawFromWalletWithinLimit() public payable {
        // Устанавливаем лимит 0.5 ETH
        walletInstance.setMoneyLimit(0.5 ether);

        // Пополняем баланс на 1 ETH
        walletInstance.setUserBalance{value: 1 ether}();

        // Пытаемся снять 0.5 ETH
        walletInstance.drawFromWallet(0.5 ether);

        (uint256 balance, ) = walletInstance.getUserInfo(owner);
        Assert.equal(balance, 0.5 ether, "Balance should be 0.5 ETH after withdrawal");
    }

    // /// @notice Тестируем невозможность снятия суммы, превышающей лимит
    // function testDrawFromWalletExceedsLimit() public payable {
    //     walletInstance.setMoneyLimit(0.5 ether);
    //     walletInstance.setUserBalance{value: 1 ether}();

    //     // Ожидаем, что вызов приведет к ошибке
    //     try walletInstance.drawFromWallet(0.6 ether) {
    //         Assert.fail("Should have thrown Transaction exceeds limit");
    //     } catch Error(string memory reason) {
    //         Assert.equal(reason, "Transaction exceeds limit", "Expected Transaction exceeds limit error");
    //     }
    // }

    // /// @notice Тестируем невозможность снятия суммы, превышающей баланс
    // function testDrawFromWalletExceedsBalance() public payable {
    //     walletInstance.setMoneyLimit(2 ether);
    //     walletInstance.setUserBalance{value: 1 ether}();

    //     // Ожидаем, что вызов приведет к ошибке
    //     try walletInstance.drawFromWallet(1.5 ether) {
    //         Assert.fail("Should have thrown Not enough money");
    //     } catch Error(string memory reason) {
    //         Assert.equal(reason, "Not enough money", "Expected Not enough money error");
    //     }
    // }

    /// @notice Тестируем отправку средств другому пользователю в пределах лимита
    function testSendFromWalletWithinLimit() public payable {
        walletInstance.setMoneyLimit(1 ether);
        walletInstance.setUserBalance{value: 2 ether}();

        // Отправляем 1 ETH пользователю user1
        walletInstance.sendFromWallet(user1, 1 ether);

        (uint256 balanceOwner, ) = walletInstance.getUserInfo(owner);
        (uint256 balanceUser1, ) = walletInstance.getUserInfo(user1);

        Assert.equal(balanceOwner, 1 ether, "Owner balance should be 1 ETH after sending");
        Assert.equal(balanceUser1, 0, "User1 balance in contract should remain 0");
    }

    /// @notice Тестируем получение пользователем отправленных средств
    function testUserReceivesEther() public payable {
        walletInstance.setMoneyLimit(1 ether);
        walletInstance.setUserBalance{value: 1 ether}();

        // Начальный баланс user1
        uint256 initialBalance = user1.balance;

        // Отправляем 1 ETH пользователю user1
        walletInstance.sendFromWallet(user1, 1 ether);

        // Проверяем, что баланс user1 увеличился на 1 ETH
        uint256 finalBalance = user1.balance;
        Assert.equal(finalBalance - initialBalance, 1 ether, "User1 should receive 1 ETH");
    }
}
