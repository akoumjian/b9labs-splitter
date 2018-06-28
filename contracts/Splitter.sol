pragma solidity ^0.4.23;

/*
A project contract for B9Lab's Ethereum Developer course
*/
contract Splitter {
    mapping (address => uint) public availableBalances;

    event Split(
        address indexed from,
        address indexed recipient1,
        address indexed recipient2,
        uint256 value
    );

    event Withdrawal(address indexed who, uint value);

    // Alice can send funds to this contract
    // and it will be split to bob & carol
    function split(address person1, address person2) public payable {
        // Prevent user from burning their ether
        require(person1 != 0);
        require(person2 != 0);

        // If amount is not divisible by two
        // keep remainder for sender
        uint remainder = msg.value % 2;
        if (remainder > 0) {
            availableBalances[msg.sender] += remainder;
        }
        uint half = (msg.value - remainder) / 2;

        emit Split(msg.sender, person1, person2, msg.value);
        availableBalances[person1] += half;
        availableBalances[person2] += half;
    }

    function withdraw() public {
        uint amount = availableBalances[msg.sender];
        availableBalances[msg.sender] = 0;
        emit Withdrawal(msg.sender, amount);
        msg.sender.transfer(amount);
    }

    function () public {
        revert();
    }
}
