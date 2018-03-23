pragma solidity ^0.4.16;

contract owned{
  address public owner;

  function owned(){
    owner = msg.sender;
  }

  modifier onlyOwner{
    require(msg.sender == owner);
    _;
  }

  function transferOwnership(address newOwner) onlyOwner{
    owner = newOwner;
  }
}

contract Cr0wsToken is owned {

  string public name;
  string public symbol;
  uint8 public decimals = 18;
  uint256 public totalSupply;

  event Transfer(address indexed from, address indexed to, uint256 value);
  event FrozenFunds(address target, bool frozen);

  mapping (address => bool) public frozenAccount;
  mapping (address => uint256) public balanceOf;

  function Cr0wsToken(uint256 initialSupply, string tokenName, string tokenSymbol, uint8 decimalUnits, address centralMinter){
    totalSupply = initialSupply * 10 ** uint256(decimals);
    if(centralMinter != 0) owner = centralMinter;
    balanceOf[msg.sender] = totalSupply;
    name = tokenName;
    symbol = tokenSymbol;
    decimals = decimalUnits;
  }

  function transfer(address _to, uint256 _value){
    require(balanceOf[msg.sender] >= _value && balanceOf[_to] + _value >= balanceOf[_to]);
    require(!frozenAccount[msg.sender]);
    balanceOf[msg.sender] -= _value;
    balanceOf[_to] += _value;
    Transfer(msg.sender, _to, _value);
  }

  function _transfer(address _from, address _to, uint _value) internal{
    require(_to != 0x0);
    require(balanceOf[_from] >= _value);
    require (balanceOf[_to] + _value > balanceOf[_to]);
    require(!frozenAccount[_from]);
    require(!frozenAccount[_to]);
    balanceOf[_from] -= _value;
    balanceOf[_to] += _value;
    Transfer(_from, _to, _value);
  }

  function mintToken(address target, uint256 mintedAmount) onlyOwner {
    balanceOf[target] += mintedAmount;
    totalSupply += mintedAmount;
    Transfer(0, owner, mintedAmount);
    Transfer(owner, target, mintedAmount);
  }

  function freezeAccount(address target, bool freeze) onlyOwner{
    frozenAccount[target] = freeze;
    FrozenFunds(target, freeze);
  }
}


https://ethereum.stackexchange.com/questions/18058/how-to-implement-role-based-access-control-to-users-private-data
