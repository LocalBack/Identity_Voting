// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// Import Ownable contract from OpenZeppelin for access control
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title Identity Manager Contract
/// @notice Manages voter registration and verification for anonymous voting system
/// @dev Inherits OpenZeppelin's Ownable for admin functionality
contract IdentityManager is Ownable {
    /// @notice Structure to store voter identity information
    /// @dev Uses compact types to optimize gas usage
    struct Identity {
        bytes32 hashedDocument;   // Hash of voter's identity document
        bool isVerified;          // Verification status
        uint32 registrationTime;  // Timestamp of registration
    }
    
    /// @notice Total number of registered voters
    /// @dev Uses uint8 to save gas, limits total registrations to 255
    uint8 public totalRegistered;

    /// @notice Mapping from voter address to their identity information
    /// @dev Private for security, accessible only through public functions
    mapping(address => Identity) private identities;
    
    /// @notice Emitted when a new identity is registered
    /// @param user Address of the registered voter
    /// @param hashedDocument Hash of the identity document
    event IdentityRegistered(address indexed user, bytes32 hashedDocument);

    /// @notice Emitted when an identity is verified
    /// @param user Address of the verified voter
    event IdentityVerified(address indexed user);
    
    /// @notice Register a new voter identity
    /// @param _hashedDocument Hash of the voter's identity document
    /// @dev Stores identity info and increments total registered count
    function registerIdentity(bytes32 _hashedDocument) public {
        Identity storage identity = identities[msg.sender];
        require(identity.hashedDocument == 0, "Already registered");
        
        identity.hashedDocument = _hashedDocument;
        identity.registrationTime = uint32(block.timestamp);
        unchecked { totalRegistered++; }  // Safe because of uint8 limit
        
        emit IdentityRegistered(msg.sender, _hashedDocument);
    }
    
    /// @notice Verify a registered voter's identity
    /// @param user Address of the voter to verify
    /// @dev Only contract owner can verify identities
    function verifyIdentity(address user) public onlyOwner {
        Identity storage identity = identities[user];
        require(identity.hashedDocument != 0, "Not registered");
        require(!identity.isVerified, "Already verified");
        
        identity.isVerified = true;
        emit IdentityVerified(user);
    }
    
    /// @notice Check registration and verification status of a voter
    /// @param user Address of the voter to check
    /// @return bool Is the voter registered
    /// @return bool Is the voter verified
    /// @dev Returns tuple of registration and verification status
    function checkIdentity(address user) public view returns (bool, bool) {
        Identity memory identity = identities[user];
        return (identity.hashedDocument != 0, identity.isVerified);
    }
}
