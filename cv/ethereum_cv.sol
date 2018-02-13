pragma solidity ^0.4.0;

import "./structures.sol";

contract EthereumCV {
    address owner;
    mapping (string => string) basic_data;

    Structures.Project[] public projects;
    Structures.Education[] public educations;
    Structures.Skill[] public skills;
    Structures.Publication[] public publications;

    // =====================
    // ==== CONSTRUCTOR ====
    // =====================
    function EthereumCV() {
        owner = msg.sender;
    }

    function getBasicData (string arg) constant returns (string) {
      return basic_data[arg];
    }

    modifier onlyOwner() {
        if (msg.sender != owner) { throw; }
        _; // Will be replaced with function body
    }

    // Now you can use it with any function
    function setBasicData (string key, string value) onlyOwner() {
        basic_data[key] = value;
    }

    function editPublication (bool operation, string name, string link, string language) onlyOwner() {
        if (operation) {
            publications.push(Structures.Publication(name, link, language));
        } else {
            delete publications[publications.length - 1];
        }
    }

    function getSize(string arg) constant returns (uint) {
        if (sha3(arg) == sha3("projects")) { return projects.length; }
        if (sha3(arg) == sha3("educations")) { return educations.length; }
        if (sha3(arg) == sha3("publications")) { return quotes.length; }
        if (sha3(arg) == sha3("skills")) { return skills.length; }
        throw;
    }
}
