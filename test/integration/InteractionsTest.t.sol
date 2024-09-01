//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundMe} from "../../src/FundMe.sol";
import {CreateFundMe, FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";
import {StdCheats} from "forge-std/StdCheats.sol";

contract InteractionsTest is StdCheats, Test {
    FundMe public fundMe;

    // Constant test variables
    address USER = address(1);

    uint256 public constant SEND_VALUE = 0.1 ether;
    uint256 public constant STARTING_BAL = 10 ether;
    uint256 public constant GAS_PRICE = 1;
    address[] FUNDERS = [
        0x70997970C51812dc3A010C7d01b50e0d17dc79C8,
        0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC,
        0x90F79bf6EB2c4f870365E785982E1f101E93b906
    ];

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        for (uint8 i = 0; i < FUNDERS.length; i++) {
            vm.deal(FUNDERS[i], STARTING_BAL);
        }
    }

    function testUserCanFundInteractions() public {
        CreateFundMe createFundMe = new CreateFundMe();
        createFundMe.createNewFundRaise(address(fundMe));

        FundFundMe fundFundMe = new FundFundMe();
        fundFundMe.fundFundMe(address(fundMe));

        assertEq(address(fundMe).balance, SEND_VALUE * 9); // Because we fund 3 fund-raises with SEND_VALUE w/ 3 FUNDERS

        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withdrawFundMe(address(fundMe));

        assertEq(address(fundMe).balance, 0);
    }
}
