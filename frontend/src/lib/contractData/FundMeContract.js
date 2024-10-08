import { dev } from '$app/environment';

export const FUND_ME_ADDRESS = dev
	? '0xe7f1725e7734ce288f8367e1bb143e90bb3f0512'
	: '0xE456Fa060f8Ca9B2D1C59D34CEabF3d48aba434b';

export const FUND_ME_READS = {
	GET_AMOUNT_DONATED: 'getAddressToAmountFunded',
	GET_CREATOR_FUND_RAISES: 'getCreatorFundRaises',
	GET_DESCRIPTION: 'getFundRaiseDescription',
	GET_ETH_PRICE: 'getEthPrice',
	GET_FINDERS_FEE: 'getFindersFee',
	GET_FUND_RAISE_CREATOR: 'getCreator',
	GET_FUND_RAISE_DONOR: 'getFunder',
	GET_FUND_RAISE_DONORS: 'getFunders',
	GET_FUND_RAISE_GOAL: 'getFundRaiseAmtGoal',
	GET_FUND_RAISE_STATUS: 'getStatus',
	GET_MINIMUM_DONATION_USD: 'MINIMUM_USD',
	GET_OWNER: 'getOwner',
	GET_RAISED_AMOUNT: 'getRaisedAmt'
};

export const FUND_ME_WRITES = {
	CREATE_FUND_RAISE: 'createFundRaise',
	DONATE: 'fund',
	WITHDRAW_FUNDS: 'withdraw'
};

export const FUND_ME_EVENTS = {
	CREATE_FUND_RAISE: 'createdFundRaise',
	DONATED: 'fundedFundRaise'
};
