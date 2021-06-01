// "SPDX-License-Identifier: UNLICENSED"
pragma solidity >=0.4.25;

import "../../openzeppelin-contracts/contracts/utils/math/SafeMath.sol";
import "./OracleRelated.sol";

contract EventStake is OracleRelated {
    // Library usage declarations
    using SafeMath for uint256;

    // Constructor: @params _oracle is the address of the oracle
    constructor (address _oracle) {
        oracleAddress = _oracle;
        oracleInstance = OracleInterface(oracleAddress);
    }

    function createAnEvent(uint256 _atTime)
        external
        payable
        override
        minAmount
    {
        uint32 id = oracleInstance.getRandomEventId(_atTime, msg.sender);
        myReqs[id] = true;
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
                block.timestamp >= EventToAmountNTime[Event][1] &&
                block.timestamp <= (EventToAmountNTime[Event][1] + 3600),
            "You are not a member of this event."
        );
        People[msg.sender][Event].showedUp = attended.True;
    }

    // DELETE THIS FUNCTION, ONLY FOR DEV
    // function showBalance() public view returns (uint256) {
    //     return address(this).balance;
    // }
}
