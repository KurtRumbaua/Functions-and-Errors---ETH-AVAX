# VotingContract

## Description

This project demonstrates the use of Solidity's `require()`, `assert()`, and `revert()` statements in a voting smart contract. The contract includes functionalities for managing candidates, voting, ending the election, and resetting the election state.

## Getting Started

### Executing the Program

To run this project in Remix IDE:

1. Open [Remix IDE](https://remix.ethereum.org/).
2. Create a new file named `VotingContract.sol` and copy the smart contract code into this file.
3. Ensure the Solidity compiler version is set to `0.8.0` or later.
4. Compile the smart contract by clicking the "Solidity Compiler" plugin and then the "Compile VotingContract.sol" button.
5. Deploy the contract by clicking the "Deploy & Run Transactions" plugin, selecting `VotingContract` from the dropdown, and clicking the "Deploy" button.
6. Interact with the deployed contract using the provided UI in Remix IDE. You can:
    - **Add Candidate**: Adds a new candidate to the election (only callable by the owner).
      ```solidity
      addCandidate("Alice")
      ```
      - Example: Adds "Alice" as a candidate (must be the owner).

    - **Vote**: Casts a vote for an existing candidate.
      ```solidity
      vote("Alice")
      ```

    - **End Election**: Ends the election (only callable by the owner).
      ```solidity
      endElection()
      ```

    - **Reset Election**: Resets the election to its initial state (only callable by the owner).
      ```solidity
      resetElection()
      ```

### Smart Contract Code

```solidity
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
```

### Author
Kurt Ian Rumbaua
kirrumbaua@mymail.mapua.edu.ph

### License
This project is licensed under the MIT License - see the LICENSE file for details.
