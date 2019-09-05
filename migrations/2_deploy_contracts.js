const Currency = artifacts.require("Currency");
const Project = artifacts.require("Project");
const Intermediary = artifacts.require("Intermediary");

module.exports = function(deployer) {

  deployer.deploy(Currency, "grivnya", 6, 0);
  deployer.link(Currency, Intermediary);
  
  deployer.deploy(Project, "project", "project", 0, 0);
  deployer.link(Project, Intermediary);

  deployer.deploy(Intermediary, "intermediary");
};
