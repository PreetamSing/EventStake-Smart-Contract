const Oracle = artifacts.require("Oracle");
const EventStake = artifacts.require("EventStake");

module.exports = function (deployer) {
  deployer.deploy(EventStake, Oracle.address);
};
