// "SPDX-License-Identifier: UNLICENSED"
pragma solidity >=0.4.25;

interface OracleInterface {
    function getRandomEventId(uint _atTime, address _creator) external returns (uint32);
}