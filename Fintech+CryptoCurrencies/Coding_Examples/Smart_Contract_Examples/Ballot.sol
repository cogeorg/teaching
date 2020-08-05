    pragma solidity ^0.4.11;

    contract Ballot {
        struct Voter {
            uint weight; // weight is accumulated by delegation
            bool voted;  // if true, that person already voted
            address delegate; // person that the voter has delegated to
            uint vote;   // index of the voted proposal
        }

        struct Proposal {
            bytes32 name;   // short name of the proposed candidate or option(up to 32 bytes)
            uint voteCount; // number of accumulated votes
        }

        address public chairperson;

        mapping(address => Voter) public voters;

        Proposal[] public proposals; // A dynamically-sized array of `Proposal` structs.

        /// Create a new ballot to choose one of `proposalNames`.

        function Ballot(bytes32[] proposalNames) public {
            chairperson = msg.sender;
            voters[chairperson].weight = 1;

            // For each of the provided proposal names, create a new proposal object and add it to the end of the array.
            for (uint i = 0; i < proposalNames.length; i++) {
                proposals.push(Proposal({
                    name: proposalNames[i],
                    voteCount: 0
                }));
            }
        }

        function giveRightToVote(address voter) public {
            require((msg.sender == chairperson) && !voters[voter].voted && (voters[voter].weight == 0)); 
            voters[voter].weight = 1;
        }

        function delegate(address to) public {
            Voter storage sender = voters[msg.sender];
            require(!sender.voted);  

            require(to != msg.sender); // Self-delegation is not allowed.

            // Forward the delegation as long as `to` also delegated.
            while (voters[to].delegate != address(0)) {
                to = voters[to].delegate;

                require(to != msg.sender);
            }

            sender.voted = true;
            sender.delegate = to;
            Voter storage delegate = voters[to];
            if (delegate.voted) {
                proposals[delegate.vote].voteCount += sender.weight;
            } else {
                delegate.weight += sender.weight;
            }
        }

        function vote(uint proposal) public {
            Voter storage sender = voters[msg.sender];
            require(!sender.voted);
            sender.voted = true;
            sender.vote = proposal;

            proposals[proposal].voteCount += sender.weight;
        }

        function winningProposal() public view
                returns (uint winning_Proposal)
        {
            uint winningVoteCount = 0;
            for (uint p = 0; p < proposals.length; p++) {
                if (proposals[p].voteCount > winningVoteCount) {
                    winningVoteCount = proposals[p].voteCount;
                    winning_Proposal = p;
                }
            }
        }

        function winnerName() public view
                returns (bytes32 winner_Name)
        {
            winner_Name = proposals[winningProposal()].name;
        }
    }
