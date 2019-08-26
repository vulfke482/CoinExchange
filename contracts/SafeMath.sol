pragma solidity ^0.5.0;

library SafeMath {

    function add(uint a, uint b) internal pure returns (uint c) {

        c = a + b;

        require(c >= a, "There is problem with addition");

    }

    function sub(uint a, uint b) internal pure returns (uint c) {

        require(b <= a, "There is problem with substruction");

        c = a - b;

    }

    function mul(uint a, uint b) internal pure returns (uint c) {

        c = a * b;

        require(a == 0 || c / a == b, "There is problem with multiplication");

    }

    function div(uint a, uint b) internal pure returns (uint c) {

        require(b > 0, "There is problem with dividing by zero");

        c = a / b;

    }

}