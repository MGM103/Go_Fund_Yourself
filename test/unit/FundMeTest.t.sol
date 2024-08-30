//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundMe} from "../../src/FundMe.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    struct FundRaiseData {
        uint256 id;
        address creator;
        string description;
        uint256 fundRaiseAmtGoal;
        uint256 raisedAmt;
    }

    // Constant test variables
    address USER = makeAddr("user");
    address DONATOR = makeAddr("donator");
    address constant OWNER = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    uint256 constant SEND_VALUE = 0.25 ether;
    uint256 constant STARTING_BAL = 10 ether;
    uint256 constant GAS_PRICE = 1;
    uint256 constant FUND_RAISE_ID = 1;
    uint256 constant FUND_RAISE_GOAL = 10 ether;
    uint256 public constant FINDERS_FEE = 25; // basis points
    uint256 private constant FINDERS_FEE_PRECISION = 10000;
    string constant FUND_RAISE_DESCRIPTION = "College tuition";

    // EVENTS
    event createdFundRaise(
        uint256 indexed id, address indexed creator, uint256 indexed fundRaiseAmtGoal, string description
    );
    event fundedFundRaise(uint256 indexed id, address indexed funder, uint256 indexed amtFunded);
    event withrawnFundsRaised(uint256 indexed id, address indexed creator, uint256 indexed amtWithdrawn);

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, STARTING_BAL);
        vm.deal(DONATOR, STARTING_BAL);
    }

    // PUBLIC CONSTANTS & IMMUTABLE VARIABLES
    function testMinDollarAmountIsFive() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsSetCorrectly() public {
        assertEq(fundMe.getOwner(), OWNER);
    }

    function testIdStartsAtOne() public {
        assertEq(fundMe.s_id(), 1);
    }

    function testVersionNumber() public {
        assertEq(fundMe.getVersion(), 4);
    }

    // TESTING CREATE FUND RAISE
    modifier createNewFundRaise() {
        vm.startPrank(USER);
        fundMe.createFundRaise(FUND_RAISE_DESCRIPTION, FUND_RAISE_GOAL);
        vm.stopPrank();
        _;
    }

    function testRevertsIfGoalAmtBelowDonationThreshold() public {
        vm.expectRevert();
        fundMe.createFundRaise(FUND_RAISE_DESCRIPTION, 0);
    }

    function testCreateFundRaiseEventEmitted() public {
        vm.startPrank(USER);
        vm.expectEmit();
        emit createdFundRaise(FUND_RAISE_ID, USER, FUND_RAISE_GOAL, FUND_RAISE_DESCRIPTION);
        fundMe.createFundRaise(FUND_RAISE_DESCRIPTION, FUND_RAISE_GOAL);
        vm.stopPrank();
    }

    function testCreateFundRaiseUpdatesMappingsAccordingly() public createNewFundRaise {
        FundRaiseData memory expectedFundRaiseData = FundRaiseData({
            id: FUND_RAISE_ID,
            creator: USER,
            description: FUND_RAISE_DESCRIPTION,
            fundRaiseAmtGoal: FUND_RAISE_GOAL,
            raisedAmt: 0
        });

        // s_idToFundRaiseData
        assertEq(expectedFundRaiseData.creator, fundMe.getCreator(FUND_RAISE_ID));
        assertEq(expectedFundRaiseData.description, fundMe.getFundRaiseDescription(FUND_RAISE_ID));
        assertEq(expectedFundRaiseData.fundRaiseAmtGoal, fundMe.getFundRaiseAmtGoal(FUND_RAISE_ID));
        assertEq(expectedFundRaiseData.raisedAmt, fundMe.getRaisedAmt(FUND_RAISE_ID));
        assertEq(0, fundMe.getStatus(FUND_RAISE_ID));

        // s_creatorToFundRaises
        assertEq(fundMe.getCreatorFundRaises(USER).length, 1);
        assertEq(fundMe.getCreatorFundRaises(USER)[0], 1);
    }

    function testIdIsIncrementedAfterNewFundRaiseCreated() public createNewFundRaise {
        assertEq(fundMe.s_id(), 2);
    }

    modifier createAndFundAFundRaise() {
        vm.startPrank(USER);
        fundMe.createFundRaise(FUND_RAISE_DESCRIPTION, FUND_RAISE_GOAL);
        fundMe.fund{value: SEND_VALUE}(FUND_RAISE_ID);
        vm.stopPrank();
        _;
    }

    modifier createAndEndAFundRaise() {
        vm.startPrank(USER);
        fundMe.createFundRaise(FUND_RAISE_DESCRIPTION, FUND_RAISE_GOAL);
        fundMe.fund{value: SEND_VALUE}(FUND_RAISE_ID);
        fundMe.withdraw(FUND_RAISE_ID);
        vm.stopPrank();
        _;
    }

    // TEST FUND A FUND RAISE
    function testFundFailsBelowMinAmount() public {
        vm.expectRevert(); // Expects proceeding line to fail
        fundMe.fund(FUND_RAISE_ID); // Sending fund transaction with no ETH
    }

    function testRevertsIfFundDoesNotExist() public {
        vm.expectRevert();
        fundMe.fund{value: SEND_VALUE}(2);
    }

    function testRevertsIfFundRaiseIsCompleted() public createAndEndAFundRaise {
        vm.expectRevert();
        fundMe.fund{value: SEND_VALUE}(FUND_RAISE_ID);
    }

    function testFundEmitsEvent() public createNewFundRaise {
        vm.prank(DONATOR);
        vm.expectEmit();
        emit fundedFundRaise(FUND_RAISE_ID, DONATOR, SEND_VALUE);
        fundMe.fund{value: SEND_VALUE}(FUND_RAISE_ID);
    }

    function testRaisedAmtIsUpdated() public createAndFundAFundRaise {
        uint256 amtRaised = fundMe.getRaisedAmt(FUND_RAISE_ID);
        assertEq(amtRaised, SEND_VALUE);
    }

    function testFundUpdatesDonorAmtFunded() public createAndFundAFundRaise {
        uint256 amountFunded = fundMe.getAddressToAmountFunded(FUND_RAISE_ID, USER);
        assertEq(amountFunded, SEND_VALUE);
    }

    function testAddsFunderToFunderArray() public createAndFundAFundRaise {
        address firstFunder = fundMe.getFunder(FUND_RAISE_ID, 0);
        assertEq(firstFunder, USER);
    }

    // TEST WITHDRAW FROM A FUND RAISE
    function testOnlyCreatorCanWithdraw() public createAndFundAFundRaise {
        vm.prank(DONATOR);
        vm.expectRevert();
        fundMe.withdraw(FUND_RAISE_ID);
    }

    function testRevertsWithdrawIfFundDoesNotExist() public {
        vm.expectRevert();
        fundMe.withdraw(2);
    }

    function testRevertsWithdrawIfFundRaiseIsCompleted() public createAndEndAFundRaise {
        vm.expectRevert();
        fundMe.withdraw(FUND_RAISE_ID);
    }

    function testSuccessfulWithdrawEmitsEvent() public createAndFundAFundRaise {
        vm.prank(USER);
        vm.expectEmit();
        emit withrawnFundsRaised(FUND_RAISE_ID, USER, SEND_VALUE);
        fundMe.withdraw(FUND_RAISE_ID);
    }

    function testSuccessfulWithdrawSetsStatusToCompleted() public createAndFundAFundRaise {
        vm.prank(USER);
        fundMe.withdraw(FUND_RAISE_ID);

        assertEq(1, fundMe.getStatus(FUND_RAISE_ID));
    }

    function testCreatorWithdrawSingleFunder() public createAndFundAFundRaise {
        // Arrange
        uint256 creatorStartingBal = fundMe.getCreator(FUND_RAISE_ID).balance;
        uint256 fundRaiseStartingBal = fundMe.getRaisedAmt(FUND_RAISE_ID);

        // Act
        vm.prank(fundMe.getCreator(FUND_RAISE_ID));
        fundMe.withdraw(FUND_RAISE_ID);

        // Assert
        uint256 findersFee = fundMe.getFindersFee(FUND_RAISE_ID);
        uint256 expectedFindersFee = 625 * 10 ** 12;
        uint256 ownerEndBal = fundMe.getOwner().balance;
        uint256 expectedOwnerEndBal = (SEND_VALUE * FINDERS_FEE) / FINDERS_FEE_PRECISION;
        uint256 creatorEndBal = fundMe.getCreator(FUND_RAISE_ID).balance;
        uint256 expectedCreatorEndBal = creatorStartingBal + fundRaiseStartingBal - findersFee; // 6.25 * 10**14 eth

        assertEq(creatorEndBal, expectedCreatorEndBal);
        assertEq(ownerEndBal, expectedOwnerEndBal);
        assertEq(findersFee, expectedFindersFee);
        assertEq(fundRaiseStartingBal, ownerEndBal + (creatorEndBal - creatorStartingBal));
    }

    function testOwnerWithdrawMultipleFunders() public createNewFundRaise {
        // Arrange
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 1;

        for (uint160 i = startingFunderIndex; i <= numberOfFunders; i++) {
            hoax(address(i), STARTING_BAL);
            fundMe.fund{value: SEND_VALUE}(FUND_RAISE_ID);
        }

        uint256 creatorStartBal = fundMe.getCreator(FUND_RAISE_ID).balance;
        uint256 fundMeStartBal = address(fundMe).balance;

        // Act
        vm.prank(fundMe.getCreator(FUND_RAISE_ID));
        fundMe.withdraw(FUND_RAISE_ID);

        // Assert
        uint256 finderFee = fundMe.getFindersFee(FUND_RAISE_ID);
        uint256 expectedFinderFee = 625 * 10 ** 13;
        uint256 ownerEndBal = fundMe.getOwner().balance;
        uint256 creatorEndBal = fundMe.getCreator(FUND_RAISE_ID).balance;
        uint256 expectedCreatorEndBal = creatorStartBal + fundMeStartBal - finderFee;

        assertEq(creatorEndBal, expectedCreatorEndBal);
        assertEq(ownerEndBal, finderFee);
        assertEq(finderFee, expectedFinderFee);
        assertEq(fundMeStartBal, ownerEndBal + (creatorEndBal - creatorStartBal));
    }
}
