pragma solidity ^0.4.17;

contract Splitter {
    address owner;
    mapping (address => uint) public balances;

    event ContractDestroyed(address indexed destroyer);
    event LogSplit(address indexed sender, address indexed firstRecipient, address indexed secondRecipient, uint256 amount);
    event LogWithdrawal(address indexed recipient, uint256 amount);

    modifier onlyowner() {
        require(msg.sender == owner);
        _;
    }

    function Splitter() public {
        owner = msg.sender;
    }

    function split(address _firstRecipient, address _secondRecipient) public payable returns (bool success) {
        require(msg.sender != _firstRecipient && msg.sender != _secondRecipient);
        require(msg.value > 0);

        uint splitAmount = msg.value / 2;
        balances[_firstRecipient] += splitAmount;
        balances[_secondRecipient] += splitAmount; 
        balances[msg.sender] += msg.value % 2;       

        LogSplit(msg.sender, _firstRecipient, _secondRecipient, splitAmount);
        return true;
    }


    function withdraw() public returns (bool success) {
        uint amount = balances[msg.sender];
        require(amount>0);
        balances[msg.sender] = 0;
        LogWithdrawal(msg.sender,amount);
        msg.sender.transfer(amount);
        return true;
    }

    function closeContract() public onlyowner {
        ContractDestroyed(msg.sender);
        selfdestruct(msg.sender);
    }

}