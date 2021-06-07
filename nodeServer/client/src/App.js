import React, { useEffect, useState } from "react";
import { useDispatch } from 'react-redux';
import Web3 from "web3";

import Interface from "./components/Interface";
import { setWeb3, getAccountsSaga } from "./store/actions/web3Actions";

function App() {
  const [loading, setLoading] = useState(true);
  const dispatch = useDispatch();

  useEffect(() => {
    const injectWeb3 = async () => {
      if (window.ethereum) {
        await window.ethereum.send('eth_requestAccounts');
        window.web3 = new Web3(window.ethereum);
        dispatch(setWeb3());
        dispatch(getAccountsSaga(setLoading));
      }
    }
    injectWeb3();
  }, [Web3])
  return (
    <div className="App">
      {
        loading ?
          <h1>MetaMask's Integration Permission is required!</h1> :
          <Interface />
      }
    </div>
  );
}

export default App;
