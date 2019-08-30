const SafeMath = artifacts.require("SafeMath");
const ERC20Token = artifacts.require("ERC20Token");
const Project = artifacts.require("Project");
const Intermediary = artifacts.require("Intermediary");

module.exports = function(deployer) {
  deployer.deploy(SafeMath);
  deployer.link(SafeMath, ERC20Token);
  deployer.link(SafeMath, Project);
  deployer.link(SafeMath, Intermediary);

  deployer.deploy(ERC20Token, 0, 0);
  deployer.link(ERC20Token, Project);
  deployer.link(ERC20Token, Intermediary);

  deployer.deploy(Project, "project", 0, "project", 0, 0);
  deployer.link(Project, Intermediary);

  deployer.deploy(Intermediary, "intermediary");
};
