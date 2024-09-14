// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";

error FundMe__NotOwner();
error FundMe__NotCreator();
error FundMe__InsufficientGoalAmt();
error FundMe__InsufficientDonationAmt();
error FundMe__FundRaiseIdNotFound();
error FundMe__FundRaiseEnded();

/**
 * @title A sample Funding Contract
 * @author MGM103
 * @notice This contract is for creating a sample funding contract
 * @dev This implements price feeds as our library
 */
contract FundMe {
    // TYPE DECLARATIONS
    using PriceConverter for uint256;
    using PriceConverter for AggregatorV3Interface;

    struct FundRaiseData {
        uint256 id;
        address creator;
        string description;
        uint256 fundRaiseAmtGoal;
        uint256 raisedAmt;
        bool active;
    }

    // STATE VARIABLES
    uint256 public constant MINIMUM_USD = 5 * 10 ** 18;
    uint256 public constant FINDERS_FEE = 25; // basis points
    uint256 private constant FINDERS_FEE_PRECISION = 10000;
    address private immutable i_owner;

    uint256 public s_id;
    AggregatorV3Interface private s_priceFeed;

    mapping(uint256 => FundRaiseData) private s_idToFundRaiseData;
    mapping(uint256 => address[]) private s_idToFunders;
    mapping(address => mapping(uint256 => uint256)) private s_addressToAmountFunded;
    mapping(address => uint256[]) private s_creatorToFundRaises;

    // EVENTS
    event createdFundRaise(
        uint256 indexed id, address indexed creator, uint256 indexed fundRaiseAmtGoal, string description
    );
    event fundedFundRaise(uint256 indexed id, address indexed funder, uint256 indexed amtFunded);
    event withrawnFundsRaised(uint256 indexed id, address indexed creator, uint256 indexed amtWithdrawn);

    // MODIFIERS
    modifier onlyOwner() {
        if (msg.sender != i_owner) revert FundMe__NotOwner();
        _;
    }

    modifier onlyCreator(uint256 _id) {
        if (msg.sender != s_idToFundRaiseData[_id].creator) revert FundMe__NotCreator();
        _;
    }

    constructor(address priceFeed) {
        s_priceFeed = AggregatorV3Interface(priceFeed);
        i_owner = msg.sender;
        s_id = 1;
    }

    function createFundRaise(string calldata fundRaiseDescription, uint256 fundRaiseAmtGoal) public {
        if (fundRaiseAmtGoal.getConversionRate(s_priceFeed) < MINIMUM_USD) revert FundMe__InsufficientGoalAmt();

        FundRaiseData memory newFundRaise = FundRaiseData({
            id: s_id,
            creator: msg.sender,
            description: fundRaiseDescription,
            fundRaiseAmtGoal: fundRaiseAmtGoal,
            raisedAmt: 0,
            active: true
        });

        s_idToFundRaiseData[s_id] = newFundRaise;
        s_creatorToFundRaises[msg.sender].push(s_id);

        emit createdFundRaise(s_id, msg.sender, fundRaiseAmtGoal, fundRaiseDescription);

        s_id++;
    }

    /// @notice Funds our contract based on the ETH/USD price
    function fund(uint256 id) public payable {
        if (msg.value.getConversionRate(s_priceFeed) < MINIMUM_USD) revert FundMe__InsufficientDonationAmt();
        if (id >= s_id) revert FundMe__FundRaiseIdNotFound();
        if (!s_idToFundRaiseData[id].active) revert FundMe__FundRaiseEnded();

        s_idToFundRaiseData[id].raisedAmt += msg.value;
        s_addressToAmountFunded[msg.sender][id] = msg.value;
        s_idToFunders[id].push(msg.sender);

        emit fundedFundRaise(id, msg.sender, msg.value);
    }

    function withdraw(uint256 id) public onlyCreator(id) {
        if (id >= s_id) revert FundMe__FundRaiseIdNotFound();
        if (!s_idToFundRaiseData[id].active) revert FundMe__FundRaiseEnded();

        s_idToFundRaiseData[id].active = false;
        uint256 amtRaised = s_idToFundRaiseData[id].raisedAmt;
        uint256 findersFee = (amtRaised * FINDERS_FEE) / FINDERS_FEE_PRECISION;
        uint256 creatorReceivedAmt = amtRaised - findersFee;
        address creator = getCreator(id);

        (bool successCreatorWithdrawal,) = creator.call{value: creatorReceivedAmt}("");
        require(successCreatorWithdrawal);

        (bool successOwnerPayment,) = i_owner.call{value: findersFee}("");
        require(successOwnerPayment);

        emit withrawnFundsRaised(id, msg.sender, amtRaised);
    }

    /**
     * @notice Gets the amount that an address has funded
     * @param id the id of the fund raise
     *  @param fundingAddress the address of the funder
     *  @return the amount funded
     */
    function getAddressToAmountFunded(uint256 id, address fundingAddress) public view returns (uint256) {
        return s_addressToAmountFunded[fundingAddress][id];
    }

    function getRaisedAmt(uint256 id) public view returns (uint256) {
        return s_idToFundRaiseData[id].raisedAmt;
    }

    function getFundRaiseAmtGoal(uint256 id) public view returns (uint256) {
        return s_idToFundRaiseData[id].fundRaiseAmtGoal;
    }

    function getVersion() public view returns (uint256) {
        return s_priceFeed.version();
    }

    function getFunder(uint256 id, uint256 index) public view returns (address) {
        return s_idToFunders[id][index];
    }

    function getFunders(uint256 id) public view returns (address[] memory) {
        return s_idToFunders[id];
    }

    function getOwner() public view returns (address) {
        return i_owner;
    }

    function getCreator(uint256 id) public view returns (address) {
        if (id >= s_id) revert FundMe__FundRaiseIdNotFound();

        return s_idToFundRaiseData[id].creator;
    }

    function getPriceFeed() public view returns (AggregatorV3Interface) {
        return s_priceFeed;
    }

    function getCreatorFundRaises(address creatorAddr) public view returns (uint256[] memory) {
        return s_creatorToFundRaises[creatorAddr];
    }

    function getFundRaiseDescription(uint256 id) public view returns (string memory) {
        return s_idToFundRaiseData[id].description;
    }

    function getStatus(uint256 id) public view returns (bool) {
        return s_idToFundRaiseData[id].active;
    }

    function getFindersFee(uint256 id) public view returns (uint256) {
        uint256 raisedAmt = s_idToFundRaiseData[id].raisedAmt;
        return (raisedAmt * FINDERS_FEE) / FINDERS_FEE_PRECISION;
    }

    function getEthPrice() public view returns (uint256) {
        return s_priceFeed.getPrice();
    }
}
