pragma solidity ^0.4.0;

contract LotteryTicketList {
    // Type and global var definitions
    uint ticketPrice;
    address owner;
    bytes32 currentWinningHash;
    mapping[address]uint Winners;
    mapping[address]Settings UserSettings;
    struct Settings {
        uint PayoutType;
        // Will probably want other fields
    }

    // Owner functions
    function SetTicketPrice(price uint) public onlyOwner {
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
    function getRandomNumber() private {
        // Make call to Rhombus to get random number
        // Immediately hash it and store
        currentWinningHash = keccak256(randNumber)
    }

    function endCycle() private {
        // Iterate through list of winners, if any
        // if there are no winners, begin a new cycle
        // if there winners, initiate payout process for those addresses
        // emit winnerFound(winner)
    }
	
    function processPayout() private {
        // Process the payout for each address depending on their PayOutSetting
    }

    function profitSharePayout() private {
        // Handle payouts for profit shares
    }

    function annuityPayout() private {
        // Handle payouts for annuity accounts
    }

    event winnerFound(winner address);

    // External functions for participants to buy tickets and choose their payout method
    function BuyTicket(guess uint) external {
    // Check if the hash of the guess for this msg.sender
    // Is the same as the hash of the random number solution for this round
    // If user guessed right, add their address to the Winners mapping and increment the associated uint
    // If user guessed wrong, discard their address (don't do anything with it)
    }

    function ChoosePayout(payoutType uint) external {
      UserSettings[msg.sender] = Settings(payoutType)
    }
}
