pragma solidity ^0.5.0;

import {SafeMath} from "./SafeMath.sol";
import {ERC20Token} from "./Token.sol";

contract Project is ERC20Token {
    using SafeMath for uint;

    string name_;
    string description_;
    uint price_;
    address owner_;
    address intermediary_;
    ERC20Token currency_;

    constructor(
        string memory name,
        uint price,
        string memory description,
        uint8 decimals,
        uint128 totalSupply
    )
        ERC20Token(decimals, totalSupply)
        public
    {
        name_ = name;
        price_ = price;
        description_ = description;
        owner_ = msg.sender;
    }

    // Modifiers

    modifier onlyBy(address _account)
    {
        require(
            msg.sender == _account,
            "Sender not authorized. Project"
        );
        // Do not forget the "_;"! It will
        // be replaced by the actual function
        // body when the modifier is used.
        _;
    }

    modifier onlyByV(address _account, string memory message)
    {

        require(
            msg.sender == _account,
            message
        );
        // Do not forget the "_;"! It will
        // be replaced by the actual function
        // body when the modifier is used.
        _;
    }

    // Public functions

    // Set price - avaliable only for intermediary
    function setPrice(uint price) public onlyBy(intermediary_) returns(bool success) {
        price_ = price;
        return true;
    }

    // Set intermediary - avaliable only for owner.
    function setIntermediary(address intermediary) public onlyBy(owner_) returns(bool success) {
        intermediary_ = intermediary;
        approve(intermediary_, totalSupply_);
        return true;
    }

    // Set currency - avaliable only for owner
    function setCurrency(ERC20Token currency) public onlyBy(owner_) returns(bool success) {
        currency_ = currency;
        return true;
    }

    // Buy token - avaliable only for intermediary (for now).
    function buyToken(uint amount) public onlyByV(intermediary_, "Problem in buyToken: wrong account.") returns(bool success) {
        transferFrom(owner_, intermediary_, amount);   // is not safe
        currency_.transfer(owner_, amount.mul(price_));
        return true;
    }

    // Sell token - avaliable only for intermediary (for now).
    function sellToken(uint amount) public onlyBy(intermediary_) returns(bool success) {
        transfer(owner_, amount);
        currency_.transferFrom(owner_, intermediary_, amount.mul(price_)); // is not safe
        return true;
    }

    // Get intermediary.
    function getIntermediary() public view returns(address) {
        return intermediary_;
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

    // Get project's description
    function getDescription() public view returns(string memory) {
        return description_;
    }
}