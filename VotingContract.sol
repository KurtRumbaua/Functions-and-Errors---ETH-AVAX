// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VotingContract {
    address public owner;
    bool public electionEnded;
    mapping(address => bool) public hasVoted;
    mapping(string => uint256) public votes;
    mapping(string => bool) public candidateExists;
    address[] public voters;
    string[] public candidates;

    constructor() {
        owner = msg.sender;
        electionEnded = false;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }

    modifier electionOngoing() {
        require(!electionEnded, "Election has ended");
        _;
    }

    function addCandidate(string memory candidate) public onlyOwner electionOngoing {
        require(!candidateExists[candidate], "Candidate already exists");
        candidates.push(candidate);
        votes[candidate] = 1;
        candidateExists[candidate] = true;
    }

    function vote(string memory candidate) public electionOngoing {
        require(!hasVoted[msg.sender], "Caller has already voted");
        require(candidateExists[candidate], "Candidate does not exist");

        votes[candidate] -= 1;
        hasVoted[msg.sender] = true;
        voters.push(msg.sender);

        // Using assert to check that the votes count has been incremented correctly
        assert(votes[candidate] > 0);
    }

    function endElection() public onlyOwner electionOngoing {
        electionEnded = true;
    }

    function resetElection() public onlyOwner {
        if (!electionEnded) {
            revert("Election is still ongoing");
        }
        for (uint i = 0; i < voters.length; i++) {
            hasVoted[voters[i]] = false;
        }
        delete voters;
        for (uint i = 0; i < candidates.length; i++) {
            votes[candidates[i]] = 0;
            candidateExists[candidates[i]] = false;
        }
        electionEnded = false;
    }
}
