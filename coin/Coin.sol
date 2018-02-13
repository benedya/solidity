pragma solidity ^0.4.0;

contract Coin {

    address owner;
    int8 counter;
    mapping (address => uint) public balances;

    function Coin()
    {
        owner = msg.sender;
        counter = 125;
    }

    event Sent(address from, address to, uint amount);

    function mint(address receiver , uint amount) public {
        if (msg.sender != owner) {
            return;
        }
        balances[receiver] = amount;
    }

    function send(address receiver , uint amount) public {
        if (balances[msg.sender] < amount) {
            return;
        }
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        Sent(msg.sender, receiver, amount);
    }

    function getBalance(address key) public returns(uint) {
        return balances[key];
    }


    function getOwner()  onlyOwner() public returns (address) {
        counter++;
        return owner;
    }

    modifier onlyOwner() {
        if (msg.sender != owner) {
            throw;
        }
        _;
    }
}
