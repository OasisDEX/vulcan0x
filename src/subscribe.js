/**
 * Subscribes to new events from blockchain.
 */

import web3 from "./web3";
import { listen } from "./contract";
import { eachDeployment, preventExit } from "./util";
import { dapps } from "../config/env";

const subscribe = (opt, id) => {
  if (opt.lastBlock) {
    console.log(`Last block defined. Skipping: ${id} ${opt.desc}`);
    return;
  }
  const abi = require(`../dapp/${id}/abi/${opt.key}.json`);
  const contract = new web3.eth.Contract(abi, opt.key);
  const transformer = require(`../dapp/${id}`);
  console.log(`Subscribe: ${id} ${opt.desc}`);
  listen(contract, transformer.events);
};

const argv = require("yargs").argv;

if (argv.dapp) {
  eachDeployment(argv.dapp, subscribe);
} else {
  dapps.forEach(id => eachDeployment(id, subscribe));
}

preventExit();