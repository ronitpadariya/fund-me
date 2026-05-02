// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract FundMe {

    uint256 public minimumUsd = 5;

    function fundMe() public payable {
        // Allow users to send $
        // Have a minimum send 5$
        // 1. How do we send ETH to this contract?
        require(msg.value >= minimumUsd, "Didn't send enough ETH");  // 1e18 = 1 ETH = 1000000000000000000
        // https://api

    }

    // function withdraw() public {}

}