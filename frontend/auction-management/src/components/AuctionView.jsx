import React, { useState, useEffect } from 'react';
import { useRouter } from 'next/router';
import axios from 'axios';

const AuctionView = () => {
  const router = useRouter();
  const { id } = router.query;
  const [auction, setAuction] = useState(null);
  const [bid, setBid] = useState('');

  useEffect(() => {
    const fetchAuctionDetails = async () => {
      try {
        const response = await axios.get(`/api/auction/${id}`);
        setAuction(response.data);
      } catch (error) {
        console.error('Error fetching auction details:', error);
      }
    };

    if (id) {
      fetchAuctionDetails();
    }
  }, [id]);

  const handleSubmit = async (e) => {
    e.preventDefault();

    try {
      await axios.post(`/api/auction/${id}/bid`, {
        bid,
      });
      // Handle success, e.g., show a success message
    } catch (error) {
      // Handle error, e.g., show an error message
      console.error('Error placing bid:', error);
    }
  };

  return (
    <div>
      {auction ? (
        <div>
          <h2>Auction Details</h2>
          <img src={auction.ipfsImageUrl} alt="NFT" style={{ maxWidth: '300px' }} />
          <p>Minimum Bid: {auction.minimumBid}</p>
          <p>Increment: {auction.increment}</p>

          <form onSubmit={handleSubmit}>
            <label>
              Your Bid:
              <input type="number" value={bid} onChange={(e) => setBid(e.target.value)} />
            </label>
            <button type="submit">Place Bid</button>
          </form>
        </div>
      ) : (
        <p>Loading auction details...</p>
      )}
    </div>
  );
};

export default AuctionView;
