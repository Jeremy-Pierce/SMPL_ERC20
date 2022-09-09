pragma solidity ^0.5.0;

//-----------------------------------
// ERC Token Standard #20 Interface
// Contract iteration by Jeffrey J. Wiley Jr.
//-----------------------------------

contract ERC20Interface{
    function totalSupply() public view returns (uint);
    function balanceOf(address tokenOwner) public view returns(uint balance);
    function allowance(address towkenOwner, address spender) public view returns(uint remaining);
    function transfer(address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);
//----------------------------------------------------------------------------------------------
    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

//----------------------------------------------------------------------------------------------
// SafeMath Modifier 
//----------------------------------------------------------------------------------------------

contract SafeMath{
    function safeAdd(uint a, uint b) public pure returns (uint c) {
        c = a + b;
        require (c >= a, "Error cannot proceed.");
    }

    function safeSub(uint a, uint b) public pure returns (uint c) {
        c = a - b;
        require(b <= a, "Error cannot proceed."); 
    }

    function safeMul(uint a, uint b) public pure returns(uint c) {
        c = a * b;
        require(a == 0 || c / a ==b, "Error cannot proceed.");
    }

    function safeDiv(uint a, uint b) public pure returns (uint c){
        c = a / b;
        require(b >0, "Error cannot proceed");
    }
}

contract Hermcoin is ERC20Interface, SafeMath{
    string public name;
    string public symbol;
    uint8 decimals; //18 decimals is the standard number assigment. Alternatives are discouraged. 

    uint256 public _totalSupply;

    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;

    constructor() public {

        name = "SimpleCoin";
        symbol = "SMPL";
        decimals = 18;
        _totalSupply = 100000000000000000000000000;

        balances[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    function totalSupply() public view returns (uint) {
        return _totalSupply - balances[address(0)];
    }


    function balanceOf(address tokenOwner, address spender) public view returns (uint balance){
        return allowed[tokenOwner][spender];
    }

    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }

    function approve(address spender, uint tokens) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }    

    function transfer(address to, uint tokens) public returns (bool success) {
        balances[msg.sender] = safeSub(balances[msg.sender], tokens);
        balances[to] = safeAdd(balances[to], tokens);
        emit Transfer(msg.sender, to, tokens);
        return true;
    }

    function transferFrom(address from, address to, uint tokens) public returns (bool success) {
        balances[from] = safeSub(balances[from], tokens);
        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
        balances[to] = safeAdd(balances[to], tokens);
        emit Transfer(from, to, tokens);
        return true;
    }
}