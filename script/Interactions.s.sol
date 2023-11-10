// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundFundMe is Script {
    uint256 constant FUND_AMT = 0.01 ether;
    string constant CONTRACT_NAME = "FundMe";

    function fundFundMe(address mostRecentlyDeployedAddress) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentlyDeployedAddress)).fund{value: FUND_AMT}();
        vm.stopBroadcast();

        console.log("Funded FundMe with %s", FUND_AMT);
    }

    function run() external {
        address mostRecentlyDeployedContract = DevOpsTools
            .get_most_recent_deployment(CONTRACT_NAME, block.chainid);

        fundFundMe(mostRecentlyDeployedContract);
    }
}

contract WithdrawFundMe is Script {
    string constant CONTRACT_NAME = "FundMe";

    function withdrawFundMe(address mostRecentlyDeployedAddress) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentlyDeployedAddress)).withdraw();
        vm.stopBroadcast();

        console.log("Withdrew from FundMe");
    }

    function run() external {
        address mostRecentlyDeployedContract = DevOpsTools
            .get_most_recent_deployment(CONTRACT_NAME, block.chainid);

        withdrawFundMe(mostRecentlyDeployedContract);
    }
}
