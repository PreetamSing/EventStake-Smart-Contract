import * as actionTypes from '../actionTypes';

export const setWeb3 = () => ({
    type: actionTypes.SET_WEB3
})

export const getAccountsSaga = (setLoading) => ({
    type: actionTypes.GET_ACCOUNTS_SAGA,
    setLoading
})

export const setEventStake = () => ({
    type: actionTypes.SET_EVENTSTAKE
})