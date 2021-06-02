// "SPDX-License-Identifier: UNLICENSED"
pragma solidity >=0.4.25;

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