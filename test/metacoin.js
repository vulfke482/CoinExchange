const Currency = artifacts.require("Currency");
const Project = artifacts.require("Project");
const Intermediary = artifacts.require("Intermediary");

contract('Intermediary', (accounts) => {

  let intermediary;
  let currency;
  let project;

  it("Setup", async () => {

    intermediary = await Intermediary.new("Denis", {from: accounts[0]});
    currency = await Currency.new("grivnya", 6, web3.utils.toBN("1000000000000000"), {from: accounts[1]});

    await currency.setIntermediary(intermediary.address, {from:accounts[1]});
    await intermediary.setCurrency(currency.address);

    await currency.increaseAllowance(accounts[0], web3.utils.toBN("1000000000000000"), {from:accounts[1]});
    await currency.increaseAllowance(accounts[1], web3.utils.toBN("1000000000000000"), {from:accounts[0]});

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

    project = await Project.new("Project" + 2, "This is project number " + 2, 6, 1000000, {from: accounts[2]});
    await project.setIntermediary(intermediaryAddress, {from:accounts[2]});
    await project.setCurrency(currency.address, {from:accounts[2]});
    
    console.log("Starting register account");
    await intermediary.registerNewProject(project.address, {from:accounts[0]});
    console.log("Finishing register account");

    console.log("Trying to by token");

    console.log((await project.balanceOf(project.address)).toString());
    console.log(
      (await project.allowance(project.address, accounts[0])).toString(),
      (await project.allowance(accounts[0], project.address)).toString()
      );

    console.log(
      "Intermediary - Balance for Project2 token:", (await intermediary.getBalanceForProject("Project2", {from:accounts[0]})).toString(),
      "\nIntermediary - Balance for currency:", (await intermediary.getBalanceForCurrency({from: accounts[0]})).toString()
      );

    });
  
    it("Intermediary tries to buy token", async () => {

    console.log("Intermediary buyes token");
    await intermediary.buyProjectTokenInter("Project2", 5000, {from:accounts[0]});
    console.log("After intermediary bought token");
    console.log(
      "Intermediary - Balance for Project2 token:", (await intermediary.getBalanceForProject("Project2", {from:accounts[0]})).toString(),
      "\nIntermediary - Balance for currency:", (await intermediary.getBalanceForCurrency({from: accounts[0]})).toString()
      );
    });

    it("User tries to buy token", async () => {

    console.log("Buying...");
    await currency.transferFrom(accounts[1], accounts[3], 1000000);
    await intermediary.buyProjectToken("Project2", 1000, {from:accounts[3]});

    console.log("After buy");
    console.log(
      "Account - Balance for Project2 token:", (await intermediary.getBalanceForProject("Project2", {from:accounts[3]})).toString(),
      "\nAccount - Balance for currency:", (await intermediary.getBalanceForCurrency({from: accounts[3]})).toString()
      );

    console.log(
      "Intermediary - Balance for Project2 token:", (await intermediary.getBalanceForProject("Project2", {from:accounts[0]})).toString(),
      "\nIntermediary - Balance for currency:", (await intermediary.getBalanceForCurrency({from: accounts[0]})).toString()
      );
    });

    it("User tries to sell token", async () => {

    console.log("Sell...");
    await intermediary.sellProjectToken("Project2", 500, {from:accounts[3]});

    console.log("After sell");
    console.log(
      "Account - Balance for Project2 token:", (await intermediary.getBalanceForProject("Project2", {from:accounts[3]})).toString(),
      "\nAccount - Balance for currency:", (await intermediary.getBalanceForCurrency({from: accounts[3]})).toString()
      );
    
    console.log(
      "Intermediary - Balance for Project2 token:", (await intermediary.getBalanceForProject("Project2", {from:accounts[0]})).toString(),
      "\nIntermediary - Balance for currency:", (await intermediary.getBalanceForCurrency({from: accounts[0]})).toString()
      );
  });

  it("Intermediary tries to sell token", async () => {

    console.log("Intermediary buyes token");
    console.log((await intermediary.getBalanceForProject("Project2", {from:accounts[0]})).toString());
    await intermediary.sellProjectTokenInter("Project2", 2000, {from:accounts[0]});
    console.log("After intermediary bought token");
    console.log(
      "Intermediary - Balance for Project2 token:", (await intermediary.getBalanceForProject("Project2", {from:accounts[0]})).toString(),
      "\nIntermediary - Balance for currency:", (await intermediary.getBalanceForCurrency({from: accounts[0]})).toString()
      );
  });
  
  
});
