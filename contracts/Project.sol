pragma solidity ^0.5.2;

import {ERC20, SafeMath} from 'openzeppelin-solidity/contracts/token/ERC20/ERC20.sol';
import {Currency} from './Currency.sol';
/*
*  TODO: change currency to etherium
*  Now it is a little bit a mess
*/

contract Project is ERC20 {
    using SafeMath for uint;

    string _name;
    string _description;
    uint _price;
    address payable _owner;
    address payable _intermediary;
    uint8 _decimals;
    Currency _currency;

    address payable _wallet;

    constructor(
        string memory name,
        uint price,
        string memory description,
        uint8 decimals,
        uint totalSupply
    )
        public
    {
        _decimals = decimals;
        _name = name;
        _price = price;
        _description = description;
        _owner = msg.sender;
        _mint(address(this), totalSupply);
        _wallet = address(this);
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
    function setIntermediary(address payable intermediary) public onlyBy(_owner) returns(bool success) {
        _intermediary = intermediary;
        increaseAllowance(_intermediary, totalSupply());
        // _approve(address(this), _intermediary, totalSupply());
        return true;
    }

    function connectProjectWithIntermediary(address project, address intermediary, uint amount) public onlyBy(_intermediary) returns(bool) {
        _approve(project, intermediary, amount);
        _approve(intermediary, project, amount);
        _approve(project, msg.sender, amount);
        _approve(intermediary, msg.sender, amount);
        _approve(msg.sender, project, amount);
        _approve(msg.sender, intermediary, amount);
    }

    // Set currency - avaliable only for owner.
    function setCurrency(Currency currency) public onlyBy(_owner) returns(bool success) {
        _currency = currency;
        _currency.increaseAllowance(_intermediary, currency.totalSupply());
        // _approve(address(this), _intermediary, totalSupply());
        return true;
    }

    // transfer ether from address(this)
    function _transferEther(address payable account, uint amount) internal returns(bool) {
        account.transfer(amount);
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

    function () external payable  {
        _wallet.transfer(msg.value);
    }
}