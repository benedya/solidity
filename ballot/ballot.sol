pragma solidity ^0.4.0;

contract Ballot {

    struct Voter {
        uint weight;
        bool voted;
        address delegate;
        uint vote; // index of the voted proposal
    }

    struct Proposal {
        bytes32 name;
        uint voteCount;
    }

    mapping (address => Voter) public voters;

    Proposal[] public proposals;

    address public chairperson;

    function Ballot(bytes32[] proposalNames) public {
        chairperson = msg.sender;
        voters[chairperson].weight = 0;

        for (uint i =0; i < proposalNames.length; i++) {
            proposals.push(Proposal({
                name: 'test',
                voteCount: 0
            }));
        }
    }


    function giveRightToVote(address voter) public {

        require(msg.sender == chairperson && !voters[voter].voted && voters[voter].weight == 0);

        voters[voter].weight = 1;

    }

    function delegate(address to) public {
        require(to != msg.sender);

        Voter storage sender = voters[msg.sender];

        require(!sender.voted);

        while(voters[to].delegate != address(0)) {
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

        proposals[sender.vote].voteCount += sender.weight;
    }

    function winningProposal() public view returns (uint winningProposal) {
        uint winningCount = 0;
        for (uint p = 0; p < proposals.length; p++) {
            if (proposals[p].voteCount > winningCount) {
                winningCount = proposals[p].voteCount;
                winningProposal = p;
            }
        }
    }

    function winnerName() public view returns (bytes32 winnerName) {
        winnerName = proposals[winningProposal()].name;
    }

}