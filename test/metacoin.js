const Currency = artifacts.require("Currency");
const Project = artifacts.require("Project");
const Intermediary = artifacts.require("Intermediary");

contract('Intermediary', (accounts) => {

  it("Setup", async () => {

    let intermediary = await Intermediary.new("Denis", {from: accounts[0]});
    let currency = await Currency.new("grivnya", 6, web3.utils.toBN("1000000000000000"), {from: accounts[1]});

    await intermediary.setCurrency(currency.address);

    console.log("here");
    await currency.increaseAllowance(accounts[0], web3.utils.toBN("1000000000000000"), {from:accounts[1]});
    await currency.increaseAllowance(accounts[1], web3.utils.toBN("1000000000000000"), {from:accounts[0]});
    console.log("and here");
    console.log(
      (await currency.allowance(accounts[1], accounts[0])).toString(),
      (await currency.balanceOf(accounts[1])).toString(),
      (await currency.balanceOf(accounts[0])).toString()
    );
    await currency.transferFrom(accounts[1], accounts[0], web3.utils.toBN("500000000000000"));
    console.log((await currency.balanceOf(accounts[0])).toString());


    console.log((await intermediary.getName()).toString());

    await intermediary.setCurrency(currency.address, {from:accounts[0]});
    let intermediaryAddress = intermediary.address;

    let projects = [];
    let intermediaryWallet = await intermediary.getWallet();
    for(let i = 2; i < 10; i++) {
      projects.push(await Project.new("Project" + i, i, "This is project number " + i, 6, 1000000, {from: accounts[i]}));
      await projects[i - 2].setIntermediary(intermediaryAddress, {from:accounts[i]});
      await projects[i - 2].setCurrency(currency.address, {from:accounts[i]});
    }

    for(let i = 0; i < 8; i++) {

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

    console.log((await projects[0].balanceOf(projects[0].address)).toString());
    console.log(
      (await projects[0].allowance(projects[0].address, accounts[0])).toString(),
      (await projects[0].allowance(accounts[0], projects[0].address)).toString()
      );
    await intermediary.buyProjectTokenInter("Project2", 5000, {from:accounts[0]});
    console.log((await projects[0].balanceOf(accounts[0])).toString());
    console.log((await projects[0].balanceOf(projects[0].address)).toString());

    await intermediary.registerNewUser(accounts[3]);
    await currency.transferFrom(accounts[1], accounts[3], 1000000);
    await intermediary.buyProjectToken("Project2", 1000, {from:accounts[3]});

    console.log((await projects[0].balanceOf(accounts[3])).toString());
    console.log((await projects[0].balanceOf(projects[0].address)).toString());
    console.log((await projects[0].balanceOf(accounts[0])).toString());

  });

  
  
});
