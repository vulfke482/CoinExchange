pragma solidity ^0.5.0;

import {SafeMath} from "./SafeMath.sol";
import {ERC20Token} from "./Token.sol";

import "@openzeppelin/contracts/token/ERC20/ERC20Full.sol";

contract Project is ERC20Token {
    using SafeMath for uint;

    string _name;
    string _description;
    uint _price;
    address _owner;
    address _intermediary;
    ERC20Token _currency;

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
        _name = name;
        _price = price;
        _description = description;
        _owner = msg.sender;
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
    function setPrice(uint price) public onlyBy(_intermediary) returns(bool success) {
        _price = price;
        return true;
    }

    // Set intermediary - avaliable only for owner.
    function setIntermediary(address intermediary) public onlyBy(_owner) returns(bool success) {
        _intermediary = intermediary;
        approve(_intermediary, totalSupply_);
        return true;
    }

    // Set currency - avaliable only for owner
    function setCurrency(ERC20Token currency) public onlyBy(_owner) returns(bool success) {
        _currency = currency;
        return true;
    }

    // Buy token - avaliable only for intermediary (for now).
    function buyToken(uint amount) public onlyByV(_intermediary, "Problem in buyToken: wrong account.") returns(bool success) {
        transferFrom(_owner, _intermediary, amount);   // is not safe
        _currency.transfer(_owner, amount.mul(_price));
        return true;
    }

    // Sell token - avaliable only for intermediary (for now).
    function sellToken(uint amount) public onlyBy(_intermediary) returns(bool success) {
        transfer(_owner, amount);
        _currency.transferFrom(_owner, _intermediary, amount.mul(_price)); // is not safe
        return true;
    }

    // Get intermediary.
    function getIntermediary() public view returns(address) {
        return _intermediary;
    }

    // Get price.
    function getPrice() public view returns(uint) {
        return _price;
    }

    // Get project's name.
    function getName() public view returns(string memory) {
        return _name;
    }

    // Get project's owner.
    function getOwner() public view returns(address owner) {
        return _owner;
    }

    // Get currency balance.
    function getCurrencyBalance() public view returns(uint) {
        return _currency.balanceOf(msg.sender);
    }

    // Get tocken balance.
    function getTokenBalance() public view returns(uint) {
        return balanceOf(msg.sender);
    }

    // Get project's description
    function getDescription() public view returns(string memory) {
        return _description;
    }
}