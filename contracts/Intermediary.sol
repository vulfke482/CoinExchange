pragma solidity ^0.5.2;

import {Project, ERC20, SafeMath} from "./Project.sol";
import {Currency} from "./Currency.sol";


contract Intermediary {
    using SafeMath for uint;

    // List of projects
    Project[] projects;

    // Intermediary's address
    address _intermediary;

    // Intermediary's name
    string _name;

    // Currency
    Currency _currency;

    // Wallet
    address _wallet;

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
        _wallet = msg.sender;
    }

    // Public functions

    // Get wallet.
    function getWallet() public view returns(address) {
        return _wallet;
    }

    // Set currency
    function setCurrency(Currency currency) public onlyBy(_intermediary) returns(bool) {
        _currency = currency;
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

        _currency.connectTwoAccounts(getWallet(), project.getWallet(), amount.mul(_price(project)));
        project.connectTwoAccounts(getWallet(), project.getWallet(), amount);

        project.transferFrom(project.getWallet(), getWallet(), amount);
        _currency.transferFrom(getWallet(), project.getWallet(), amount.mul(_price(project)));

        return false;
    }

    // Sell project token - avaliable only for intermediary
    function sellProjectTokenInter(string memory projectName, uint amount) public onlyBy(_intermediary) returns(bool success) {

        (uint id, bool err) = findProjectIdByName(projectName);
        if(err) return false;

        Project project = projects[id];

        require(project.balanceOf(_intermediary) >= amount, "You have not enogh project token.");


        _currency.connectTwoAccounts(getWallet(), project.getWallet(), amount.mul(_price(project)));
        project.connectTwoAccounts(getWallet(), project.getWallet(), amount);

        project.transferFrom(getWallet(), project.getWallet(), amount);
        _currency.transferFrom(project.getWallet(), getWallet(), amount.mul(_price(project)));

        return false;
    }

    // Buy project token
    function buyProjectToken(string memory projectName, uint amount) public returns(bool success) {
        (uint id, bool err) = findProjectIdByName(projectName);
        if(err) return false;

        Project project = projects[id];

        _currency.connectTwoAccounts(_intermediary, msg.sender, amount.mul(_price(project)));
        project.connectTwoAccounts(_intermediary, msg.sender, amount);

        project.transferFrom(_intermediary, msg.sender, amount);
        _currency.transferFrom(msg.sender, _intermediary, amount.mul(_price(project)));

        return true;
    }

    // Sell project token
    function sellProjectToken(string memory projectName, uint amount) public returns(bool success) {
        (uint id, bool err) = findProjectIdByName(projectName);
        if(err) return false;

        Project project = projects[id];

        _currency.connectTwoAccounts(_intermediary, msg.sender, amount.mul(_price(project)));
        project.connectTwoAccounts(_intermediary, msg.sender, amount);

        project.transferFrom(msg.sender, getWallet(), amount);
        _currency.transferFrom(getWallet(), msg.sender, amount.mul(_price(project)));
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
    function getBalanceForProject(string memory projectName) public view returns(uint balance) {
        (uint id, bool err) = findProjectIdByName(projectName);
        if(err) return 0;

        Project project = projects[id];
        return project.balanceOf(msg.sender);
    }

    // Get currency balance
    function getBalanceForCurrency() public view returns(uint balance) {
        return _currency.balanceOf(msg.sender);
    }

    // Get project price
    function getProjectPrice(string memory projectName) public view returns(uint) {
        (uint id, bool err) = findProjectIdByName(projectName);
        require(!err, "There is no such project in our database");

        return _price(projects[id]);
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

    // Get price for project
    function _price(Project project) internal view returns(uint) {

        // uint price =project.totalSupply().div(project.balanceOf(address(this)));
        uint price = 2;
        return price;
    }
}