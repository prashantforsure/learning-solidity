// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract BasicTwitter{

    uint16 public MAX_TWEET_LENGTH = 280;

    struct Tweet {
        uint256 id;
        address author;
        string content;
        uint256 timestamp;
        uint256 likes;
    }

    mapping(address => Tweet[]) public tweets;
    address public owner;

    constructor(){
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "you are not the owner");
        _;
    }
    function changeTweetLength(uint16 newTweetLength) public onlyOwner {
        MAX_TWEET_LENGTH = newTweetLength;
    }

     function createTweet(string memory _tweet) public onlyOwner{
        require(bytes(_tweet).length <= MAX_TWEET_LENGTH, "Tweet is too long" );
        Tweet memory newTweet =  Tweet({
            id: tweets[msg.sender].length,
            author: msg.sender,
            content: _tweet,
            timestamp: block.timestamp,
            likes: 0
        });
        tweets[msg.sender].push(newTweet);
    }

    function likeTweet(address author, uint256 id) external {  
        require(tweets[author][id].id == id, "TWEET DOES NOT EXIST");

        tweets[author][id].likes++;
    }

    function unlikeTweet(address author, uint256 id) external {
        require(tweets[author][id].id == id, "tweet does not exist");
        require(tweets[author][id].likes > 0, "tweet does not have any likes");

        tweets[author][id].likes--;
    }

    function getTweet(address _owner, uint _i) public view returns (Tweet memory) {
        return tweets[_owner][_i];
    }

    function getAllTweets(address _owner) public view returns (Tweet[] memory ){
        return tweets[_owner];
    }
}