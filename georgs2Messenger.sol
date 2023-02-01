//SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

contract Messenger{

    uint public changeCounter;

    address public owner;

    string public message;

    constructor() {
        owner = msg.sender;
    }

    function updateMessage(string memory _newMessage)
    public {
        if (msg.sender == owner)
        {
            message = _newMessage;
            changeCounter++;
        }
    }
}