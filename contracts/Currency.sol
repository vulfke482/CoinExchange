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

    constructor(
        string memory name,
        uint8 decimals,
        uint totalSupply
    )
        public
    {
        _decimals = decimals;
        _name = name;
        _mint(address(this), totalSupply);
    }
}