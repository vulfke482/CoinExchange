pragma solidity ^0.5.2;

import {ERC20, SafeMath} from 'openzeppelin-solidity/contracts/token/ERC20/ERC20.sol';
import {Currency} from './Currency.sol';


contract Project is ERC20 {
    using SafeMath for uint;

    string _name;
    string _description;
    address _owner;
    address _intermediary;
    uint8 _decimals;
    Currency _currency;

    address _wallet;

    constructor(
        string memory name,
        string memory description,
        uint8 decimals,
        uint totalSupply
    )
        public
    {
        _name = name;
        _decimals = decimals;
        _description = description;
        _owner = msg.sender;
        _wallet = address(this);
        _mint(_wallet, totalSupply);
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

    // Make two accounts able to communicate with each other.
    function connectTwoAccounts(address account1, address account2, uint amount) public onlyBy(_intermediary) returns(bool) {
        _approve(account1, account2, amount);
        _approve(account2, account1, amount);
        _approve(account1, msg.sender, amount);
        _approve(account2, msg.sender, amount);
    }

    // Set intermediary - avaliable only for owner.
    function setIntermediary(address payable intermediary) public onlyBy(_owner) returns(bool success) {
        _intermediary = intermediary;
        return true;
    }

    // Set currency - avaliable only for owner.
    function setCurrency(Currency currency) public onlyBy(_owner) returns(bool success) {
        _currency = currency;
        return true;
    }

    // Get intermediary.
    function getIntermediary() public view returns(address) {
        return _intermediary;
    }

    // Get project's name.
    function getName() public view returns(string memory) {
        return _name;
    }

    // Get project's owner.
    function getOwner() public view returns(address owner) {
        return _owner;
    }

    // Get project's wallet
    function getWallet() public view returns(address wallet) {
        return _wallet;
    }

    // Get tocken balance.
    function getTokenBalance() public view returns(uint) {
        return balanceOf(msg.sender);
    }

    // Get project's description
    function getDescription() public view returns(string memory) {
        return _description;
    }

    // Approving from to
    function approveFrom(address from, address to, uint amount) public onlyBy(_intermediary) returns(bool) {
        _approve(from, to, amount);
        return true;
    }
}