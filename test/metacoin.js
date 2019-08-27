const Exchange = artifacts.require("Exchange");
const Token = artifacts.require("ERC20Token");

const ExchangebleToken = artifacts.require("OtherFixedSupplyToken");
const MyToken =          artifacts.require("MyFixedSupplyToken");

contract('Exchange', (accounts) => {

  it('should show that my Token is working', async () => {
    const Token = await MyToken.deployed();

    const account = accounts[0];
    const amount = (await Token.balanceOf(account)).toString();
    console.log(account, amount);
  })


  it('should show that exchangeble Token is working', async () => {
    const Token = await ExchangebleToken.deployed();

    const account = accounts[0];
    const amount = (await Token.balanceOf(account)).toString();
    console.log(account, amount);
  });

  it('should show that I can transfer my Token to someone else', async () => {
    const Token = await MyToken.deployed();

    const owner = accounts[0];
    const account = accounts[1];
    const ownerBalance = (await Token.balanceOf(owner)).toString();
    const accountBalance = (await Token.balanceOf(account)).toString();

    console.log(ownerBalance, accountBalance);

    const result = await Token.approve(account,  web3.utils.toBN("600000000000000000000000"));
    Token.transferFrom(owner, account,  web3.utils.toBN("6000000000000000000000")).then(async () => {
      const amount = (await Token.balanceOf(account)).toString();
      console.log(amount);
    })
  });

  it('should show that I can transfer exchangeble Token to someone else', async () => {
    const Token = await ExchangebleToken.deployed();

    const owner = accounts[0];
    const account = accounts[1];
    const ownerBalance = (await Token.balanceOf(owner)).toString();
    const accountBalance = (await Token.balanceOf(account)).toString();

    console.log(ownerBalance, accountBalance);

    const result = await Token.approve(account,  web3.utils.toBN("600000000000000000000000"));
    await Token.transferFrom(owner, account,  web3.utils.toBN("6000000000000000000000")).then(async () => {
      const amount = (await Token.balanceOf(account)).toString();
      console.log(amount);
    })
  });

  it('should show what balances in each toknes of two accounts', async () => {
    const exchange = await Exchange.deployed();
    const Token = await MyToken.deployed();
    const eToken = await ExchangebleToken.deployed();

    await exchange.setMyToken(Token.address);
    await exchange.setExchangebleToken(eToken.address);
    
    const account = accounts[0];
    const account2 = accounts[1];


    const amount = web3.utils.toBN("2000000000000000000");

    console.log((await exchange.getBalanceOfMyToken(account)).toString());

    console.log("Token account", (await Token.balanceOf(account)).toString());

    console.log("EToken account", (await eToken.balanceOf(account)).toString());

    console.log("Token account2", (await Token.balanceOf(account2)).toString());

    console.log("EToken account2", (await eToken.balanceOf(account2)).toString());
    
    await exchange.sendMyToken(account, account2, web3.utils.toBN(amount));

    console.log("Token account", (await Token.balanceOf(account)).toString());

    console.log("EToken account", (await eToken.balanceOf(account)).toString());

    console.log("Token account2", (await Token.balanceOf(account2)).toString());

    console.log("EToken account2", (await eToken.balanceOf(account2)).toString());

  });

  
});
