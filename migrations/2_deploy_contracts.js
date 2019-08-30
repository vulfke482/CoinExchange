const SafeMath = artifacts.require("SafeMath");
const ERC20Token = artifacts.require("ERC20Token");
const Exchange = artifacts.require("Exchange");
const Intermediary = artifacts.require("Intermediary");
const Project = artifacts.require("Project");

module.exports = function(deployer) {
  deployer.deploy(SafeMath);
  deployer.link(SafeMath, ERC20Token);
  deployer.link(SafeMath, Project);
  deployer.link(SafeMath, Intermediary);

  deployer.deploy(ERC20Token);
  deployer.link(ERC20Token, Project);
  deployer.link(ERC20Token, Intermediary);

  deployer.deploy(Project);
  deployer.link(Project, Intermediary);

  deployer.deploy(Intermediary);
};
