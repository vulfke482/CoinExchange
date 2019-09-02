const SafeMath = artifacts.require("SafeMath");
const ERC20Token = artifacts.require("ERC20Token");
const Project = artifacts.require("Project");
const Intermediary = artifacts.require("Intermediary");

module.exports = function(deployer) {


  deployer.deploy(Project, "project", 0, "project", 0, 0);
  deployer.link(Project, Intermediary);

  deployer.deploy(Intermediary, "intermediary");
};
