// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MultiAuction {
    struct Auction {
        address owner;
        string ipfsHash;
        uint256 auctionEndTime;
        address highestBidder;
        uint256 highestBid;
        bool ended;
    }

    Auction[] public auctions;

    event AuctionCreated(uint256 indexed auctionId, string ipfsHash, uint256 endTime, address owner);
    event BidPlaced(uint256 indexed auctionId, address bidder, uint256 amount);
    event AuctionEnded(uint256 indexed auctionId, address winner, uint256 highestBid);

    function createAuction(string memory ipfsHash, uint256 biddingTime) public {
        uint256 auctionEndTime = block.timestamp + biddingTime;
        auctions.push(Auction(msg.sender, ipfsHash, auctionEndTime, address(0), 0, false));
        uint256 auctionId = auctions.length - 1;
        emit AuctionCreated(auctionId, ipfsHash, auctionEndTime, msg.sender);
    }

    function placeBid(uint256 auctionId) public payable {
        require(auctionId < auctions.length, "Auction does not exist");
        Auction storage auction = auctions[auctionId];
        require(!auction.ended, "Auction has already ended");
        require(msg.sender != auction.owner, "Owner cannot bid");
        require(block.timestamp < auction.auctionEndTime, "Auction has ended");

        uint256 currentBid = msg.value + auction.highestBid;
        require(currentBid > auction.highestBid, "Bid must be higher than the current highest bid");

        auction.highestBidder = msg.sender;
        auction.highestBid = currentBid;
        emit BidPlaced(auctionId, msg.sender, msg.value);
    }

    function endAuction(uint256 auctionId) public {
        require(auctionId < auctions.length, "Auction does not exist");
        Auction storage auction = auctions[auctionId];
        require(!auction.ended, "Auction has already ended");
        require(msg.sender == auction.owner, "Only the owner can end the auction");
        require(block.timestamp >= auction.auctionEndTime, "Auction has not ended yet");

        auction.ended = true;
        emit AuctionEnded(auctionId, auction.highestBidder, auction.highestBid);

        payable(auction.owner).transfer(auction.highestBid);
    }

    function getAuctionCount() public view returns (uint256) {
        return auctions.length;
    }
}

