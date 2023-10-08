//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    // Constant test variables
    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.25 ether;
    uint256 constant STARTING_BAL = 10 ether;
    uint256 constant GAS_PRICE = 1;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.deploy();
        vm.deal(USER, STARTING_BAL);
    }

    modifier fundContract() {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        _;
    }

    function testMinDollarAmountIsFive() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public {
        assertEq(fundMe.getOwner(), msg.sender);
    }

    function testVersionNumber() public {
        assertEq(fundMe.getVersion(), 4);
    }

    function testFundFailsBelowMinAmount() public {
        vm.expectRevert(); // Expects proceeding line to fail
        fundMe.fund(); // Sending fund transaction with no ETH
    }

    function testFundUpdatesFundedDataStructure() public fundContract {
        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded, SEND_VALUE);
    }

    function testAddsFunderToFunderArray() public fundContract {
        address firstFunder = fundMe.getFunder(0);
        assertEq(firstFunder, USER);
    }

    function testOnlyOwnerCanWithdraw() public fundContract {
        vm.prank(USER);
        vm.expectRevert();
        fundMe.withdraw();
    }

    function testOwnerWithdrawSingleFunder() public fundContract {
        // Arrange
        uint256 ownerStartingBal = fundMe.getOwner().balance;
        uint256 fundMeStartingBal = address(fundMe).balance;

        // Act
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        // Assert
        uint256 ownerEndBal = fundMe.getOwner().balance;
        uint256 expectedOwnerEndBal = ownerStartingBal + fundMeStartingBal;
        uint256 fundMeEndBal = address(fundMe).balance;
        uint256 expectedFundMeEndBal = 0;

        assertEq(ownerEndBal, expectedOwnerEndBal);
        assertEq(fundMeEndBal, expectedFundMeEndBal);
    }

    function testOwnerWithdrawMultipleFunders() public {
        // Arrange
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 1;

        for (uint160 i = startingFunderIndex; i <= numberOfFunders; i++) {
            hoax(address(i), STARTING_BAL);
            fundMe.fund{value: SEND_VALUE}();
        }

        uint256 ownerStartBal = fundMe.getOwner().balance;
        uint256 fundMeStartBal = address(fundMe).balance;

        // Act
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        // Assert
        uint256 ownerEndBal = fundMe.getOwner().balance;
        uint256 expectedOwnerEndBal = ownerStartBal + fundMeStartBal;
        uint256 fundMeEndBal = address(fundMe).balance;
        uint256 expectedFundMeEndBal = 0;

        assertEq(ownerEndBal, expectedOwnerEndBal);
        assertEq(fundMeEndBal, expectedFundMeEndBal);
    }
}
