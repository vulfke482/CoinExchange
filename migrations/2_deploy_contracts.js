const SafeMath = artifacts.require("SafeMath");
const ERC20Token = artifacts.require("ERC20Token");
const MyFixedToken = artifacts.require("MyFixedSupplyToken");
const OtherFixedToken = artifacts.require("OtherFixedSupplyToken");
const Exchange = artifacts.require("Exchange");

module.exports = function(deployer) {
  deployer.deploy(SafeMath);
  deployer.link(SafeMath, ERC20Token);

  deployer.deploy(ERC20Token);
  deployer.link(ERC20Token, MyFixedToken);
  deployer.link(ERC20Token, OtherFixedToken);

  deployer.deploy(MyFixedToken);
  deployer.deploy(OtherFixedToken);

  deployer.link(MyFixedToken, Exchange);
  deployer.link(SafeMath, Exchange);
  deployer.link(OtherFixedToken, Exchange);

  deployer.deploy(Exchange);
};
