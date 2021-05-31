// "SPDX-License-Identifier: UNLICENSED"
pragma solidity >=0.4.25;

library ArrayMethods {
    // @dev Returns true if an array has an item, else false.
    function includes(uint256[] memory array, uint256 elem)
        internal
        pure
        returns (bool)
    {
        for (uint256 i = 0; i < array.length; i++) {
            if (array[i] == elem) return true;
        }
        return false;
    }
}
