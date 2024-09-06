import { getContract, formatEther } from 'viem';
import { publicClient } from '$lib/server/viemClient.js';
import abi from '$lib/contractData/abi/FundMe.json';
import { FUND_ME_ADDRESS } from '$lib/contractData/FundMeContract.js';

export async function load() {
	const DASHBOARD_NAVIGATION_URL = `/fund-someone/view-fund-raise/`;

	const fundMeContract = getContract({
		abi,
		address: FUND_ME_ADDRESS,
		client: publicClient
	});

	const totalFundRaises = await fundMeContract.read.s_id(); // this value is 1 higher than the amt of fund raises present
	let fundRaises = [];

	for (let i = 1; i < totalFundRaises; i++) {
		let [title, fundRaiseGoalAmount, active] = await Promise.all([
			fundMeContract.read.getFundRaiseDescription([i]),
			fundMeContract.read.getFundRaiseAmtGoal([i]),
			fundMeContract.read.getStatus([i])
		]);

		fundRaises.push({
			id: i,
			name: title,
			goal: formatEther(fundRaiseGoalAmount),
			active,
			url: DASHBOARD_NAVIGATION_URL
		});
	}

	return { fundRaises };
}
