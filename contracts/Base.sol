// "SPDX-License-Identifier: UNLICENSED"
pragma solidity >=0.4.25;

import "../../openzeppelin-contracts/contracts/access/Ownable.sol";

abstract contract Base is Ownable {
    // Global variables declaration
    enum attended {Unset, True, False}
    struct EventDetails {
        attended showedUp;
        uint256 amount;
    }
    mapping(address => mapping(uint256 => EventDetails)) internal People;
    // In following, array[0] is amount and array[1] is time.
    mapping(uint256 => uint256[2]) internal EventToAmountNTime;
    mapping(uint256 => address[]) internal EventToMembers; // Members in an event
    uint256 internal randNonce = 0;

    // Events Declaration
    event newEventCreated(uint256 EventId, uint256 atTime);

    // Minimum amount for RSVP
    modifier minAmount() {
        require(
            msg.value >= 0.001 ether,
            "Have to submit at least 0.001 ether as RSVP amount."
        );
        _;
    }

    // @dev No data is going to be received with ethers, so using receive().
    receive() external payable minAmount {
        // React to receiving ether
    }

    // Inside OracleRelated.sol
    function distributeAmount(uint256 Event) external payable virtual;

    // Inside EventStake.sol
    function createAnEvent(uint256 atTime)
        external
        payable
        virtual
        returns (uint256);

    // Inside EventStake.sol
    function addMeToEvent(address referrer, uint256 Event)
        external
        payable
        virtual;

    // Inside EventStake.sol
    function addPersonToEvent(uint256 Event) internal virtual;

    // Inside EventStake.sol
    function selfAffirmation(uint256 Event) external virtual;
}
