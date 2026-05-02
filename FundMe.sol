// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract FundMe {

    uint256 public minimumUsd = 5e18;

    function fund() public payable {
        // Allow users to send $
        // Have a minimum send 5$
        // 1. How do we send ETH to this contract?
        require(getConversionRate(msg.value) >= minimumUsd, "Didn't send enough ETH");  // 1e18 = 1 ETH = 1000000000000000000
        // https://api

    }

    function getVersion() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        return priceFeed.version();
    }

    // function withdraw() public {}

    function getConversionRate(uint256 ethAmount) public view returns(uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethAmount * ethPrice) / 1e18;
        return ethAmountInUsd;
    }

    function getPrice() public view returns (uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (,int256 price,,,) = priceFeed.latestRoundData();
        // price = price * 1e10;
        // price = price / 1e8; // 1e8 = 10
        return uint256(price * 1e10);
    }

}