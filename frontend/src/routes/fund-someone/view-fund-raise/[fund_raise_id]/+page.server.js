import { formatEther, getContract } from 'viem';
import { publicClient } from '$lib/server/viemClient.js';
import abi from '$lib/contractData/abi/FundMe.json';
import { FUND_ME_ADDRESS } from '$lib/contractData/FundMeContract.js';
import { getDescriptionById } from '$lib/server/db/database.js';

export async function load({ params, url }) {
	const id = params.fund_raise_id;
	const title = url.searchParams.get('title');
	const goalAmt = url.searchParams.get('goalAmt');
	const active = url.searchParams.get('active');

	const fundMeContract = getContract({
		address: FUND_ME_ADDRESS,
		abi,
		client: publicClient
	});

	const [amountRaised, funders] = await Promise.all([
		fundMeContract.read.getRaisedAmt([id]),
		fundMeContract.read.getFunders([id])
	]);

	const getDescription = () => {
		const result = getDescriptionById(id);
		if (!result) {
			return '';
		}
		return result;
	};

	const descriptionResponse = getDescription();
	const amountRaisedEth = formatEther(amountRaised);

	return {
		id,
		title,
		descriptionResponse,
		active,
		amountRaisedEth,
		goalAmt,
		funders
	};
}
