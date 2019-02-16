pragma solidity ^0.4.0;

contract LotteryTicketList {
    address public winner;
    mapping[winner]uint Winners;f

    State public state;

    //What types of states should we consider?
    enum State {Created, }
    address public participant;

    function BuyTicket()
    inState(State.Created) {
        participant = msg.sender;
    }

    function BuyTicket(guess uint) {
        // Check if the hash of the guess for this msg.sender
        // Is the same as the hash of the random number solution for this round
        // If user guessed right, add their address to the Winners mapping and increment the associated uint
        // If user guessed wrong, discard their address (don't do anything with it)
    }

    function EndCycle() {

    }
}
