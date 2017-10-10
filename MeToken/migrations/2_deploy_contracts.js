var MeToken = artifacts.require("./MeToken.sol");

module.exports = function(deployer) {
  const tokenAmount = 15000;
  deployer.deploy(MeToken, tokenAmount);
};
