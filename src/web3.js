import { chain } from "../config/env";

const Web3 = require("web3");

export function setProvider(runOnFail) {
  const provider = new Web3.providers.WebsocketProvider(chain.provider);
  provider.on("error", e => {
    console.log("WS-ERROR: ", e);

    console.log("Reconnecting...");
    return setProvider(runOnFail);
  });

  provider.on("end", e => {
    console.log("WS-END: ", e);

    console.log("Reconnecting...");
    return setProvider(runOnFail);
  });

  web3.setProvider(provider);
  runOnFail && runOnFail();
  return;
}

const web3 = new Web3();

setProvider();

console.log("web3:", web3.version);

export default web3;
