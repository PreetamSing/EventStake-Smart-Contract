import Web3 from "web3";
import express from "express";
import fs from "fs";
const oracleJson = "../build/contracts/Oracle.json";
const oracleParsed = JSON.parse(fs.readFileSync(oracleJson));
/* To use following import statement, you have to run "node
--experimental-json-modules index.js", but that isn't really a good thing to do
in production. */
// import oracleJson from "../build/contracts/Oracle.json";

const app = express();

const PORT = process.env.PORT || 5000;
const web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:7545'));
const oracleInstance = new web3.eth.Contract(oracleParsed.abi, "0x645404383aD88938e0A1ed0098C6dd605946AfB5");
oracleInstance.events.GetRandomEventIdEvent().on('data', (err, returnVals) => {
    console.log("Somebody just asked for a random id.\n", err, "\n", returnVals)
})

app.listen(PORT, () => {
    console.log("Node server running on port", PORT);
})