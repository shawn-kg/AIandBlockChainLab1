//SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

contract SimpleBank{
    mapping(address => uint) public balance;

    function deposit() public payable
    {
        balance[msg.sender] += msg.value;
    }
    
    function getBalance() public view returns(uint)
    {
        return balance[msg.sender];
    }

    function withdraw(uint amount) public 
    {
        require(amount<=balance[msg.sender], "You do not have enough to withdraw");
        balance[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);


    }

    function withdrawAll() public 
    {
        address payable to = payable(msg.sender);
        uint send = getBalance();
        balance[msg.sender] = 0;
        to.transfer(send);
    }
}