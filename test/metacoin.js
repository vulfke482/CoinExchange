const ERC20Token = artifacts.require("ERC20Token");
const Project = artifacts.require("Project");
const Intermediary = artifacts.require("Intermediary");

contract('Intermediary', (accounts) => {

  it("It should test trading between Project and Intermediary", async () => {

    let intermediary = await Intermediary.new("Denis", {from: accounts[0]});
    let currency = await ERC20Token.new(6, 100000000);

    console.log((await intermediary.getName()).toString());

    // await intermediary.setCurrency(currency, {from:accounts[0]});
    let intermediaryAddress = intermediary.address;

    let projects = [];
    for(let i = 1; i < 10; i++) {
      projects.push(await Project.new("Project" + i, i, "This is project number " + i, 6, 1000000, {from: accounts[i]}));
      await projects[i - 1].setCurrency(currency.address, {from:accounts[i]});
      await projects[i - 1].setIntermediary(intermediaryAddress, {from:accounts[i]});
    }

    for(let i = 0; i < 9; i++) {

      let projectInter = (await projects[i].getIntermediary()).toString();
      console.log(projectInter, accounts[0]);
    }

    for(let project of projects) {
      console.log((await project.getName()).toString() + " " + (await project.getDescription()).toString());
    }
    
    console.log("Starting register accounts");
    for(let project of projects) {
      await intermediary.registerNewProject(project.address, {from:accounts[0]});
    }
    console.log("Finishing register accounts");

    console.log("Trying to by token");
    let res=await intermediary.buyProjectToken("Project1", 1000, {from:accounts[0]});
    console.log("Token is bought");
    console.log(res);
    console.log((await intermediary.getBalanceForProject("Project1", {from:accounts[0]}) ).toString());

  });
  
});
