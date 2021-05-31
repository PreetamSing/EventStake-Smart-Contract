# EventStake-Smart-Contract
Ethereum Blockchain Smart Contract inspired by last challenge on this site: https://ethhole.com/challenge

Features:
* Anybody can create an Event.
* But to be a creator you have to pay RSVP (which means a creator is a member by default).
* Any member of an event can invite others to that particular event.
* By Solidity's natural functioning, while refunding gas cost will be deducted from each person's amount.
* You can pay any amount of RSVP, more than 0.001 ether.
* RSVPs of all who didn't show up will be added and then divided amongst all who showed up based on their contributions.
* All members of an event need to report, that is, show up on the set time of the event.
* After 1 hour of the set Event Time, Accumulated Amount of that Event will start getting distributed.

For "openzeppelin-contracts", you can clone and use this repo: https://github.com/OpenZeppelin/openzeppelin-contracts
