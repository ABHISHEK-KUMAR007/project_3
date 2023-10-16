//SPDX-License-Identifier:MIT
pragma solidity >=0.7.0;
contract MultiSig{
    address[] public owner;
    struct Transaction{
        address to;
        uint val;
        bool executed;
    }
    Transaction[] public transactions;
    mapping(uint=>mapping(address=>bool)) isConfirm;
    uint public noofconfirmationrequired;
    constructor(address[] memory _owner,uint _noofconfirmationrequired){
        require(_noofconfirmationrequired<=_owner.length,"not valid noofconfirmation");
        for(uint i=0;i<_owner.length;i++){
            owner.push(_owner[i]);

        }
        noofconfirmationrequired=_noofconfirmationrequired;

    }
    function submitTnx(address  _to)public payable {
        require(_to!=address(0),"address is not valid");
        require(msg.value>0,"add some ether");

        uint transactionId=transactions.length;

        transactions.push(Transaction({to:_to,val:msg.value,executed:false}));

    }
    function confirmation(uint _transactionId) public{
        require(_transactionId<transactions.length,"invalid id");
        require(isConfirm[_transactionId][msg.sender],"already has been confirmed");
        isConfirm[_transactionId][msg.sender]=true;

       
        if(isconfirmation(_transactionId)){
         executeTransaction(_transactionId);
        }
        
        
       
    }
    function isconfirmation(uint _transactionId) public view returns(bool){
        require(_transactionId<transactions.length,"invalid id");
         uint noofconfirm;
        for(uint i=0;i<owner.length;i++){
            if(isConfirm[_transactionId][owner[i]]){
                noofconfirm++;
                }

        }
        return noofconfirm>=noofconfirmationrequired;
    }
    function executeTransaction(uint _transactionId) public payable{
       require(_transactionId<transactions.length,"invalid id");
       require(!transactions[_transactionId].executed,"alredy has been executed");
        (bool success,)=transactions[_transactionId].to.call{value:transactions[_transactionId].val}("");
        transactions[_transactionId].executed=true;

    }



}