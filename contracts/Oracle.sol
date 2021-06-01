// "SPDX-License-Identifier: UNLICENSED"
pragma solidity >=0.4.25;

import "../../openzeppelin-contracts/contracts/access/Ownable.sol";

// Event Stake Contract's Interface
interface EventStakeInterface {
    function distributeAmount(uint256 Event)
        external
        payable
        returns (bool _success);

    function callback(
        address _creator,
        uint32 _id,
        uint256 _atTime,
        uint256 _EventId
    ) external;
}

/* This seperate oracle formation may seem a bit overkill for this project,
but in long run, it is more scalable as compared to direct integration of these
functions into EventStake Contract. Also, we can make it more decentralised,
but won't for the sake of simplicity and lack of need in this project. */
contract Oracle is Ownable {
    // Global Variable Declaration
    uint32 private randNonce = 0;
    mapping(uint32 => bool) pendingReqs;

    // Events Declaration
    event GetRandomEventIdEvent(
        address asker,
        address eventCreator,
        uint32 id,
        uint256 atTime
    );

    function getRandomEventId(uint256 _atTime, address _creator)
        external
        returns (uint32)
    {
        randNonce++;
        emit GetRandomEventIdEvent(msg.sender, _creator, randNonce, _atTime);
        pendingReqs[randNonce] = true;
        return randNonce;
    }

    function setRandomEventId(
        address _asker,
        address _creator,
        uint32 _id,
        uint256 _atTime,
        uint256 _EventId
    ) public onlyOwner {
        require(pendingReqs[_id], "This request is not pending.");
        EventStakeInterface(_asker).callback(_creator, _id, _atTime, _EventId);
        delete pendingReqs[_id];
    }

    function callDistributAmount(address _contractAdd, uint256 _EventId)
        public
        onlyOwner
    {
        bool result =
            EventStakeInterface(_contractAdd).distributeAmount(_EventId);
        require(result, "Something Went Wrong!");
    }
}
