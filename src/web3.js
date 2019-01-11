import { chain } from '../config/env';

const Web3 = require('web3');

function getProvider() {
  // ganache works a little bit differently then other nodes so we provider different provider for websockets
  if (chain.id === "local") {
    return new Web3.providers.WebsocketProvider(chain.provider)
  } else {
    return Web3.givenProvider || chain.provider;
  }
}

const web3 = new Web3(getProvider());

console.log("web3:", web3.version);

export default web3
