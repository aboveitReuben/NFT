import { Contract } from "ethers";
import Web3 from "web3";
import { abi } from "./constants";

const provider = new Web3.providers.HttpProvider("HTTP://127.0.0.1:7545");
const web3 = new Web3(provider);
const contract = new web3.eth.Contract(
  abi,
  "0x38bfb76562CC0f8C6d38b741BA07482b82a49B9e"
);
const transaction = contract.methods.setBaseURI("bla bla bla");
const options = {
  from: "0xE3e051a8241D95eaC84B8a58B7E36863eE9138df",
  to: "0x38bfb76562CC0f8C6d38b741BA07482b82a49B9e",
  data: "setURL",
};
const start = async () => {
  const tx = await contract.methods.setBaseURI("setURL").call(options);
  console.log(tx);
};

start();
