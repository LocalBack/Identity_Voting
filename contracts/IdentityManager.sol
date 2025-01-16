// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/access/Ownable.sol";

contract IdentityManager is Ownable {
    struct Identity {
        bytes32 hashedDocument;  
        bool isVerified;         
        uint32 registrationTime; 
    }
    
    uint8 public totalRegistered;
    mapping(address => Identity) private identities;
    
    event IdentityRegistered(address indexed user, bytes32 hashedDocument);
    event IdentityVerified(address indexed user);
    
    function registerIdentity(bytes32 _hashedDocument) public {
        Identity storage identity = identities[msg.sender];
        require(identity.hashedDocument == 0, "Already registered");
        
        identity.hashedDocument = _hashedDocument;
        identity.registrationTime = uint32(block.timestamp);
        unchecked { totalRegistered++; }
        
        emit IdentityRegistered(msg.sender, _hashedDocument);
    }
    
    function verifyIdentity(address user) public onlyOwner {
        Identity storage identity = identities[user];
        require(identity.hashedDocument != 0, "Not registered");
        require(!identity.isVerified, "Already verified");
        
        identity.isVerified = true;
        emit IdentityVerified(user);
    }
    
    function checkIdentity(address user) public view returns (bool, bool) {
        Identity memory identity = identities[user];
        return (identity.hashedDocument != 0, identity.isVerified);
    }
}