// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract VotePatent {
    struct Art {
        uint256 locked_atrium_amount;
        uint256 upvote ;
        uint256 downvote;
        uint256 time_of_submission;
        bool vote_ended;
        bool is_deleted;
    }

    IERC20 token;
    mapping(string=>Art) locked_arts;    
    mapping(string=>address) private voters;

    constructor(IERC20 _token){
        token = _token;
    }

    // Ensure that you have allowed() enough allowance beforehand.
    function lock_content_for_vote(string memory content_uri, uint256 stock_amount) public{
        //require(locked_arts[content_uri].is_deleted==true, "This content is locked already!");
        
        token.transferFrom(payable(msg.sender), address(this), stock_amount);
        locked_arts[content_uri] = Art({
            locked_atrium_amount: stock_amount,
            upvote: 0,
            downvote: 0,
            time_of_submission: block.timestamp,
            vote_ended: false,
            is_deleted: false
        });
    }

    function upvote(string memory content_uri) public {
        require(locked_arts[content_uri].vote_ended==false, "Vote has ended already!");
        require(voters[content_uri]==0x0000000000000000000000000000000000000000, "You have already voted once!");
        voters[content_uri] = msg.sender;
        locked_arts[content_uri].upvote += 1;
    }

    function downvote(string memory content_uri) public {
        require(locked_arts[content_uri].vote_ended==false, "Vote has ended already!");
        require(voters[content_uri]==0x0000000000000000000000000000000000000000, "You have already voted once!");

        voters[content_uri] = msg.sender;
        locked_arts[content_uri].downvote += 1;
    }

    function unlock_content_after_vote(string memory content_uri) public {
        require(block.timestamp > locked_arts[content_uri].time_of_submission, "The deadline for vote is not over yet!");

        if(locked_arts[content_uri].upvote + locked_arts[content_uri].downvote < 1){ // Minimum votes = 1
            // Insufficient votes, so simply unlock and return
            locked_arts[content_uri].is_deleted = true; 
            token.transferFrom(address(this), payable(msg.sender), locked_arts[content_uri].locked_atrium_amount);
        }

        if(locked_arts[content_uri].upvote > locked_arts[content_uri].downvote){
            locked_arts[content_uri].is_deleted = true; 
            token.transferFrom(address(this), payable(msg.sender), locked_arts[content_uri].locked_atrium_amount); 
            // mint nft : later 
        }
        else if(locked_arts[content_uri].upvote < locked_arts[content_uri].downvote){
            // do nothing 
        }
    }
}
