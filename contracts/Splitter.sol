pragma solidity ^0.4.23;

/*
A project contract for B9Lab's Ethereum Developer course
*/
contract Splitter {
    mapping (address => address[2]) public splits;
    mapping (address => uint) public availableBalances;

    event SplitCreated(
        address indexed from,
        address indexed recipient1,
        address indexed recipient2
    );

    event Deposit(
        address indexed from,
        address indexed recipient1,
        address indexed recipient2,
        uint256 value
    );

    event Withdrawal(address indexed who, uint value);

    // Set up the recipients of a split from a sender
    function setSplit(address _address1, address _address2) public {
        emit SplitCreated(msg.sender, _address1, _address2);
        splits[msg.sender] = [_address1, _address2];
    }

    // Alice can send funds to this contract
    // and it will be split to bob & carol
    function () public payable {
        address[2] memory senderSplit = splits[msg.sender];
        // Prevent user from burning their ether
        require(senderSplit[0] != 0);
        require(senderSplit[1] != 0);

        // If amount is not divisible by two
        // keep remainder for sender
        uint remainder = msg.value % 2;
        if (remainder > 0) {
            availableBalances[msg.sender] += remainder;
        }
        uint half = (msg.value - remainder) / 2;

        emit Deposit(msg.sender, senderSplit[0], senderSplit[1], msg.value);
        availableBalances[senderSplit[0]] += half;
        availableBalances[senderSplit[1]] += half;
    }

    function withdraw() public {
        uint amount = availableBalances[msg.sender];
        availableBalances[msg.sender] = 0;
        emit Withdrawal(msg.sender, amount);
        msg.sender.transfer(amount);
    }
}
