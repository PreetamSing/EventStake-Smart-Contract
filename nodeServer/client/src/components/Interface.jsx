import React from 'react'
import Web3 from "web3";

import { abi } from "../abi/EventStake.json";

function Interface() {
    const web3 = new Web3(Web3.givenProvider);
    const [accounts, setAccounts] = React.useState([]);
    const contractAdd = "0x69FFd7B729a552edB2AACa3dFC836284D0dbE784";
    const contract = new web3.eth.Contract(abi, contractAdd);

    const clickHandler = (e) => {
        contract.methods.createAnEvent(123).send({
            from: accounts[0],
            value: web3.utils.toWei('0.001', 'ether')
        }).then((result) => {
            console.log(result);
        }).catch((err) => {
            console.log(err);
        });
    }

    React.useEffect(async () => {
        if (window.ethereum) {
            await window.ethereum.send('eth_requestAccounts');
            window.web3 = new Web3(window.ethereum);
            web3.eth.getAccounts()
                .then((accounts) => setAccounts(accounts))
                .catch((err) => console.log(err));
        }
    }, [Web3])
    return (
        <div>
            <button onClick={clickHandler}>createAnEvent</button>
        </div>
    )
}

export default Interface
