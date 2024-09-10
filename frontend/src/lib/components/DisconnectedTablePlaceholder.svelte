<script>
	import { configuredConnectors, loading, wagmiConfig } from 'svelte-wagmi';
	import { connect } from '@wagmi/core';

	const connectWallet = async () => {
		$loading = true;
		await connect($wagmiConfig, {
			connector: $configuredConnectors[0]
		});
		$loading = false;
	};
</script>

<div class="placeholder-container">
	<h2 class="h3">Please connect wallet to see content</h2>
	<button class="shadow-btn" on:click={connectWallet}>Connect</button>
</div>

<style scoped lang="scss">
	.placeholder-container {
		align-items: center;
		background-color: var(--color-tertiary);
		border-radius: 12px;
		display: flex;
		flex-direction: column;
		justify-content: center;
		margin: 4rem 0;
		padding: 13.5rem;
	}
</style>
