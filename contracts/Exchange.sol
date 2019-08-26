pragma solidity ^0.5.0;

import {MyFixedSupplyTocken} from "./MyFixedTocken.sol";
import {OtherFixedSupplyTocken} from "./OtherFixedTocken.sol";
import {SafeMath} from "./SafeMath.sol";

contract Exchange {
    using SafeMath for uint;

    MyFixedSupplyTocken public myTocken;
    OtherFixedSupplyTocken public exchangebleTocken;
    uint exchangeRate;

    // I just want to create constructor, in this case i need something to initialize
    string public m_name;

    constructor() public {
        m_name = "Simple Exchange";
        exchangeRate = 2;
    }

    function byMyTocken(uint amount) public returns (bool success) {
        uint neededAmount = amount.mul(exchangeRate);
        address wallet = address(myTocken.owner);

        require(exchangebleTocken.balanceOf(msg.sender) >= neededAmount, "You don't have enough exchangeble tocken");
        require(myTocken.balanceOf(wallet) >= amount, "This amount of mytocken is not avaliable");

        exchangebleTocken.transferFrom(msg.sender, wallet, neededAmount);
        myTocken.transferFrom(wallet, msg.sender, amount);
        return true;
    }

    function byExchangebleTocken(uint amount) public returns (bool success) {
        uint neededAmount = amount.mul(exchangeRate);
        address wallet = address(myTocken.owner);

        require(exchangebleTocken.balanceOf(wallet) >= neededAmount, "We don't have enough exchangeble tocken");
        require(myTocken.balanceOf(msg.sender) >= amount, "You don't have enough mytocken");

        exchangebleTocken.transferFrom(wallet, msg.sender, neededAmount);
        myTocken.transferFrom(msg.sender, wallet, amount);
        return true;
    }

    function sendMyTocken(address from, address to, uint amount) public returns (bool success) {
        uint neededAmount = amount.mul(exchangeRate);

        require(exchangebleTocken.balanceOf(to) >= neededAmount, "You don't have enough exchangeble tocken");
        require(myTocken.balanceOf(from) >= amount, "This amount of mytocken is not avaliable");

        exchangebleTocken.transferFrom(to, from, neededAmount);
        myTocken.transferFrom(from, to, amount);
        return true;
    }

    function sendExchangebleTocken(address from, address to, uint amount) public returns (bool success) {
        uint neededAmount = amount.mul(exchangeRate);
        address wallet  = from;
        require(exchangebleTocken.balanceOf(wallet) >= neededAmount, "We don't have enough exchangeble tocken");
        require(myTocken.balanceOf(msg.sender) >= amount, "You don't have enough mytocken");

        exchangebleTocken.transferFrom(wallet, msg.sender, neededAmount);
        myTocken.transferFrom(msg.sender, wallet, amount);
        return true;
    }

    function getBalanceOfExchangebleTocken(address account) public view returns(uint) {
        return exchangebleTocken.balanceOf(account);
    }

    function getBalanceOfMyTocken(address account) public view returns(uint) {
        uint result = myTocken.balanceOf(account);
        return result;
    }

    function getName() public view returns(string memory) {
        return m_name;
    }
}