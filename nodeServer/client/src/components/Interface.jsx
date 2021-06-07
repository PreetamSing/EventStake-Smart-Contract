import React, { useState, useEffect } from 'react';
import { useDispatch, useSelector } from "react-redux";
import { Button, InputGroup } from 'react-bootstrap';
import "bootstrap/dist/css/bootstrap.min.css";

import { setEventStake } from "../store/actions/web3Actions";
import TimePicker from './TimePicker';

function Interface() {
    const { accounts, EventStake, web3 } = useSelector(state => state.web3State);
    const [startDate, setStartDate] = useState(new Date());
    const dispatch = useDispatch();

    const clickHandler = (e) => {
        const eventTime = parseInt(startDate.getTime() / 1000);
        EventStake.methods.createAnEvent(eventTime).send({
            from: accounts[0],
            value: web3.utils.toWei('0.001', 'ether')
        }).then((result) => {
            console.log(result);
        }).catch((err) => {
            console.log(err);
        });
    }

    useEffect(() => {
        dispatch(setEventStake());
    }, [dispatch])
    useEffect(() => {
        if (EventStake) {
            EventStake.events.newEventCreated({
                filter: {
                    creator: accounts[0]
                },
                fromBlock: 0
            }).on('data', function (event) {
                console.log(event); // same results as the optional callback
                })
                .on('changed', function (event) {
                    // remove event from local database
                })
                .on('error', console.error);
        }
    }, [EventStake])

    return (
        <div className="d-flex flex-column justify-content-center">
            <InputGroup className="mb-3">
                <InputGroup.Prepend>
                    <InputGroup.Text id="basic-addon1">Event Time</InputGroup.Text>
                </InputGroup.Prepend>
                <TimePicker startDate={startDate} setStartDate={setStartDate} />
            </InputGroup>
            <Button variant="primary" className="m-auto" onClick={clickHandler}>createAnEvent</Button>
        </div>
    )
}

export default Interface
