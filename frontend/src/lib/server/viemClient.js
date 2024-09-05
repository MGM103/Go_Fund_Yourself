import { createPublicClient, http } from 'viem';
import { anvil } from 'viem/chains';

export const publicClient = createPublicClient({
	batch: {
		multicall: true
	},
	chain: anvil,
	transport: http()
});
