pragma solidity ^0.4.23;

/*
A project contract for B9Lab's Ethereum Developer course
*/
contract Splitter {
    address alice;
    address bob;
    address carol;
    mapping (address => uint) availableBalances;

    event Split(uint256 _value);

    event Withdrawal(address indexed _who, uint _value);

    constructor(address _alice, address _bob, address _carol) public {
        alice = _alice;
        bob = _bob;
        carol = _carol;
    }

    function getBalances() public view returns(address, uint, address, uint, address, uint) {
        return (
            alice,
            availableBalances[alice],
            bob,
            availableBalances[bob],
            carol,
            availableBalances[carol]
        );
    }

    // Alice can send funds to this contract
    // and it will be split to bob & carol
    function () public payable {
        require(msg.sender == alice);
        // If amount is odd save 1 wei for alice
        if ((msg.value % 2) == 1) {
            availableBalances[alice] += 1;
        }
        uint half = msg.value / 2;
        availableBalances[bob] += half;
        availableBalances[carol] += half;
        emit Split(msg.value);
    }

    function withdraw() public {
        uint amount = availableBalances[msg.sender];
        availableBalances[msg.sender] = 0;
        msg.sender.transfer(amount);
        emit Withdrawal(msg.sender, amount);
    }
}
