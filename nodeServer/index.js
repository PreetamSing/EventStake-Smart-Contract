import Web3 from "web3";
import express from "express";
import HDWalletProvider from "@truffle/hdwallet-provider";
import dotenv from "dotenv";
import fs from "fs";
import BN from "bn.js";
const oracleJson = "../build/contracts/Oracle.json";
const oracleParsed = JSON.parse(fs.readFileSync(oracleJson));
/* To use following import statement, you have to run "node
--experimental-json-modules index.js", but that isn't really a good thing to do
in production. */
// import oracleJson from "../build/contracts/Oracle.json";

dotenv.config({ path: '../.env' });

const app = express();

// To make HDWallet less "chatty" over JSON-RPC,
// configure a higher value for the polling interval.
const provider = new HDWalletProvider(process.env.privateKey, process.env.provider);
const address = provider.addresses[0];

const PORT = process.env.PORT || 5000;
const web3 = new Web3(process.env.providerWss);
const oracleInstance = new web3.eth.Contract(oracleParsed.abi, process.env.oracleAdd);
web3.eth.accounts.wallet.add(process.env.privateKey);
oracleInstance.events.GetRandomEventIdEvent({})
    .on('data', async (event) => {
        console.log(event); // same results as the optional callback above
        const id = parseInt(event.returnValues.id);
        const atTime = parseInt(event.returnValues.atTime);
        const asker = event.returnValues.asker;
        const eventCreator = event.returnValues.eventCreator;
        const EventId = parseInt(Math.random().toString().replace('.', ''));
        console.log(EventId)
        const txData = await convertToTxData(
            oracleInstance.methods.setRandomEventId,
            asker, eventCreator, id, atTime, EventId
        )
        let shouldSetTimer = false;
        await web3.eth.sendTransaction(txData)
            .then((response) => { shouldSetTimer = true })
            .catch(async (error) => {
                console.log(error);
                await web3.eth.sendTransaction(txData)
                    .then((resp) => { shouldSetTimer = true })
            })
        if (shouldSetTimer) {
            console.log("Timer is being set");
            setTimeout(async function amountDistribution(maxRecall) {
                let recall = false;
                const txData = await convertToTxData(
                    oracleInstance.methods.callDistributAmount,
                    asker, EventId
                )
                await web3.eth.sendTransaction(txData)
                    .then((response) => console.log("****", response, "****"))
                    .catch((error) => {
                        console.log(error);
                        recall = true;
                    })
                if (recall && maxRecall <= 5) setTimeout(amountDistribution, 60 * 1000, maxRecall + 1);
            }, (((atTime + 3600) * 1000) - Date.now()), 1)
        }
    })
    .on('changed', (event) => {
        // remove event from local database
    })
    .on('error', console.error);

app.listen(PORT, () => {
    console.log("Node server running on port", PORT);
})

app.post('/selfdestruct', (req, res) => {
    const { password } = req.body;
    sha256(password).then((hashHex) => {
        if (hashHex === "df7682099c96e3f66171aed65ba78ae5200ba7200278569327e6cabf16c98b96") {
            oracleInstance.methods.destroyContract().send({ from: provider.addresses[0] });
            res.status(200);
        }
        else res.status(401);
    })
})

async function convertToTxData(func, ...args) {
    const tx = func(...args);
    const gas = await tx.estimateGas({ from: address });
    const gasPrice = await web3.eth.getGasPrice();
    const data = tx.encodeABI();
    const nonce = await web3.eth.getTransactionCount(address);
    const txData = {
        from: address,
        to: process.env.oracleAdd,
        data: data,
        gas,
        gasPrice,
        nonce,
        chain: 'rinkeby',
        hardfork: 'istanbul'
    };
    
    return txData;
}

async function sha256(message) {
    // encode as UTF-8
    const msgBuffer = new TextEncoder().encode(message);

    // hash the message
    const hashBuffer = await crypto.subtle.digest('SHA-256', msgBuffer);

    // convert ArrayBuffer to Array
    const hashArray = Array.from(new Uint8Array(hashBuffer));

    // convert bytes to hex string                  
    const hashHex = hashArray.map(b => b.toString(16).padStart(2, '0')).join('');
    return hashHex;
}