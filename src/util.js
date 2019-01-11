import web3 from "web3";
import BigNumber from "bignumber.js";
import { chain } from "../config/env";

const jp = require("jsonpath");
const tokens = require(`../config/tokens.${chain.id}`);

export const wad = (uint, gem) => {
  const token = jp.query(tokens, `$.erc20[?(@.key=="${gem}")]`)[0];
  if (!token) {
    console.log("Unrecognized erc20:", gem);
  }
  const dec = token ? token.decimals : 18;
  return new BigNumber(uint).dividedBy(`1e${dec}`).toNumber();
};

export const id = hex => {
  return web3.utils.hexToNumber(hex);
};

const dapps = require("../config/dapps");

export const eachDeployment = (id, f) => {
  const dapp = jp.query(dapps, `$.dapps[?(@.id=="${id}")]`);

  return jp.query(dapp, `$..[?(@.chain=="${chain.id}")]`).map(deployment => f(deployment, id));
};

// Prevent node process from exiting while waiting for callbacks etc. Useful for sync.js script which waits for web3 callbacks which can not be fired for a long time
// inspired by https://stackoverflow.com/questions/6442676/how-to-prevent-node-js-from-exiting-while-waiting-for-a-callback
// is there a better way to achieve this?
export function preventExit() {
  setTimeout(preventExit, 10000);
}