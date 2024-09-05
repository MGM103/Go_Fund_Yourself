// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

contract CreateFundMe is Script {
    string[12] FUND_RAISE_DESCRIPTIONS = [
        "College tuition",
        "Drinks w/ the boys",
        "Rent",
        "New car",
        "Christmas donations",
        "Mortgage",
        "Engagement ring",
        "PS5",
        "New PC",
        "Europe trip",
        "Asia trip",
        "Music festival tickets"
    ];
    uint256[12] FUND_RAISE_GOALS = [
        20 ether,
        0.5 ether,
        1 ether,
        5 ether,
        0.5 ether,
        10 ether,
        2.5 ether,
        0.75 ether,
        1.5 ether,
        2 ether,
        1 ether,
        0.8 ether
    ];
    string constant CONTRACT_NAME = "FundMe";

    function createNewFundRaise(address mostRecentlyDeployedAddress) public {
        vm.startBroadcast();
        for (uint8 i = 0; i < FUND_RAISE_DESCRIPTIONS.length; i++) {
            FundMe(mostRecentlyDeployedAddress).createFundRaise(FUND_RAISE_DESCRIPTIONS[i], FUND_RAISE_GOALS[i]);
        }
        vm.stopBroadcast();

        console.log("Created %s fund-raises", FUND_RAISE_DESCRIPTIONS.length);
    }

    function run() external {
        console.log(block.chainid);
        address mostRecentlyDeployedContract = DevOpsTools.get_most_recent_deployment(CONTRACT_NAME, block.chainid);

        createNewFundRaise(mostRecentlyDeployedContract);
    }
}

contract FundFundMe is Script {
    uint256 constant FUND_AMT = 0.1 ether;
    string constant CONTRACT_NAME = "FundMe";
    uint256[] FUND_RAISE_IDS = [1, 2, 3];
    uint256[3] FUNDERS = [
        0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d,
        0x5de4111afa1a4b94908f83103eb1f1706367c2e68ca870fc3fb9a804cdab365a,
        0x7c852118294e51e653712a81e05800f419141751be58f605c371e15141b007a6
    ];

    function fundFundMe(address mostRecentlyDeployedAddress) public {
        for (uint8 i = 0; i < FUNDERS.length; i++) {
            vm.startBroadcast(FUNDERS[i]);
            for (uint8 j = 0; j < FUND_RAISE_IDS.length; j++) {
                FundMe(payable(mostRecentlyDeployedAddress)).fund{value: FUND_AMT}(FUND_RAISE_IDS[j]);
            }
            vm.stopBroadcast();
        }

        console.log("Funded %s existing fund-raises", FUND_RAISE_IDS.length);
    }

    function run() external {
        address mostRecentlyDeployedContract = DevOpsTools.get_most_recent_deployment(CONTRACT_NAME, block.chainid);

        fundFundMe(mostRecentlyDeployedContract);
    }
}

contract WithdrawFundMe is Script {
    string constant CONTRACT_NAME = "FundMe";
    uint256[] FUND_RAISE_IDS = [1, 2, 3];

    function withdrawFundMe(address mostRecentlyDeployedAddress) public {
        vm.startBroadcast();
        for (uint8 i = 0; i < FUND_RAISE_IDS.length; i++) {
            FundMe(payable(mostRecentlyDeployedAddress)).withdraw(FUND_RAISE_IDS[i]);
        }
        vm.stopBroadcast();

        console.log("Withdrew from FundMe");
    }

    function run() external {
        address mostRecentlyDeployedContract = DevOpsTools.get_most_recent_deployment(CONTRACT_NAME, block.chainid);

        withdrawFundMe(mostRecentlyDeployedContract);
    }
}
