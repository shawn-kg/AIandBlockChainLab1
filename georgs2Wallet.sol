//SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

contract Wallet {

    address payable owner;
    mapping (address => uint) public amount;
    mapping (address => bool) public allowedToSend;
    mapping (address => bool) public guardians;
    address payable nxtOwner;
    uint guardianCount;
    uint public constant GuardiansNeededToReset = 3;

    constructor()
    {
        owner = payable(msg.sender);
    }

    receive() external payable {

    }

    function transfer(address payable _to,  uint _amount, bytes memory payload) public returns (bytes memory) 
    {
        require(_amount<=address(this).balance, "Contract does not have enough currency");
        require(msg.sender==owner, "You are not the owner");
        require(allowedToSend[_to], "You are not allowed to send currency to this person");
        require(amount[_to]>= _amount, "You cannot send this amount of currency");
        amount[_to]-=_amount;

        (bool success, bytes memory data) = _to.call{value: _amount}(payload);
        require(success, "Transaction failed");
        return data;
    }

    function setAmount(address _user, uint _amount) public
    {
        require(msg.sender==owner,"You are not the owner");
        amount[_user] = _amount;
        allowedToSend[_user] = true;
    }

    function denyAllowance(address _user) public
    {
        require(msg.sender==owner, "You are not the owner");
        allowedToSend[_user] = false;
    }

    function changeOwner(address payable _newOwner) public
    {
        require(guardians[msg.sender], "You are not a guardian");
        if (nxtOwner!=_newOwner)
        {
            nxtOwner = _newOwner;
            guardianCount = 0;
        }

        guardianCount++;
        
        if (guardianCount>=GuardiansNeededToReset)
        {
            owner = nxtOwner;
            nxtOwner = payable(address(0));
        }
    }

    function setGuardian(address _guard) public 
    {
        require(msg.sender == owner, "You are not the owner");
        guardians[_guard] = true;
    }


}