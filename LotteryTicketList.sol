pragma solidity ^0.4.0;

import  "../contracts/Ilighthouse.sol";
import  "../contracts/SafeMath.sol";

contract LotteryTicketList {
    // Type and global var definitions
    uint constant annuityPayoutPercentage = 4; // ppt (parts per thousands)
    string constant lotteryPeriod = "month";
    string constant annuityAndProfitPayoutPeriod = "quarterly";
    address public potAddress;
    uint256 public potAmount;
    uint256 public ticketPrice;
    address public owner;
    bytes32 public currentWinningHash;

    ILighthouse  public myLighthouse;
    SafeMath public mySafeMath;

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

    function restartCycle() private {

    }

    function endCycle() private {
        // If we don't have any winners yet, begin a new cycle without flushing
        uint256 len = winningTickets.length;
        if (len == 0) {
            restartCycle();
        }
        // If we have winners, iterate through them and process their payouts
        for (i=0;i<len;i++) {
            processPayout(winningTickets[i]);
            emit winnerFound(winningTickets[i].Owner);
        }
        // emit winnerFound(winner)
    }
	
    function processPayout(Ticket ticket) private {
        // Process the payout for each address depending on their PayOutSetting
        if (ticket.PayoutType == 0) {
            directPayout(ticket);
        } else if (ticket.PayoutType == 1) {
            annuityPayout(ticket);
        } else if (ticket.PayoutType == 2) {
            profitSharePayout(ticket);
        }
    }

    function directPayout(Ticket ticket) private {
        // Handle direct payouts
        uint256 amount = mySafeMath.div(potAmount, winningTickets.length);
        transfer(ticket.Owner, amount);
    }

    function annuityPayout(Ticket ticket) private {
        // Handle payouts for annuity accounts
        // 10% of total stake profit is distributed proportionally amongst annuity owners
    }

    function profitSharePayout(Ticket ticket) private {
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
