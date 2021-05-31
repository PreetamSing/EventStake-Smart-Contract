// "SPDX-License-Identifier: UNLICENSED"
pragma solidity >=0.4.25;

import "./Base.sol";
import "../../openzeppelin-contracts/contracts/utils/math/SafeMath.sol";
import "./libraries/ArrayMethods.sol";

abstract contract OracleRelated is Base {
    // Library usage declarations
    using SafeMath for uint256;

    /* using ArrayMethods for uint256[]; // This library isn't used yet. */

    // @dev Distribute the amount of the Event into all its members who showed up
    function distributeAmount(uint256 Event)
        external
        payable
        virtual
        override
        onlyOwner
    {
        uint256 N = EventToMembers[Event].length; // Number of Members in the Event
        uint256 PrevTotal = EventToAmountNTime[Event][0];
        /* Following deduction of amount is to cut out the profit of
        deployer, who is currently paying gas for calling this function
        through Oracle. It is transferred at the end of this function. */
        EventToAmountNTime[Event][0] = EventToAmountNTime[Event][0].sub(
            uint256(3000000).mul(17000000000)
        );
        uint256 didntAttendAmount = 0;
        for (uint256 i = 0; i < N; i++) {
            if (
                People[EventToMembers[Event][i]][Event].showedUp ==
                attended.False
            ) {
                didntAttendAmount += People[EventToMembers[Event][i]][Event]
                    .amount;
            }
        }
        for (uint256 i = 0; i < N; i++) {
            if (
                People[EventToMembers[Event][i]][Event].showedUp ==
                attended.True
            ) {
                (bool shouldGoAhead, uint256 amount) =
                    People[EventToMembers[Event][i]][Event]
                        .amount
                        .mul(10000)
                        .tryDiv(PrevTotal);
                require(shouldGoAhead, "Some error occured in calculation.");
                uint256 extraAmount = amount.mul(didntAttendAmount).div(10000);
                amount = amount.mul(EventToAmountNTime[Event][0]).div(10000);
                amount = amount.add(extraAmount);
                payable(EventToMembers[Event][i]).transfer(amount);
            }
            delete People[EventToMembers[Event][i]][Event];
        }
        /* Here, we send back some amount, for reason as described in beginning of func. */
        payable(msg.sender).transfer(uint256(3000000).mul(17000000000));
        delete EventToMembers[Event];
        delete EventToAmountNTime[Event];
    }
}
