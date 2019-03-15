import {sql} from '../../src/db';
import web3 from "../../src/web3";
const proxies = require("../../config/proxies.mainnet.json");
const ds_proxy_bytecode = require('./bytecode/dsproxy.json');

const proxy = {
  sig: "LogTake",
  transform: async function(log) {

    const transaction = await web3.eth.getTransaction(log.transactionHash);
    const tx_to = transaction.to.toLowerCase();
    let proxy_name = '';
    if(transaction.from !== log.returnValues.maker && transaction.from !== log.returnValues.taker) {
      const code = await web3.eth.getCode(transaction.to);

      if(code === ds_proxy_bytecode.bytecode) {
        proxy_name = ds_proxy_bytecode.name;
      } else {
        if( tx_to in proxies.proxyContracts) {
          proxy_name = proxies.proxyContracts[tx_to];
        }
      }

      return {
        address: transaction.to,
        tag: proxy_name,
        tx: log.transactionHash,
        from: transaction.from
      }
    } else return false
  },
  mutate: [
    sql("dapp/proxy/sql/proxyInfoInsert")
  ]
}

export const events = [proxy];



