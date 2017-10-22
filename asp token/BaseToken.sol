import "./ERC20.sol";
import "./Owned.sol";
import "./SafeMath.sol";

pragma solidity ^0.4.18;

contract BaseToken is ERC20, Owned {
    using SafeMath for uint256;

	string public name; 
	string public symbol; 
	uint256 public decimals;  
    uint256 public initialTokens; 
	uint256 public totalSupply; 
	string public version;

    mapping (address => uint256) balance;
    mapping (address => mapping (address => uint256)) allowed;

	function BaseToken(string tokenName, string tokenSymbol, uint8 decimalUnits, uint256 initialAmount, string tokenVersion) {
		name = tokenName; 
		symbol = tokenSymbol; 
		decimals = decimalUnits; 
        initialTokens = initialAmount; 
		version = tokenVersion;
	}
	
	//Provides the remaining balance of approved tokens from function approve 
    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
      return allowed[_owner][_spender];
    }

	//Allows for a certain amount of tokens to be spent on behalf of the account owner
    function approve(address _spender, uint256 _value) returns (bool success) { 
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

	//Returns the account balance 
    function balanceOf(address _owner) constant returns (uint256 remainingBalance) {
        return balance[_owner];
    }

	//Sends tokens from sender's account
    function transfer(address _to, uint256 _value) returns (bool success) {
        if ((balance[msg.sender] >= _value) && (balance[_to] + _value > balance[_to])) {
            balance[msg.sender] -= _value;
            balance[_to] += _value;
            Transfer(msg.sender, _to, _value);
            return true;
        } else { 
			return false; 
		}
    }
	
	//Transfers tokens from an approved account 
    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
        if ((balance[_from] >= _value) && (allowed[_from][msg.sender] >= _value) && (balance[_to] + _value > balance[_to])) {
            balance[_to] += _value;
            balance[_from] -= _value;
            allowed[_from][msg.sender] -= _value;
            Transfer(_from, _to, _value);
            return true;
        } else { 
			return false; 
		}
    }
    
}