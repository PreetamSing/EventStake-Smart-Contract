import * as actionTypes from "../actionTypes";
import { produce } from "immer";
import Web3 from "web3";

import abi from "../../abi/EventStake.json";

const initialState = {
    EventStakeAddress: "0x69FFd7B729a552edB2AACa3dFC836284D0dbE784"
};

const reducer = (state = initialState, { type, payload }) => {
    switch (type) {

    case actionTypes.SET_WEB3:
        return produce(state, copiedState => {
            copiedState.web3 = new Web3(Web3.givenProvider);
            console.log("first", copiedState)
        })

    case actionTypes.SET_ACCOUNTS:
        return produce(state, copiedState => {
            copiedState.accounts = payload;
        })

    case actionTypes.SET_EVENTSTAKE:
        return produce(state, copiedState => {
            console.log("second", copiedState)
            copiedState.EventStake = new copiedState.web3.eth.Contract(
                abi, copiedState.EventStakeAddress
            )
        })

    default:
        return state
    }
}

export default reducer;