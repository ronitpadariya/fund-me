// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";

contract FundMe {

    using PriceConverter for uint256;

    // Could we make this constant?  /* hint: no! We should make it immutable! */
    address public /* immutable */ i_owner;
    uint256 public minimumUsd = 5e18;

    mapping(address => uint256) public addressToAmountFunded;
    address[] public funders;

    constructor(){
        i_owner = msg.sender;
    }

    function fund() public payable {
        
        require(msg.value.getConversionRate() >= minimumUsd, "Didn't send enough ETH");  // 1e18 = 1 ETH = 1000000000000000000
        
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;

    }

    function getVersion() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        return priceFeed.version();
    }

    modifier onlyOwner() {
        require(msg.sender == i_owner, "Sender is not owner");
        // if (msg.sender != i_owner) revert NotOwner();
        _;
    }

    function withdraw() public onlyOwner {
        require(msg.sender == i_owner, "Must be owner!");
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }

        // reset array
        funders = new address[](0);

        // transfer
        // (bool success, ) = payable(msg.sender).transfer(address(this).balance);
        // (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
        // require(success, "Transfer failed");

        // send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // (bool sendSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        // require(sendSuccess, "Send failed");
        
        // call
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }

    

}