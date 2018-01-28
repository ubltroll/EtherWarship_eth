var a = artifacts.require("HNP2Ship");

module.exports = function(deployer) {
  deployer.deploy(a);
};
var b = artifacts.require("EtherWarshipHNP");

module.exports = function(deployer) {
  deployer.deploy(b);
};