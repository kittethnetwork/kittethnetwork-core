const KittethCoin = artifacts.require("KittethCoin");

module.exports = function (deployer) {
  deployer.deploy(KittethCoin);
};
