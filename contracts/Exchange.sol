pragma solidity ^0.5.0;

import {MyFixedSupplyToken} from "./MyFixedToken.sol";
import {OtherFixedSupplyToken} from "./OtherFixedToken.sol";
import {SafeMath} from "./SafeMath.sol";
import {ERC20Token} from "./Token.sol";

contract Exchange {
    using SafeMath for uint;

    ERC20Token public myToken;
    ERC20Token public exchangebleToken;
    // I just want to create constructor, in this case i need something to initialize
    string public m_name;

    constructor() public {
        m_name = "Simple Exchange";
    }

    function setMyToken(address tokenAddress) public returns (bool success) {
        myToken = ERC20Token(tokenAddress);
        return true;
    }

    function setExchangebleToken(address tokenAddress) public returns (bool success) {
        exchangebleToken = ERC20Token(tokenAddress);
        return true;
    }

    function sendMyToken(address from, address to, uint amount) public returns (bool success) {
        exchangebleToken.transferFrom(to, from, amount);
        myToken.transferFrom(from, to, amount);
        return true;
    }

    function sendExchangebleToken(address from, address to, uint amount) public returns (bool success) {
        exchangebleToken.transferFrom(to, from, amount);
        myToken.transferFrom(from, to, amount);
        return true;
    }

    function getBalanceOfExchangebleToken(address account) public view returns(uint) {
        uint balance = uint(exchangebleToken.balanceOf(account));
        return balance;
    }

    function getBalanceOfMyToken(address account) public view returns(uint) {
        uint result = uint(myToken.balanceOf(account));
        return result;
    }

    function getName() public view returns(string memory) {
        return m_name;
    }
}