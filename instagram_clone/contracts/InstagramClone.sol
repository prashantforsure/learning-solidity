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
    

    function createPost(string memory _imageUrl, string memory _caption) public {
        require(bytes(users[msg.sender].username).length >0, "user does not exist");
        require(bytes(_imageUrl).length > 0,"image url does not exist")
        uint256 postId = postIds.length + 1;
        posts[postId] = Post(postId, msg.sender, _imageUrl, _caption, block.timestamp, 0, 0);
        postIds.push(postId);

        emit PostCreated(postId, msg.sender, _imageUrl, _caption, block.timestamp);
    }

    mapping(uint256 => address[]) public postToLikers
    event PostLiked(uint256 postId, address indexed liker);

    function LikePost(uint256 _postId) public {
        require( bytes(users[msg.sender].username).length >0,"user does not exist")
        require(_postId > 0 && _postId <= postIds.length, "Invalid post ID");
        address[] storage likers = postToLikers[_postId];

        for(uint256 i = 0; i< likers.length; i++){
            require(likers[i] != msg.sender, "Already liked this post");
        }
        likers.push(msg.sender);
        posts[_postId].likeCount += 1;

        emit PostLiked(_postId, msg.sender);

    }
    struct comment {
        uint256 commentId;
        uint256 postId;
        address commenter;
        string commentText;
        uint256 timestamp;
    }
    mapping(uint256 => Comment[]) public postToComments;

    event CommentAdded(uint256 commentId, uint256 postId, address commenter, string commenText,uint256 timestamp);

    function commentOnPost(uint256 _postId, string memory _commentText) public {
        require(bytes(users[msg.sender].username).length >0, " user does not exist");
        require(_postId > 0 && _postId <= postIds.length,"invalid post Id");
        require(bytes(_commentText).length > 0, "Comment cannot be empty");
    }
    
}   