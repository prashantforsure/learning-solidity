// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

contract InstagramClone {
    address public owner;

    constructor(){
        owner = msg.sender;
    }
    modifier onlyowner(){
        require(msg.sender == owner, "this is not the contract owner");
        _;
    }
    struct User{
        string username;
        uint256 userId;
    }
    mapping(address => User) public users;

    // Array to store all user addresses
    address[] public userAddresses;
    event UserResgistered(address indexed userAddresses, string username, uint256 userId);

    // Function to register a new user
    function registerUser(string memory _username) public {
        require(bytes(_username).length > 0, "username cant be null");
        require(bytes(users[msg.sender].username).length == 0,"user already registered");
        uint256 userId = userAddresses.length +1;
        users[msg.sender] = User(_username, userId);
        userAddresses.push(msg.sender);

        emit UserResgistered(msg.sender, _username, userId);
    }
    struct Post {
        uint256 postId;
        address author;
        string imageUrl;
        string caption;
        uint256 timestamp;
        uint256 likeCount;
        uint256 commmentCount;
    }
     mapping(uint256 => Post) public posts;
     event PostCreated(uint256 postId, address indexed author, string imageUrl, string caption, uint256 timestamp);
    

    function createPost(string memory _imageUrl, string memory _caption)
}