import React, { useState } from 'react';
import axios from 'axios';

export default function CreateAuction() {
  const [nftId, setNftId] = useState('');
  const [minimumBid, setMinimumBid] = useState('');
  const [increment, setIncrement] = useState('');

  const handleSubmit = async (e) => {
    e.preventDefault();

    try {
      await axios.post('/api/createAuction', {
        nftId,
        minimumBid,
        increment,
      });
      // Handle success, e.g., show a success message
    } catch (error) {
      // Handle error, e.g., show an error message
      console.error('Error creating auction:', error);
    }
  };

  return (
    <div>
      <h1>Create Auction</h1>
      <form onSubmit={handleSubmit}>
        <label>
          NFT ID:
          <input type="text" value={nftId} onChange={(e) => setNftId(e.target.value)} />
        </label>
        <label>
          Minimum Bid:
          <input type="text" value={minimumBid} onChange={(e) => setMinimumBid(e.target.value)} />
        </label>
        <label>
          Increment:
          <input type="text" value={increment} onChange={(e) => setIncrement(e.target.value)} />
        </label>
        <button type="submit">Create Auction</button>
      </form>
    </div>
  );
}
