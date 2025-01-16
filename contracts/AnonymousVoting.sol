// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./IdentityManager.sol";

contract AnonymousVoting {
    struct Proposal {
        bytes32 name;     
        uint32 voteCount; 
    }
    
    IdentityManager public immutable identityManager;
    mapping(address => bool) private hasVoted;
    mapping(uint8 => Proposal) private proposals;
    uint8 public immutable proposalCount;
    uint32 public immutable votingEnd;
    
    event VoteCast(uint8 indexed proposalIndex, uint32 newVoteCount);
    
    constructor(
        address _identityManager,
        bytes32[] memory proposalNames,
        uint32 _votingDuration
    ) {
        require(_identityManager != address(0), "Invalid IM address");
        require(proposalNames.length > 0 && proposalNames.length <= 5, "Invalid proposal count");
        
        identityManager = IdentityManager(_identityManager);
        proposalCount = uint8(proposalNames.length);
        votingEnd = uint32(block.timestamp + _votingDuration);
        
        for (uint8 i = 0; i < proposalCount; i++) {
            proposals[i].name = proposalNames[i];
        }
    }
    
    function vote(uint8 proposalIndex) public {
        require(block.timestamp < votingEnd, "Voting ended");
        require(!hasVoted[msg.sender], "Already voted");
        require(proposalIndex < proposalCount, "Invalid proposal");
        
        (bool isRegistered, bool isVerified) = identityManager.checkIdentity(msg.sender);
        require(isRegistered && isVerified, "Not verified");
        
        hasVoted[msg.sender] = true;
        unchecked {
            proposals[proposalIndex].voteCount++;
        }
        
        emit VoteCast(proposalIndex, proposals[proposalIndex].voteCount);
    }
    
    function getProposal(uint8 index) public view returns (bytes32 name, uint32 voteCount) {
        require(index < proposalCount, "Invalid index");
        Proposal storage prop = proposals[index];
        return (prop.name, prop.voteCount);
    }
}