var Deliveries = artifacts.require("./Deliveries.sol");

module.exports = function(deployer) {
  deployer.deploy(Deliveries);
};
