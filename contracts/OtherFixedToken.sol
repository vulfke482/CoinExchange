pragma solidity ^0.5.0;

import {ERC20Token} from "./Token.sol";

contract OtherFixedSupplyToken is ERC20Token {


    constructor() public {

        decimals = 18;

        _totalSupply = 1000000 * 10**uint(decimals);
        
        balances[msg.sender] = _totalSupply;
    }

}