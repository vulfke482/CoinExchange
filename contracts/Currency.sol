pragma solidity ^0.5.2;

import {ERC20, SafeMath} from 'openzeppelin-solidity/contracts/token/ERC20/ERC20.sol';
/*
*  TODO: change currency to etherium
*  Now it is a little bit a mess
*/

contract Currency is ERC20 {
    using SafeMath for uint;

    string _name;
    uint8 _decimals;
    address _owner;
    address _wallet;

    constructor(
        string memory name,
        uint8 decimals,
        uint totalSupply
    )
        public
    {
        _decimals = decimals;
        _name = name;
        _owner = msg.sender;
        _wallet = _owner;
        _mint(_wallet, totalSupply);
    }

    // Get currency's wallet
    function getWallet() public returns(address) {
        return _wallet;
    }

    // Make two accounts able to communicate.
    function connectTwoAccounts(address account1, address account2, uint amount) public returns(bool) {
        _approve(account1, account2, amount);
        _approve(account2, account1, amount);
        _approve(account1, msg.sender, amount);
        _approve(account2, msg.sender, amount);
    }
}