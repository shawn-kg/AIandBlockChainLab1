//SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TokenSale is ERC20{
    uint weiTokenPrice = 3 ether;

    constructor () ERC20("MyToken", "MT")
    {

    }


    function purchase() public payable
    {
        require(msg.value >=weiTokenPrice, "Not enough currency");
        uint tokens = msg.value/weiTokenPrice;
        uint rem = msg.value - tokens*weiTokenPrice;
        transfer(msg.sender,tokens*10**decimals());
        payable(msg.sender).transfer(rem);
    }
}