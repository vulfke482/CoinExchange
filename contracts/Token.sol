pragma solidity ^0.5.0;

import {SafeMath} from "./SafeMath.sol";


contract ApproveAndCallFallBack {

    function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;

}

contract ERC20Token {
    using SafeMath for uint;

    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;
    uint8 decimals_;
    uint totalSupply_;

    constructor(uint8 decimals, uint128 totalSupply) public {
        decimals_ = decimals;
        totalSupply_ = totalSupply * 10**uint(decimals_);
    }

    function getDecimals() public view returns(uint8) {
        return decimals_;
    }

    function totalSupply() public view returns (uint) {
        return totalSupply_.sub(balances[address(0)]);
    }

    function balanceOf(address tokenOwner) public view returns (uint balance) {
        return balances[tokenOwner];

    }

    function transfer(address to, uint tokens) public returns (bool success) {

        balances[msg.sender] = balances[msg.sender].sub(tokens);
        balances[to] = balances[to].add(tokens);

        emit Transfer(msg.sender, to, tokens);

        return true;

    }

    function approve(address spender, uint tokens) public returns (bool success) {

        allowed[msg.sender][spender] = tokens;

        emit Approval(msg.sender, spender, tokens);

        return true;

    }

    function transferFrom(address from, address to, uint tokens) public returns (bool success) {

        balances[from] = balances[from].sub(tokens);
        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
        balances[to] = balances[to].add(tokens);

        emit Transfer(from, to, tokens);

        return true;
    }

    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }

    function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;

        emit Approval(msg.sender, spender, tokens);

        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);

        return true;

    }


    event Transfer(address indexed from, address indexed to, uint tokens);

    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);

}