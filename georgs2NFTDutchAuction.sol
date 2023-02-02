//SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

interface IERC721 {
    function transferFrom(address _from, address _to, uint _nftId) external;
}

contract NFTDutchAuction {
    uint private constant DURATION = 10 days;

    IERC721 public immutable nft;
    uint public immutable nftId;

    address payable public immutable seller;
    uint public immutable startingPrice;
    uint public immutable startAt;
    uint public immutable expiresAt;
    uint public immutable discountRate;

    constructor(uint _startingPrice, uint _discountRate, address _nft, uint _nftId)
    {
        seller = payable(msg.sender);
        startingPrice = _startingPrice;
        startAt = block.timestamp;
        expiresAt = block.timestamp + DURATION;
        discountRate = _discountRate;

        require(startingPrice >= discountRate*DURATION, "The starting price should be greater than the decrease of the price over the bidding period");

        nft = IERC721(_nft);
        nftId = _nftId;

    }

    function getPrice() public view returns (uint) 
    {
        uint timePassed = block.timestamp - startAt;
        uint priceDrop = discountRate * timePassed;

        return startingPrice - priceDrop;
    }

    function buyNow() external payable 
    {
        require(block.timestamp < expiresAt, "Time for the auction has expired");
        uint price = getPrice();
        require(msg.value >= price, "Not enough currency to buy the NFT");

        nft.transferFrom(seller, msg.sender, nftId);
        uint refund = msg.value-price;
        if (refund>0)
        {
            payable(msg.sender).transfer(refund);
        }
        selfdestruct(seller);
    }
}