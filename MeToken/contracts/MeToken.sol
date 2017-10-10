pragma solidity ^0.4.13;

import "../zeppelin-solidity/contracts/token/MintableToken.sol";

contract MeToken is MintableToken {

    string public name = "MePhorce Token";
    string public symbol = "MPT";
    uint public decimals = 18;

    function MeToken(uint _amount){
        owner = msg.sender;
        mint(owner, _amount);

    }
}
