pragma solidity ^0.5.0;

import {SafeMath} from "./SafeMath.sol";
import {ERC20Token} from "./Token.sol";

contract Project is ERC20Token {
    using SafeMath for uint;

    string name_;
    string description_;
    uint _totalSupply;
    uint price_;
    address owner_;
    address intermediary_;
    ERC20Token currency_;

    constructor(string memory name,  uint price, string memory description, uint8 decimals, uint128 totalSupply)
    ERC20Token(decimals, totalSupply) public {
        name_ = name;
        price_ = price;
        description_ = description;
        owner_ = msg.sender;
    }

    // Public functions

    // Set price - avaliable only for intermediary
    function setPrice(uint price) public returns(bool success) {
        if(msg.sender != intermediary_) return false;
        price_ = price;
        return true;
    }

    // Set intermediary - avaliable only for owner.
    function setIntermediary(address intermediary) public returns(bool success) {
        if(msg.sender != owner_) return false;
        intermediary_ = intermediary;
        return true;
    }

    // Set currency - avaliable only for owner
    function setCurrency(ERC20Token currency) public returns(bool success) {
        if(msg.sender != owner_) return false;
        currency_ = currency;
        return true;
    }

    // Buy token - avaliable only for intermediary (for now).
    function buyToken(uint amount) public returns(bool success) {
        if(msg.sender != intermediary_) return false;
        transferFrom(owner_, intermediary_, amount);   // is not safe
        currency_.transfer(owner_, amount.mul(price_));
        return true;
    }

    // Sell token - avaliable only for intermediary (for now).
    function sellToken(uint amount) public returns(bool success) {
        if(msg.sender != intermediary_) return false;
        transfer(owner_, amount);
        currency_.transferFrom(owner_, intermediary_, amount.mul(price_)); // is not safe
        return true;
    }

    // Get price.
    function getPrice() public view returns(uint) {
        return price_;
    }

    // Get project's name.
    function getName() public view returns(string memory) {
        return name_;
    }

    // Get project's owner.
    function getOwner() public view returns(address owner) {
        return owner_;
    }

    // Get currency balance.
    function getCurrencyBalance() public view returns(uint) {
        return currency_.balanceOf(msg.sender);
    }

    // Get tocken balance.
    function getTokenBalance() public view returns(uint) {
        return balanceOf(msg.sender);
    }
}