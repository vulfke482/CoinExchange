const Currency = artifacts.require("Currency");
const Project = artifacts.require("Project");
const Intermediary = artifacts.require("Intermediary");

module.exports = function(deployer) {

  deployer.deploy(Currency);
  deployer.link(Currency, Intermediary);
  
  deployer.deploy(Project, "project", 0, "project", 0, 0);
  deployer.link(Project, Intermediary);

  deployer.deploy(Intermediary, "intermediary");
};
