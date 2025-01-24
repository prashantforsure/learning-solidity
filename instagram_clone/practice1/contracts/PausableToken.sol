// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract PausableToken {
    address public owner;
    bool public paused;
    mapping(address => uint) public balances;

    constructor() {
      owner = msg.sender;
      paused = false;
      balances[owner] = 1000;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "only owner can perform this action");
        _;
    }
    modifier notPaused() {
        require(!paused, "contract is paused");
        _;
    }
    function pause() public onlyOwner {
        paused = true;
    }
    function unpause() public onlyOwner(){
        paused = false;
    }
    function transfer( address to, uint amount) public onlyOwner {
        require(balances[msg.sender]> amount ,"insufficient balance");
        balances[msg.sender] -= amount;
        balances[to] += amount;
    }
}