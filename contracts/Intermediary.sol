pragma solidity ^0.5.0;

import {SafeMath} from "./SafeMath.sol";
import {ERC20Token} from "./Token.sol";
import {Project} from "./Project.sol";

contract Intermediary {
    using SafeMath for uint;

    // List of projects
    Project[] projects;

    // Currency token
    ERC20Token currency;

    // Intermediary's address
    address intermediary_;

    // Intermediary's name
    string name_;

    // Methods

    constructor(string memory name) public {
        name_ = name;
        intermediary_ = msg.sender;
    }

    // Public functions

    // Set project price
    function setProjectPrice(string memory projectName, uint projectPrice) public returns(bool success) {
        if(msg.sender != intermediary_) return false;
        (uint id, bool err) = findProjectIdByName(projectName);
        if(err) return false;
        setProjectPrice(projects[id], projectPrice);
        return true;
    }


    // Register new Project
    function registerNewProject(Project project) public returns(bool success) {
        (uint id, bool err) = findProjectIdByName(project.getName());
        if(!err) return false;

        projects.push(project);
        return true;
    }

    // By project token - avaliable only for intermediary
    function buyProjectTocken(string memory projectName, uint amount) public returns(bool success) {
        if(msg.sender != intermediary_) return false;

        (uint id, bool err) = findProjectIdByName(projectName);
        if(err) return false;

        Project project = projects[id];
        if(project.buyToken(amount)) {
            return true;
        }

        return false;
    }

    // Sell project token - avalable only for intermediary
    function sellProjectTocken(string memory projectName, uint amount) public returns(bool success) {
        if(msg.sender != intermediary_) return false;

        (uint id, bool err) = findProjectIdByName(projectName);
        if(err) return false;

        Project project = projects[id];

        require(project.balanceOf(intermediary_) < amount, "You have not enogh project token.");

        if(project.sellToken(amount)) {
            return true;
        }

        return false;
    }

    // Set a new price for project
    function setProjectPrice(Project project, uint projectPrice) public returns(bool success) {
        project.setPrice(projectPrice);
        return true;
    }

    // Get name of the project
    function getName() public view returns(string memory){
        return name_;
    }

        // Get balance for project
    function getBalanceForProject(string memory projectName) public view returns(uint balance) {
        if(msg.sender != intermediary_) return 0;
        (uint id, bool err) = findProjectIdByName(projectName);
        if(err) return 0;

        Project project = projects[id];
        return project.balanceOf(intermediary_);
    }

    // Get balance for currency
    function getBalanceForCurrency() public view returns(uint balance) {
        return currency.balanceOf(intermediary_);
    }

    // Internal functions

    // Checking String for equation
    function equalStrings(string memory firstStr, string memory secondStr) internal pure returns(bool success) {
        bytes memory first = bytes(firstStr);
        bytes memory second = bytes(secondStr);
        if(first.length != second.length) return false;
        for(uint i = 0; i < first.length; i++) {
            if(first[i] != second[i]) return false;
        }
        return true;
    }

    // Find project position in a list by its name
    function findProjectIdByName(string memory projectName) internal view returns(uint, bool success) {
        for(uint i = 0; i < projects.length; i++) {
            if(equalStrings(projects[i].getName(), projectName)) {
                return (i, false);
            }
        }
        return (projects.length, true);
    }
}