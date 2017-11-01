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
    uint softcap;
    uint referencePercent;
    
    mapping(address => uint) public balances;
    
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
        softcap = 500 ether;
        referencePercent = 2;
    }

    function createTokens() isUnderHardCap saleIsOn payable {
        // multisig.transfer(msg.value);
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
        balances[msg.sender] = balances[msg.sender].add(msg.value);
        if(msg.data.length == 20) {
        address referer = bytesToAddres(bytes(msg.data));
        // проверка, чтобы инвестор не начислил бонусы сам себе
        require(referer != msg.sender);
        uint refererTokens = tokens.mul(referencePercent).div(100);
        // начисляем рефереру
        token.transfer(referer, refererTokens);
    }
    }
    
    function finishMinting() public onlyOwner {
        if(this.balance > softcap) {
            multisig.transfer(this.balance);
            uint issuedTokenSupply = token.totalSupply();
            uint restrictedTokens = issuedTokenSupply.mul(restrictedPercent).div(100 - restrictedPercent);
            token.mint(restricted, restrictedTokens);
            token.finishMinting();
      }
    }
    
    function refund() {
      require(this.balance < softcap && now > start + period * 1 days);
      msg.sender.transfer(balances[msg.sender]);
      balances[msg.sender] = 0;
    }
    
    function bytesToAddress(bytes source) internal pure returns(address) {
        uint result;
        uint mul = 1;
        for(uint i = 20; i > 0; i--) {
          result += uint8(source[i-1])*mul;
          mul = mul*256;
        }
        return address(result);
  }
 
    function() external payable {
        createTokens();
    }
    
}
