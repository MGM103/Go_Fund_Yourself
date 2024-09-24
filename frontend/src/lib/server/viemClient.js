import { createPublicClient, http } from 'viem';
import { anvil, sepolia } from 'viem/chains';
import { SEPOLIA_RPC_URL } from '$env/static/private';
import { dev } from '$app/environment';

export const publicClient = createPublicClient({
	batch: {
		multicall: true
	},
	chain: dev ? anvil : sepolia,
	transport: dev ? http() : http(SEPOLIA_RPC_URL)
});
