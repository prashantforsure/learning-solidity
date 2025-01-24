// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SimpleStorage.sol";

//this contact is kinda like manager for the simplestorage contract
contract storageFactory{
SimpleStorage public simpleStorage;

function createSimpleContract() public {
    simpleStorage = new SimpleStorage();
}
}