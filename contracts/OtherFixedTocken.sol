pragma solidity ^0.5.0;

import {ERC20Tocken} from "./Tocken.sol";

contract OtherFixedSupplyTocken is ERC20Tocken {


    constructor() public {

        decimals = 18;

        _totalSupply = 1000000 * 10**uint(decimals);
        
        balances[msg.sender] = _totalSupply;
    }

}