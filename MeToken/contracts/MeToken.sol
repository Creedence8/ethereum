pragma solidity ^0.4.15;

contract Ownable {
    
    address owner;
    
    function Ownable() {
        owner = msg.sender;
    }
 
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
 
    function transferOwnership(address newOwner) onlyOwner {
        owner = newOwner;
    }
    
}

contract MeToken is Ownable{
    
    string public constant name= "MeToken";
    string public constant symbol = "MTN";
    uint8 public constant decimals=18;
    
    uint public totalSupply = 0;
    
    mapping (address => uint) balances;
    
    mapping (address => mapping (address => uint)) allowed;

    
    function  balanceOf(address _owner) public constant returns (uint) {
        return balances[_owner];
    }
    
    function transfer(address _to, uint _value) returns (bool) {
        if (balances[msg.sender]>=_value && balances[_to] + _value >= balances[_to]) {
            balances[msg.sender]-=_value;
            balances[_to]+=_value;
            Transfer(msg.sender, _to, _value);
            return true;    
        }
        return false;
    } 
    
    function transerFrom(address _from, address _to, uint _value) returns (bool) {
        if( allowed[_from][msg.sender] >= _value &&
            balances[_from] >= _value 
            && balances[_to] + _value >= balances[_to]) {
            allowed[_from][msg.sender] -= _value;
            balances[_from] -= _value; 
            balances[_to] += _value;
            Transfer(_from, _to, _value);
            return true;
        } 
        return false;
    }
    
    function approve (address _spender, uint _value) returns (bool) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }
    
    function allowance (address _owner, address _spender) constant returns (uint remaining) {
        return allowed[_owner][_spender];
    }
    
    function mint (address _to, uint _value) onlyOwner {
        assert (totalSupply + _value >= totalSupply && balances[_to] + _value >= balances[_to]);
        balances[_to]+=_value;
        totalSupply += _value;
    }
    
    function MeToken(){
    }
    
    event Transfer(address indexed _from, address indexed _to, uint _value);
    
    event Approval(address indexed _owner, address indexed _spender, uint _value);
}
