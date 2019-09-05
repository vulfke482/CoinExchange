const ERC20Token = artifacts.require("ERC20Token");
const Project = artifacts.require("Project");
const Intermediary = artifacts.require("Intermediary");

contract('Intermediary', (accounts) => {

  it("It should test trading between Project and Intermediary", async () => {

    let intermediary = await Intermediary.deployed();//("Denis", {from: accounts[0]});

    console.log("get name:", (await intermediary.getName()).toString());
    

    let intermediaryAddress = intermediary.address;
    let projects = [];
    for(let i = 1; i < 10; i++) {
      projects.push(await Project.new("Project" + i, i, "This is project number " + i, 6, 1000000, {from: accounts[i]}));
      await projects[i - 1].setIntermediary(intermediaryAddress, {from:accounts[i]});
    }
    console.log("here");

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


    console.log(await web3.eth.getBalance(accounts[1]));
    console.log(await web3.eth.getBalance(accounts[0]));

    var handleReceipt = (error, receipt) => {
      if (error) console.error(error);
      else {
        console.log(receipt);
      }
    }

    await intermediary.sendTransaction({to:intermediaryAddress, from:accounts[0], value:web3.utils.toWei("0.5", "ether"), gas:350}, handleReceipt);

    console.log(await web3.eth.getBalance(accounts[1]));
    console.log(await web3.eth.getBalance(accounts[0]));
    console.log(await web3.eth.getBalance(intermediaryAddress));
    console.log((await intermediary.getBalance()).toString());

    console.log((await projects[0].allowance(intermediaryAddress, projects[0].address)).toString());
    console.log((await projects[0].allowance(projects[0].address, intermediaryAddress)).toString());
    // let res=await intermediary.buyProjectTokenInter("Project1", 1000, {from:accounts[0]});
    // console.log("Token is bought");
    // console.log(res);
    // console.log((await intermediary.getBalanceForProject("Project1", {from:accounts[0]}) ).toString());

  });
  
});
