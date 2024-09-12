<script>
	import {
		connected,
		configuredConnectors,
		disconnectWagmi,
		loading,
		signerAddress,
		wagmiConfig
	} from 'svelte-wagmi';
	import { connect } from '@wagmi/core';
	import { AccountSvg } from '$lib/assets';

	// FUNCTIONS
	const connectWallet = async () => {
		$loading = true;
		await connect($wagmiConfig, {
			connector: $configuredConnectors[0]
		});
		$loading = false;
	};

	const disconnectWallet = async () => {
		await disconnectWagmi();
	};
</script>

{#if $connected}
	<button class="connected-btn" on:click={disconnectWallet} title="Disconnect wallet">
		<AccountSvg />
		<p id="user-address">
			{`${$signerAddress.slice(0, 5)}...${$signerAddress.slice(-4)}`}
		</p>
	</button>
{:else}
	<button on:click={connectWallet} class="connect-btn">
		{#if $loading}
			loading...
		{:else}
			Connect
		{/if}
	</button>
{/if}

<style lang="scss">
	.connect-btn,
	.connected-btn {
		z-index: 1;
	}

	button {
		margin-left: auto;
	}

	#user-address {
		font-weight: 500;
	}

	svg {
		display: none;
	}
</style>
