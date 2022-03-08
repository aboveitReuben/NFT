const TheGangoSolGang = artifacts.require("TheGangoSolGang");

module.exports = function (deployer) {
  deployer.deploy(TheGangoSolGang, "TheGangoSolGang", "TheGangoSolGang");
};
