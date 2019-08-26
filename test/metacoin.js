const Exchange = artifacts.require("Exchange");
const Tocken = artifacts.require("ERC20Tocken");

const ExchangebleTocken = artifacts.require("OtherFixedSupplyTocken");
const MyTocken =          artifacts.require("MyFixedSupplyTocken");

contract('Exchange', (accounts) => {

  it('should show that my tocken is working', async () => {
    const tocken = await MyTocken.deployed();

    const account = accounts[0];
    const amount = (await tocken.balanceOf(account)).toString();
    console.log(account, amount);
  })


  it('should show that exchangeble tocken is working', async () => {
    const tocken = await ExchangebleTocken.deployed();

    const account = accounts[0];
    const amount = (await tocken.balanceOf(account)).toString();
    console.log(account, amount);
  });

  it('should show that I can transfer my tocken to someone else', async () => {
    const tocken = await MyTocken.deployed();

    const owner = accounts[0];
    const account = accounts[1];
    const ownerBalance = (await tocken.balanceOf(owner)).toString();
    const accountBalance = (await tocken.balanceOf(account)).toString();

    console.log(ownerBalance, accountBalance);

    const result = await tocken.approve(account,  web3.utils.toBN("600000000000000000000000"));
    tocken.transferFrom(owner, account,  web3.utils.toBN("6000000000000000000000")).then(async () => {
      const amount = (await tocken.balanceOf(account)).toString();
      console.log(amount);
    })
  });

  it('should show that I can transfer exchangeble tocken to someone else', async () => {
    const tocken = await ExchangebleTocken.deployed();

    const owner = accounts[0];
    const account = accounts[1];
    const ownerBalance = (await tocken.balanceOf(owner)).toString();
    const accountBalance = (await tocken.balanceOf(account)).toString();

    console.log(ownerBalance, accountBalance);

    const result = await tocken.approve(account,  web3.utils.toBN("600000000000000000000000"));
    await tocken.transferFrom(owner, account,  web3.utils.toBN("6000000000000000000000")).then(async () => {
      const amount = (await tocken.balanceOf(account)).toString();
      console.log(amount);
    })
  });

  it('should show what balances in each toknes of two accounts', async () => {
    const exchange = await Exchange.deployed();
    const tocken = await MyTocken.deployed();
    const etocken = await ExchangebleTocken.deployed();

    const account = accounts[0];
    const account2 = accounts[1];


    const amount = web3.utils.toBN("200000000000000000000000");


    await exchange.byMyTocken(amount).send({from:account2});

    console.log("Tocken account", (await tocken.balanceOf(account)).toString());

    console.log("ETocken account", (await etocken.balanceOf(account)).toString());

    console.log("Tocken account2", (await tocken.balanceOf(account2)).toString());

    console.log("ETocken account2", (await etocken.balanceOf(account2)).toString());

  });

  
});
