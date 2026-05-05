// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";

contract FundMe {

    using PriceConverter for uint256;

    uint256 public minimumUsd = 5e18;

    mapping(address => uint256) public addressToAmountFunded;
    address[] public funders;

    function fund() public payable {
        
        require(msg.value.getConversionRate() >= minimumUsd, "Didn't send enough ETH");  // 1e18 = 1 ETH = 1000000000000000000
        
        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);

    }

    function getVersion() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        return priceFeed.version();
    }

    // function withdraw() public {}

    function getConversionRate(uint256 ethAmount) public view returns(uint256) {
        // 1 ETH ?
        // 2000_000000000000000000
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }

    function getPrice() public view returns (uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (,int256 price,,,) = priceFeed.latestRoundData();
        // price of ETH in terms of USD;
        // 2000.00000000
        return uint256(price * 1e10);
    }

}