// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./IdentityManager.sol";

/// @title Anonymous Voting System
/// @notice Allows verified users to vote anonymously on proposals
/// @dev Integrates with IdentityManager for voter verification
contract AnonymousVoting {
    /// @notice Structure representing a voting proposal
    /// @param name Bytes32 encoded proposal name (e.g., keccak256("Proposal 1"))
    /// @param voteCount Current number of votes received
    struct Proposal {
        bytes32 name;     
        uint32 voteCount; 
    }
    
    /// @notice Immutable reference to IdentityManager contract
    IdentityManager public immutable identityManager;
    
    /// @dev Tracks which addresses have already voted
    mapping(address => bool) private hasVoted;
    
    /// @dev Stores all voting proposals by index
    mapping(uint8 => Proposal) private proposals;
    
    /// @notice Total number of proposals (immutable after deployment)
    uint8 public immutable proposalCount;
    
    /// @notice Timestamp when voting period ends (immutable after deployment)
    uint32 public immutable votingEnd;
    
    /// @notice Emitted when a vote is successfully cast
    /// @param proposalIndex Index of the proposal that received the vote
    /// @param newVoteCount Updated vote count for the proposal
    event VoteCast(uint8 indexed proposalIndex, uint32 newVoteCount);
    
    /// @notice Initializes the voting contract
    /// @param _identityManager Address of IdentityManager contract
    /// @param proposalNames Array of proposal names (max 5 proposals)
    /// @param _votingDuration Voting duration in seconds from deployment
    constructor(
        address _identityManager,
        bytes32[] memory proposalNames,
        uint32 _votingDuration
    ) {
        // Input validation
        require(_identityManager != address(0), "Invalid IM address");
        require(proposalNames.length > 0 && proposalNames.length <= 5, "Invalid proposal count");
        
        // Initialize contract dependencies and parameters
        identityManager = IdentityManager(_identityManager);
        proposalCount = uint8(proposalNames.length);
        votingEnd = uint32(block.timestamp + _votingDuration);
        
        // Initialize proposals from input names
        for (uint8 i = 0; i < proposalCount; i++) {
            proposals[i].name = proposalNames[i];
        }
    }
    
    /// @notice Allows verified users to cast a vote
    /// @dev Requires valid identity check and active voting period
    /// @param proposalIndex Index of the proposal to vote for (0-based)
    function vote(uint8 proposalIndex) public {
        // Voting period check
        require(block.timestamp < votingEnd, "Voting ended");
        
        // Prevent duplicate voting
        require(!hasVoted[msg.sender], "Already voted");
        
        // Validate proposal index
        require(proposalIndex < proposalCount, "Invalid proposal");
        
        // Check voter identity status
        (bool isRegistered, bool isVerified) = identityManager.checkIdentity(msg.sender);
        require(isRegistered && isVerified, "Not verified");
        
        // Mark voter as having voted
        hasVoted[msg.sender] = true;
        
        // Update vote count (unchecked for gas savings - safe due to proposalCount limit)
        unchecked {
            proposals[proposalIndex].voteCount++;
        }
        
        // Emit voting event
        emit VoteCast(proposalIndex, proposals[proposalIndex].voteCount);
    }
    
    /// @notice Returns proposal details by index
    /// @param index Proposal index to query
    /// @return name Proposal name in bytes32 format
    /// @return voteCount Current number of votes for the proposal
    function getProposal(uint8 index) public view returns (bytes32 name, uint32 voteCount) {
        require(index < proposalCount, "Invalid index");
        Proposal storage prop = proposals[index];
        return (prop.name, prop.voteCount);
    }
}
