//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract Faucet {

    address owner;
    mapping(address => uint) timeouts;
    uint totalLeaks;
    uint donations;

    event Withdrawal(address indexed to);
    event Deposited(address indexed from, uint amount);

    constructor() payable {
        owner = msg.sender;
    }

    function withdraw() external {
        require(address(this).balance > 0.025 ether, "This fauce is empty please come back later");
        require(timeouts[msg.sender] <= block.timestamp - 24 hours, "You can only withdraw funds every 24 hours please come back later");

        payable(msg.sender).transfer(0.025 ether);
        timeouts[msg.sender] = block.timestamp;

        totalLeaks+=1;
        emit Withdrawal(msg.sender);
    }

    function getLeaks() public view returns(uint) {
        return totalLeaks;
    }

    function getTimestamp() public view returns(uint) {
        return block.timestamp - timeouts[msg.sender];
    }

    receive() payable external {
        emit Deposited(msg.sender, msg.value);
    }

    fallback() external payable {
        donations+=1;
    }

    function destroy() public {
        require(msg.sender == owner, "only the owner of the smart contract can destory the contract");
        selfdestruct(payable(msg.sender));
    }

}