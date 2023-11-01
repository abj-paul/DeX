import React, { useEffect, useState } from 'react';
import axios from 'axios';

const AuctionTimeline = () => {
  const [auctions, setAuctions] = useState([]);

  useEffect(() => {
    const fetchAuctions = async () => {
      try {
        const response = await axios.get('/api/auctions');
        setAuctions(response.data);
      } catch (error) {
        console.error('Error fetching auctions:', error);
      }
    };

    fetchAuctions();
  }, []);

  return (
    <div>
      <h2>Auction Timeline</h2>
      <ul>
        {auctions.map((auction) => (
          <li key={auction.id}>
            NFT ID: {auction.nftId}, Minimum Bid: {auction.minimumBid}, Increment: {auction.increment}
          </li>
        ))}
      </ul>
    </div>
  );
};

export default AuctionTimeline;
