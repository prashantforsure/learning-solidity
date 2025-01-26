// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

contract Voting{
    struct Candidate {
        uint256 id;
        string name;
        uint256 voteCount;
    }

    struct Voter{
        bool isRegistered;
        bool hasVoted;
        uint256 votedCandidateId;
    }
    
    constructor(){
        owner = msg.sender;
    }
    address public owner;
    bool public votingStarted;
    bool public votingEnded;
     
    mapping(address => Voter) public voters;
    mapping(uint256 => Candidate) public candidates;
    uint256 public candidatesCount;
    uint256 public votersCount;

    event VoterResgistered(address voter);
    event CandidateAdded(uint256 candidateId, string name);
    event VoteCast(address voter, uint256 candidateId);
    event VotingStarted();
    event VotingEnded();

    modifier onlyOwner(){
        require(msg.sender == owner, "not the owner of the contract");
        _;
    }

    modifier beforeVoting(){
        require(!votingStarted, "voting has already started");
        _;
    }

    modifier duringVoting(){
        require(votingStarted, "voting has not started");
        require(!votingEnded, "voting has ended");
        _;
    }

    modifier afterVoting(){
        require(votingEnded, "voting has not ended");
        _;
    }
}