//SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

interface IERC20{
    function transfer(address to, uint amount) external;
    function decimals() external view returns(uint);
}

contract TokenSale{
    uint weiTokenPrice = 1 ether;

    IERC20 token;

    function setToken(address _token) public
    {
        token = IERC20(_token);
    }
    function purchase() public payable
    {
        require(msg.value >=weiTokenPrice, "Not enough currency");
        uint tokens = msg.value/weiTokenPrice;
        uint rem = msg.value - tokens*weiTokenPrice;
        token.transfer(msg.sender,tokens*10**token.decimals());
        payable(msg.sender).transfer(rem);
    }
}