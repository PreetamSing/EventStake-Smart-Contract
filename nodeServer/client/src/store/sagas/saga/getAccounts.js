import { call, put, takeLatest, select } from 'redux-saga/effects';
import * as actionTypes from '../../actionTypes';

function* getAccounts(action) {
    try {
        const web3 = yield select(state => state.web3State?.web3);
        const accounts = yield call(web3.eth.getAccounts);
        yield put({
            type: actionTypes.SET_ACCOUNTS,
            payload: accounts
        });
        if (accounts) action.setLoading(false);
    } catch (error) {
        console.log(error);
    }
}

export function* watchGetAccounts() {
    yield takeLatest(actionTypes.GET_ACCOUNTS_SAGA, getAccounts);
}