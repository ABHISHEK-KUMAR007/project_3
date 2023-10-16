// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0;
contract lottery{
    address public manager;
    address  payable[] public  people;
    address  payable  public winner;

    constructor(){
        manager=msg.sender;

    }
    function participate()public payable{
        require(msg.value==1 ether,"pay 1 ether");
        people.push(payable(msg.sender));

    }
    function getbalance() public view returns(uint){
        require(manager==msg.sender,"you are not manager");
        return address(this).balance;
    }
    function random() internal view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,people.length)));
    }
    function pickWinner() public {
        require(manager==msg.sender);
        uint index=random()%people.length;
        winner=people[index];
        winner.transfer(getbalance());
        people=new address payable[](0);

    }

}
