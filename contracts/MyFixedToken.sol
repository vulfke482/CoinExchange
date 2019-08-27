pragma solidity ^0.5.0;

import {ERC20Token} from "./Token.sol";
import {SafeMath} from "./SafeMath.sol";

contract MyFixedSupplyToken is ERC20Token {

    string public symbol;

    string public  name;

    address public owner;


    constructor() public {

        owner = msg.sender;

        symbol = "FIXED";

        name = "Example Fixed Supply Token";

        decimals = 18;

        _totalSupply = 1000000 * 10**uint(decimals);

        balances[owner] = _totalSupply;

        emit Transfer(address(0), owner, _totalSupply);

    }

}
