// "SPDX-License-Identifier: UNLICENSED"
pragma solidity >=0.4.25;

import "./OracleRelated.sol";
import "../../openzeppelin-contracts/contracts/utils/math/SafeMath.sol";

contract EventStake is OracleRelated {
    // Library usage declarations
    using SafeMath for uint256;

    function createAnEvent(uint256 atTime)
        external
        payable
        override
        minAmount
        returns (uint256)
    {
        /* @dev Generate random number as an event id and push it into
           creator's event array. "keccak256" is not so secure method,
           so you can replace it with oracle side work afterwards. */
        randNonce.add(1);
        uint256 Event =
            uint256(
                keccak256(
                    abi.encodePacked(block.timestamp, msg.sender, randNonce)
                )
            );
        addPersonToEvent(Event);
        EventToAmountNTime[Event][1] = atTime;
        /* @dev Node server will listen to this event and at its emmission will
        call setTimeout, which will call distributeAmount() in OracleRelated.sol
        at "atTime", passing on "Event" as argument to distributeAmount(). */
        emit newEventCreated(Event, atTime);
        return Event;
    }

    // @params referrer - address of person inviting msg.sender to event.
    // @params Event - It is an id for identifying an event.
    /* This function may still be vulnerable as any node can read which address
    includes which event and use that address as referrer, without letting the
    address know that you've been invited by it. But, we may work on that later. */
    function addMeToEvent(address referrer, uint256 Event)
        external
        payable
        override
        minAmount
    {
        require(
            People[referrer][Event].showedUp == attended.False,
            "Inviter must be a member of the event."
        );
        addPersonToEvent(Event);
    }

    // @dev Common functionality for adding a person to an event.
    function addPersonToEvent(uint256 Event) internal override {
        require(
            People[msg.sender][Event].showedUp == attended.Unset,
            "You're already a member of this event."
        );
        People[msg.sender][Event].showedUp = attended.False;
        EventToAmountNTime[Event][0] = EventToAmountNTime[Event][0].add(
            msg.value
        );
        EventToMembers[Event].push(msg.sender);
        People[msg.sender][Event].amount = msg.value;
    }

    /* @dev Self-affirmation, here, means the person affirms that he
    has showed up on a particular event. */
    function selfAffirmation(uint256 Event) external override {
        require(
            People[msg.sender][Event].showedUp == attended.False &&
                block.timestamp >= EventToAmountNTime[Event][1],
            "You are not a member of this event."
        );
        People[msg.sender][Event].showedUp = attended.True;
    }

    // DELETE THIS FUNCTION, ONLY FOR DEV
    // function showBalance() public view returns (uint256) {
    //     return address(this).balance;
    // }
}
