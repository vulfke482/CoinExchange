const SafeMath = artifacts.require("SafeMath");
const ERC20Tocken = artifacts.require("ERC20Tocken");
const MyFixedTocken = artifacts.require("MyFixedSupplyTocken");
const OtherFixedTocken = artifacts.require("OtherFixedSupplyTocken");
const Exchange = artifacts.require("Exchange");

module.exports = function(deployer) {
  deployer.deploy(SafeMath);
  deployer.link(SafeMath, ERC20Tocken);

  deployer.deploy(ERC20Tocken);
  deployer.link(ERC20Tocken, MyFixedTocken);
  deployer.link(ERC20Tocken, OtherFixedTocken);

  deployer.deploy(MyFixedTocken);
  deployer.deploy(OtherFixedTocken);

  deployer.link(MyFixedTocken, Exchange);
  deployer.link(SafeMath, Exchange);
  deployer.link(OtherFixedTocken, Exchange);

  deployer.deploy(Exchange);
};
