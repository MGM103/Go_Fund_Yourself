// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";

contract DeployFundMe is Script {
    address private priceFeedAddrSepolia =
        0x694AA1769357215DE4FAC081bf1f309aDC325306;

    function deploy() external returns (FundMe) {
        vm.startBroadcast();
        FundMe fundMe = new FundMe(priceFeedAddrSepolia);
        vm.stopBroadcast();
        return fundMe;
    }
}
