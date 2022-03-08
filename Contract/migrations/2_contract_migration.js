const Web3TestContract = artifacts.require("Web3TestContract");

module.exports = function (deployer) {
  deployer.deploy(Web3TestContract, "TestContract", "Web3TestContract");
};
