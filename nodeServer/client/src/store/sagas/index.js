import { all } from '@redux-saga/core/effects';
import { watchGetAccounts } from './saga/getAccounts';

export default function* rootSaga() {
    yield all([
        watchGetAccounts()
    ]);
}