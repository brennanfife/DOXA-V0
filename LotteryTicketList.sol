pragma solidity ^0.4.0;

import  "../contracts/Ilighthouse.sol";
contract LotteryTicketList {
    // Type and global var definitions
    uint constant annuityPayoutPercentage = 4; // ppt (parts per thousands)
    string constant lotteryPeriod = "month";
    string constant annuityAndProfitPayoutPeriod = "quarterly";
    address public potAddress;
    uint public potAmount;
    uint public ticketPrice;
    address public owner;
    bytes32 public currentWinningHash;

    ILighthouse  public myLighthouse;
    constructor() public {
        owner = msg.sender;
        myLighthouse = _myLighthouse;
    }

    struct Ticket {
        uint Price;
        uint PayoutType;
        address Owner;
    }

    Ticket[] public winningTickets;
    mapping(address => uint256) public Annuities;


    // Owner functions
    function SetTicketPrice(uint price) public onlyOwner {
        ticketPrice = price;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    struct Settings {
	    uint PayoutType;
        // Will probably want other fields
    }

    // Private, internally called functions
    function transfer(address to, uint256 amount) private {
        require(msg.sender==owner);
        to.transfer(amount);
    }

    function getRandomNumber() private {
        // Make call to Rhombus to get random number
        uint winningNumber;
        bool ok;
        (winningNumber,ok) = myLighthouse.peekData(); // obtain random number from Rhombus Lighthouse
        // Immediately hash it and store
        currentWinningHash = keccak256(winningNumber);
    }

    function beginCycle() private {
        // Wait x amount of time and then trigger endCycle
    }

    function endCycle() private {
        // If we don't have any winners yet, begin a new cycle without flushing
        if (winningTickets.length == 0) {
            beginCycle();
        }
        // If we have winners, iterate through them and process their payouts
        for (i=0;i<winningTickets.length;i++) {
            emit winnerFound(winningTickets[i].Owner);
        }
        // emit winnerFound(winner)
    }
	
    function processPayout() private {
        // Process the payout for each address depending on their PayOutSetting
    }

    function directPayout(Ticket ticket) private {
        // Handle direct payouts
        transfer(ticket.Owner, //somehow know the amount they owe and put it here)
    }

    function annuityPayout() private {
        // Handle payouts for annuity accounts
        // 10% of total stake profit is distributed proportionally amongst annuity owners
    }

    function profitSharePayout() private {
        // Handle payouts for profit shares
        // Some percentage of the remaining 60% of total stake profit is distributed amongst profit share owners
        // Last 30% is fed back into pot or developer fund/slush fund
    }

    event winnerFound(address winner);

    // External functions for participants to buy tickets and choose their payout method
    function BuyTicket(uint guess, uint payoutType) external payable costs(ticketPrice) {
        potAmount += msg.Value;
        // Check if the hash of the guess for this msg.sender is the same as the hash of the random number solution for this round
        // If user guessed right, create a winning ticket for them
        if (keccak256(guess) == currentWinningHash) {
            Ticket ticket;
            ticket.Price = ticketPrice;
            ticket.Owner = msg.sender;
            ticket.PayoutType = payoutType;
            winningTickets.push(ticket);
        }
        // Otherwise don't do anything
    }

    function () payable {
        potAmount += msg.Value;
    }
}
