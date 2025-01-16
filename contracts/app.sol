
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract working_with_vars {

    struct User{
        string name;
        address User_address;
        uint256 balance;
    }

    address public owner;

    enum Deliver_Status {
        Pending,
        Shipped,
        Delivered,
        Cancelled
    }

    constructor() {
        owner = msg.sender;
    }


    mapping(address => User) public payments;

    function anti_bool(bool inputed_bool) public pure returns(bool) {
        return !inputed_bool;
    }

    function eq_nums(int256 first_number, int256 second_number) public pure  returns(bool) {
       bool result = first_number > second_number ? true : false;
       return result;
    }

    function send_eth(string memory sender_name) public payable {
        payments[msg.sender] = User({
            name: sender_name,
            User_address: msg.sender,
            balance: msg.value
        });
    }

    function balance_checker(address address_for_check) public view returns(bool) {
        uint256 result = address_for_check.balance;
        bool check_result = result == 0;
        return check_result;
    }

    function concat_strings(string memory first_string, string memory second_string) public pure returns (string memory) {
        bytes memory concatation = abi.encodePacked(bytes(first_string), bytes(second_string));
        return string(concatation);
    }

    function slice_strings(string memory sended_string, uint index) public pure  returns(string memory) {
        bytes memory byted_string = bytes(sended_string);

        if (index == byted_string.length) {return '';}

        require(index > byted_string.length, "Error, Index bigger than array length");

        uint array_length = byted_string.length;
        bytes memory slice = new bytes(array_length - index);
        
        for (uint i = index; i < array_length; i++) {
            slice[i - index] = byted_string[i];
        }

    return string(slice);
    }

    function back_enums(Deliver_Status enum_value) public pure returns(string memory) {
        if (enum_value == Deliver_Status.Pending) {return "Pending";}
        else if (enum_value == Deliver_Status.Shipped) {return "Shipped";}
        else if (enum_value == Deliver_Status.Delivered) {return "Delivered";}
        else if (enum_value == Deliver_Status.Cancelled) {return "Cancelled";}
        else {revert("Error, this deliver status does not exist!");}
    }
}