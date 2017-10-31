pragma solidity ^0.4.13;

import "./MeToken.sol";

contract Crowdsale is Ownable {
    
    using SafeMath for uint;
    
    MeToken public token = new MeToken();
    
    uint start = 1508500800;
    uint period;
    address multisig;
    uint hardcap;
    uint rate;
    uint restrictedPercent;
    address restricted;
    
    modifier saleIsOn() {
        require(now > start && now < start + period*1 days);
        _;
    }
    
    modifier isUnderHardCap() {
        require(multisig.balance <= hardcap);
        _;
    }
    
    function Crowdsale() {
        multisig = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
        restricted = 0x14723a09acff6d2a60dcdf7aa4aff308fddc160c;
        restrictedPercent = 40;
        period = 28;
        rate = 30 ether;
        hardcap = 10000 ether;
    }

    function createTokens() isUnderHardCap saleIsOn payable {
        multisig.transfer(msg.value);
        uint tokens = rate.mul(msg.value).div(1 ether);
        uint bonusTokens = 0;
        if(now < start + (period * 1 days).div(4)) {
          bonusTokens = tokens.div(4);
        } else if(now >= start + (period * 1 days).div(4) && now < start + (period * 1 days).div(4).mul(2)) {
          bonusTokens = tokens.div(10);
        } else if(now >= start + (period * 1 days).div(4).mul(2) && now < start + (period * 1 days).div(4).mul(3)) {
          bonusTokens = tokens.div(20);
        }
        tokens += bonusTokens;
        token.mint(msg.sender, tokens);
    }
    
    function finishMinting() public onlyOwner {
    	uint issuedTokenSupply = token.totalSupply();
    	uint restrictedTokens = issuedTokenSupply.mul(restrictedPercent).div(100 - restrictedPercent);
    	token.mint(restricted, restrictedTokens);
        token.finishMinting();
    }
 
    function() external payable {
        createTokens();
    }
    
}
