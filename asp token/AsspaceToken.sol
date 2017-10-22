import "./BaseToken.sol";
import "./Owned.sol";
import "./SafeMath.sol";

pragma solidity ^0.4.18;

contract AsspaceToken is Owned, BaseToken {
    using SafeMath for uint256;

    uint256 public amountRaised; 
    uint256 public deadline; 
    uint256 public price;        
    uint256 public maxPreIcoAmount = 8000000;  
	bool preIco = true;
    
	function AsspaceToken() 
		BaseToken("ASSPACE Token", "ASP", 0, 100000000000, "1.0") {
            balance[msg.sender] = initialTokens;    
            setPrice(2500000);
            deadline = now - 1 days;
    }

    function () payable {
        require((now < deadline) && 
                 (msg.value.div(1 finney) >= 100) &&
                ((preIco && amountRaised.add(msg.value.div(1 finney)) <= maxPreIcoAmount) || !preIco)); 

        address recipient = msg.sender; 
        amountRaised = amountRaised.add(msg.value.div(1 finney)); 
        uint256 tokens = msg.value.mul(price).div(1 ether);
        totalSupply = totalSupply.add(tokens);
        balance[recipient] = balance[recipient].add(tokens);
		balance[owner] = balance[owner].sub(tokens);
		
        require(owner.send(msg.value)); 
		
        Transfer(0, recipient, tokens);
    }   

    function setPrice(uint256 newPriceper) onlyOwner {
        require(newPriceper > 0); 
        
        price = newPriceper; 
    }
			
    function startSale(uint256 lengthOfSale, bool isPreIco) onlyOwner {
        require(lengthOfSale > 0); 
        
        preIco = isPreIco;
        deadline = now + lengthOfSale * 1 days; 
    }

    function stopSale() onlyOwner {
        deadline = now;
    }
    
}