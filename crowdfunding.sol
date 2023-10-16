// SPDX-License-Identifier: MIT
pragma solidity 0.7.0;
contract croudFunding{
    struct Campaign{
        address owner;
        string title;
        string discription;
        uint target;
        uint deadline;
        uint amountCollection;
        address[] donar;
        uint[] donation;

    }
    mapping(uint=>Campaign) public campaigns;
    uint public noofCampaigns=0;
    function createCampaign (address _owner,string memory _title,string memory _discription,uint _target,uint _deadline) public returns(uint){
        Campaign memory campaign =campaigns[noofCampaigns];
        require(campaign.deadline<block.timestamp,"campaign expired");
        campaign.owner=_owner;
        campaign.title=_title;
        campaign.discription=_discription;
        campaign.target=_target;
        campaign.deadline=_deadline;

        noofCampaigns++;

        return noofCampaigns-1;

    }
    function donateTocampaign(uint _id)public payable{
        uint amount=msg.value;
        Campaign storage campaign=campaigns[_id];
        bool sent=payable(campaign.owner).send(amount);
        require(sent,"succes failed");
        campaign.amountCollection+=amount;
        campaign.donation.push(amount);
        campaign.donar.push(msg.sender);



    }
    function getdonator(uint _id) public view returns(uint[] memory ,address[] memory  ){
        return (campaigns[_id].donation,campaigns[_id].donar);

    }
}