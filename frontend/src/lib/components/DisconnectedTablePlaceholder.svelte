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
		background-color: var(--color-pre-primary);
		border-radius: 12px;
		box-shadow: 0 0px 2px var(--color-shadow-a);
		display: flex;
		flex-direction: column;
		justify-content: center;
		height: 500px;
		margin-bottom: 2rem;
		padding: 2rem;
		text-align: center;

		@media (max-width: 680px) {
			height: 250px;
		}
	}
</style>
