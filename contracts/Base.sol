// "SPDX-License-Identifier: UNLICENSED"
pragma solidity >=0.4.25;

import "../../openzeppelin-contracts/contracts/access/Ownable.sol";
import "./OracleInterface.sol";

abstract contract Base is Ownable {
    // @dev Oracle Instance for connecting outside world.
    OracleInterface oracleInstance;

    // Global variables declaration
    enum attended {Unset, True, False}
    struct EventDetails {
        attended showedUp;
        uint256 amount;
    }
    address internal oracleAddress;
    mapping(address => mapping(uint256 => EventDetails)) internal People;
    // In following, array[0] is amount and array[1] is time.
    mapping(uint256 => uint256[2]) internal EventToAmountNTime;
    mapping(uint256 => address[]) internal EventToMembers; // Members in an event

    // Event Declarations
    event newEventCreated(
        uint256 EventId,
        uint256 atTime,
        address indexed creator
    );

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

    // Contract Destructor: Contract will no longer be available on blockchain
    function destroyContract() external onlyOwner {
        selfdestruct(payable(owner()));
    }

    // Inside OracleRelated.sol
    function distributeAmount(uint256 Event)
        external
        payable
        virtual
        returns (bool _success);

    function callback(
        address _creator,
        uint32 _id,
        uint256 _atTime,
        uint256 _EventId
    ) external virtual;

    function setOracleAddress(address _oracleAddress) external virtual;

    // Inside EventStake.sol
    function createAnEvent(uint256 atTime) external payable virtual;

    function addMeToEvent(address referrer, uint256 Event)
        external
        payable
        virtual;

    function addPersonToEvent(uint256 Event) internal virtual;

    function selfAffirmation(uint256 Event) external virtual;
}
