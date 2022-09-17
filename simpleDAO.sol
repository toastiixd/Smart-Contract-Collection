pragma solidity ^0.8.7;

import "./ERC20.sol";
import "./Ownable.sol";

contract SimpleDAO is ERC20, Ownable {

    ERC20 BUSD = ERC20(0xeD24FC36d5Ee211Ea25A80239Fb8C4Cfd80f12Ee);

    struct VotingPeriod {
        mapping(address => bool) votes;
        uint negativeVotes;
        uint positiveVotes;
        uint totalVotes;
        string successful;
    }

    uint public votingPeriodIndex;
    uint public threshold = 50;
    string public messagee;


    mapping(uint => VotingPeriod) votingPeriods;

    constructor (
        string memory name,
        string memory symbol
    ) ERC20("", "") {
        _name = name;
        _symbol = symbol;
    }

    //Q: what is payable?
    function buyVotes(uint amount) external {
        BUSD.transferFrom(msg.sender, address(this), amount);
        //Nimmt 3 arg entgegen: sender, receiver & amount
        _mint(msg.sender, amount);
        //brauch 2 arg: receiver & amount
    }

    function message(string memory lol) external {
        messagee = lol;
    }

    function getmessage() external view returns (string memory) {
        return messagee;
    }

    function vote(bool voteCast) external {
        VotingPeriod storage period = votingPeriods[votingPeriodIndex];
        require(period.votes[msg.sender] == false);
        require(balanceOf(msg.sender) > 0, "you have no tokens");

        if (voteCast == true) {
            period.positiveVotes += balanceOf(msg.sender);
        } else {
            period.negativeVotes += balanceOf(msg.sender);
        }

        period.votes[msg.sender] = true;

        if (period.positiveVotes > threshold) {
            period.successful = "worked";
            votingPeriodIndex++;
        } else if (period.negativeVotes > threshold) {
            period.successful = "failed";
            votingPeriodIndex++;
        }
    }

    function getVotingPeriodResults(uint index) external view returns (string memory) {
        return votingPeriods[index].successful;
    }

    function withdrawToken(uint256 _amount) external {
        BUSD.transfer(msg.sender, _amount);
    }

}


