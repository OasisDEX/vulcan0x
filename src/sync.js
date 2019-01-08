/**
 * Sync PAST events
 */

import web3 from "./web3";
import { fire } from "./contract";
import { eachDeployment } from "./util";
import { dapps } from "../config/env";

const sync = (opt, id) => {
  const abi = require(`../dapp/${id}/abi/${opt.key}.json`);
  const contract = new web3.eth.Contract(abi, opt.key);
  const transformer = require(`../dapp/${id}`);
  web3.eth
    .getBlockNumber()
    .then(latest => {
      console.log("Latest block:", latest);
      transformer.events.forEach(event => batchSync(contract, event, opt.firstBlock, latest));
    })
    .catch(e => console.log(e));
};

export const makeBatches = (from, to, step, arr = []) => {
  const batchTo = from + step;

  if (batchTo >= to) {
    arr.push({ from, to });
    return arr;
  } else {
    arr.push({ from: from, to: batchTo });
    return makeBatches(batchTo, to, step, arr);
  }
};

const batchSync = async (contract, event, firstBlock, latestBlock) => {
  const step = parseInt(process.env.BATCH) || 2000;

  const batches = makeBatches(firstBlock, latestBlock, step);

  for (const batch of batches) {
    await syncEvents(contract, event, batch.from, batch.to);
  }
};

const syncEvents = (contract, event, from, to) => {
  if (from === to) {
    return;
  }

  const options = {
    fromBlock: from,
    toBlock: to,
    filter: event.filters || {},
  };

  return contract
    .getPastEvents(event.sig, options)
    .then(logs => logs.forEach(log => fire(event, log, contract)))
    .catch(e => {
      console.log("Error: ", e);
    });
};

const argv = require("yargs").argv;

if (argv.dapp) {
  eachDeployment(argv.dapp, sync);
} else {
  dapps.forEach(id => eachDeployment(id, sync));
}
