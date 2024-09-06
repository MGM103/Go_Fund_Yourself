import { fail } from '@sveltejs/kit';
import { getContract } from 'viem';
import { publicClient } from '$lib/server/viemClient.js';
import abi from '$lib/contractData/abi/FundMe.json';
import { FUND_ME_ADDRESS } from '$lib/contractData/FundMeContract.js';
import { getDescriptionById } from '$lib/server/db/database.js';
import { updateDescription } from '$lib/server/db/database';

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

	return {
		id,
		title,
		descriptionResponse,
		active,
		amountRaised,
		goalAmt,
		funders
	};
}

export const actions = {
	updateFundRaiseDescription: async ({ params, request }) => {
		try {
			console.log(`Entered`);
			const id = params.fund_raise_id;
			console.log(`Here is the id: ${id}`);
			const data = await request.formData();
			console.log(`Got data: ${data}`);
			const newDescription = data.get('fundRaiseDescription');
			console.log(`Got description: ${newDescription}`);

			updateDescription(id, newDescription);

			return { newDescription };
		} catch (err) {
			return fail(500, { error: 'Failed to update description in db' });
		}
	}
};
