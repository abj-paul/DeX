import React from 'react';

const AuctionResult = ({ result }) => {
  // Display auction result details
  return (
    <div>
      <h2>Auction Result</h2>
      {result ? (
        <div>
          <p>Winning Bid: {result.winningBid}</p>
          <p>Winning Bidder: {result.winningBidder}</p>
          <p>Time of Auction End: {result.endTime}</p>
          {/* Display other relevant auction result details */}
        </div>
      ) : (
        <p>No auction result available.</p>
      )}
    </div>
  );
};

export default AuctionResult;
