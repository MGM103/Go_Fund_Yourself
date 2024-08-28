// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

contract CreateFundMe is Script {
    string constant FUND_RAISE_DESCRIPTION = "College tuition";
    uint256 constant FUND_RAISE_GOAL = 20 ether;
    string constant CONTRACT_NAME = "FundMe";

    function createNewFundRaise(address mostRecentlyDeployedAddress) public {
        vm.startBroadcast();
        FundMe(mostRecentlyDeployedAddress).createFundRaise(FUND_RAISE_DESCRIPTION, FUND_RAISE_GOAL);
        vm.stopBroadcast();

        console.log("Created fund raise with a goal of: %s", FUND_RAISE_GOAL);
    }

    function run() external {
        address mostRecentlyDeployedContract = DevOpsTools.get_most_recent_deployment(CONTRACT_NAME, block.chainid);

        createNewFundRaise(mostRecentlyDeployedContract);
    }
}

contract FundFundMe is Script {
    uint256 constant FUND_AMT = 0.01 ether;
    uint256 constant FUND_RAISE_ID = 1;
    string constant CONTRACT_NAME = "FundMe";

    function fundFundMe(address mostRecentlyDeployedAddress) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentlyDeployedAddress)).fund{value: FUND_AMT}(FUND_RAISE_ID);
        vm.stopBroadcast();

        console.log("Funded FundMe with %s", FUND_AMT);
    }

    function run() external {
        address mostRecentlyDeployedContract = DevOpsTools.get_most_recent_deployment(CONTRACT_NAME, block.chainid);

        fundFundMe(mostRecentlyDeployedContract);
    }
}

contract WithdrawFundMe is Script {
    string constant CONTRACT_NAME = "FundMe";
    uint256 constant FUND_RAISE_ID = 1;

    function withdrawFundMe(address mostRecentlyDeployedAddress) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentlyDeployedAddress)).withdraw(FUND_RAISE_ID);
        vm.stopBroadcast();

        console.log("Withdrew from FundMe");
    }

    function run() external {
        address mostRecentlyDeployedContract = DevOpsTools.get_most_recent_deployment(CONTRACT_NAME, block.chainid);

        withdrawFundMe(mostRecentlyDeployedContract);
    }
}
