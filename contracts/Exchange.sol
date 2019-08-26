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
    string public _name;

    constructor() public {
        _name = "Simple Exchange";
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

    function getBalanceOfExchangebleTocken(address account) external view returns(uint) {
        return exchangebleTocken.balanceOf(account);
    }

    function getBalanceOfMyTocken(address account) external view returns(uint) {
        return myTocken.balanceOf(account);
    }
}