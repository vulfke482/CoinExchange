pragma solidity ^0.5.0;

import {SafeMath} from "./SafeMath.sol";
import {ERC20Token} from "./Token.sol";
import {Project} from "./Project.sol";



contract Intermediary {
    using SafeMath for uint;

    // List of projects
    Project[] projects;

    // Currency token
    ERC20Token _currency;

    // Intermediary's address
    address _intermediary;

    // Intermediary's name
    string _name;

    // Modificators

    modifier onlyBy(address _account)
    {
        require(
            msg.sender == _account,
            "Sender not authorized. Intermediary."
        );
        // Do not forget the "_;"! It will
        // be replaced by the actual function
        // body when the modifier is used.
        _;
    }

    // Methods

    constructor(string memory name) public {
        _name = name;
        _intermediary = msg.sender;
    }

    // Public functions

    // Set currency
    function setCurrency(ERC20Token currency) public onlyBy(_intermediary) returns(bool success) {
        _currency = currency;
        return true;
    }

    // Set project price
    function setProjectPrice(string memory projectName, uint projectPrice) public onlyBy(_intermediary) returns(bool success) {
        (uint id, bool err) = findProjectIdByName(projectName);
        if(err) return false;
        setProjectPrice(projects[id], projectPrice);
        return true;
    }


    // Register new Project
    function registerNewProject(Project project) public onlyBy(_intermediary) returns(bool success) {
        (uint id, bool err) = findProjectIdByName(project.getName());
        if(!err) return false;

        projects.push(project);
        return true;
    }

    // By project token - avaliable only for intermediary
    function buyProjectTokenInter(string memory projectName, uint amount) public onlyBy(_intermediary) returns(bool success) {

        (uint id, bool err) = findProjectIdByName(projectName);
        if(err) return false;

        Project project = projects[id];
        if(project.buyToken(amount)) {
            return true;
        }

        return false;
    }

    // Sell project token - avaliable only for intermediary
    function sellProjectTokenInter(string memory projectName, uint amount) public onlyBy(_intermediary) returns(bool success) {

        (uint id, bool err) = findProjectIdByName(projectName);
        if(err) return false;

        Project project = projects[id];

        require(project.balanceOf(_intermediary) < amount, "You have not enogh project token.");

        if(project.sellToken(amount)) {
            return true;
        }

        return false;
    }

    // Buy project token
    function buyProjectToken(string memory projectName, uint amount) public onlyBy(_intermediary) returns(bool success) {
        return false;
    }

    // Sell project token
    function sellProjectToken(string memory projectName, uint amount) public onlyBy(_intermediary) returns(bool success) {
        return false;
    }

    // Set a new price for project
    function setProjectPrice(Project project, uint projectPrice) public onlyBy(_intermediary) returns(bool success) {
        project.setPrice(projectPrice);
        return true;
    }

    // Get intermediary address
    function getIntermediary() public view returns(address) {
        return _intermediary;
    }

    // Get name of the intermediary
    function getName() public view returns(string memory){
        return _name;
    }

    // Get balance for project
    function getBalanceForProject(string memory projectName) public onlyBy(_intermediary) view returns(uint balance) {
        (uint id, bool err) = findProjectIdByName(projectName);
        if(err) return 0;

        Project project = projects[id];
        return project.balanceOf(_intermediary);
    }

    // Get balance for currency
    function getBalanceForCurrency() public view onlyBy(_intermediary) returns(uint balance) {
        return _currency.balanceOf(_intermediary);
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