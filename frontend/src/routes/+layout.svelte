<script>
	import '$lib/styles/global.scss';
	import Footer from './components/Footer.svelte';
	import Navbar from './components/Navbar.svelte';
	import { onMount } from 'svelte';
	import { dev } from '$app/environment';
	import { defaultConfig } from 'svelte-wagmi';
	import { injected } from '@wagmi/core';
	import { anvil, sepolia } from 'viem/chains';
	import { PUBLIC_WALLETCONNECT_ID } from '$env/static/public';

	onMount(async () => {
		console.log(dev);
		const erckit = defaultConfig({
			appName: 'GO_FUND_YOURSELF',
			chains: [dev ? anvil : sepolia],
			connectors: [injected()],
			walletConnectProjectId: PUBLIC_WALLETCONNECT_ID
		});

		await erckit.init();
	});
</script>

<main id="main-content">
	<Navbar />
	<slot></slot>
	<Footer />
</main>

<style scoped lang="scss">
	@import '../lib/styles/constants.scss';

	#main-content {
		height: 100%;
		max-inline-size: 1080px;
		display: grid;
		grid-template-rows: auto 1fr auto;
		margin-inline: auto;
		padding-inline: 2rem;

		@media (min-width: 1080px) {
			padding-inline: 0;
		}
	}
</style>
