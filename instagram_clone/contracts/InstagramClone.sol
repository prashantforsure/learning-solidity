// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

contract InstagramClone {
   
    address public owner;
    constructor() {
        owner = msg.sender;
    }
    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    struct User {
        string username;
        uint256 userId;
    }
    mapping(address => User) public users;
    address[] public userAddresses;

    event UserRegistered(address indexed userAddress, string username, uint256 userId);

    function registerUser(string memory _username) public {
        require(bytes(_username).length > 0, "Username cannot be empty");
        require(bytes(users[msg.sender].username).length == 0, "User already registered");

        uint256 userId = userAddresses.length + 1;
        users[msg.sender] = User(_username, userId);
        userAddresses.push(msg.sender);

        emit UserRegistered(msg.sender, _username, userId);
    }

    struct Post {
        uint256 postId;
        address author;
        string imageUrl;
        string caption;
        uint256 timestamp;
        uint256 likeCount;
        uint256 commentCount;
    }

    // Mapping from postId to Post
    mapping(uint256 => Post) public posts;
    uint256[] public postIds;
    event PostCreated(uint256 postId, address indexed author, string imageUrl, string caption, uint256 timestamp);

    function createPost(string memory _imageUrl, string memory _caption) public {
        require(bytes(users[msg.sender].username).length > 0, "User not registered");
        require(bytes(_imageUrl).length > 0, "Image URL cannot be empty");

        uint256 postId = postIds.length + 1;
        posts[postId] = Post(postId, msg.sender, _imageUrl, _caption, block.timestamp, 0, 0);
        postIds.push(postId);

        emit PostCreated(postId, msg.sender, _imageUrl, _caption, block.timestamp);
    }
    mapping(uint256 => address[]) public postToLikers;

    event PostLiked(uint256 postId, address indexed liker);

    function likePost(uint256 _postId) public {
        require(bytes(users[msg.sender].username).length > 0, "User not registered");
        require(_postId > 0 && _postId <= postIds.length, "Invalid post ID");

    
        address[] storage likers = postToLikers[_postId];
        for (uint256 i = 0; i < likers.length; i++) {
            require(likers[i] != msg.sender, "Already liked this post");
        }
        likers.push(msg.sender);
        posts[_postId].likeCount += 1;

        emit PostLiked(_postId, msg.sender);
    }
    struct Comment{
        uint256 commentId;
        uint256 postId;
        address commenter;
        string commentText;
        uint256 timestamp;
    }

    mapping(uint256 => Comment[]) public postToComments;
    event CommentAdded(uint256 commentId, uint256 postId, address indexed commenter, string commentText, uint256 timestamp);

    function commentOnPost(uint256 _postId, string memory _commentText) public {
        require(bytes(users[msg.sender].username).length > 0, "User not registered");
        require(_postId > 0 && _postId <= postIds.length, "Invalid post ID");
        require(bytes(_commentText).length > 0, "Comment cannot be empty");

        uint256 commentId = postToComments[_postId].length + 1;
        Comment memory newComment = Comment(commentId, _postId, msg.sender, _commentText, block.timestamp);
        postToComments[_postId].push(newComment);
        posts[_postId].commentCount += 1;

        emit CommentAdded(commentId, _postId, msg.sender, _commentText,block.timestamp);
    }
    function getAllPosts() public view returns (Post[] memory){
        uint256 totalPosts = postIds.length;
        Post[] memory allPosts = new Post[](totalPosts);

        for(uint256 i = 0; i < totalPosts; i++) {
            allPosts[i] = posts[postIds[i]];
        }
        return allPosts;
    }

    //function to delete a user
    function deleteUser(address _user) public onlyOwner {
        require(bytes(users[_user].username).length > 0, "User not registered");
        
        //remove user from useraddress array
        for(uint256 i=0; i< userAddresses.length; i++){
            if(userAddresses[i] == _user){
                userAddresses[i] = userAddresses[userAddresses.length -1];
                userAddresses.pop();
                break;
            }
        }
    }
}   