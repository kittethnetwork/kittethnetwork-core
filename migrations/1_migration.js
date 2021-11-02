const Migrations = artifacts.require("./kittethcoin.sol");

module.exports = function (deployer) {
  deployer.deploy(Migrations);
};
