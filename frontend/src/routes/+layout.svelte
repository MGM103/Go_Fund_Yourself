<script>
	import '$lib/styles/global.scss';
	import Footer from './components/Footer.svelte';
	import Navbar from './components/Navbar.svelte';
	import { onMount } from 'svelte';
	import { defaultConfig } from 'svelte-wagmi';
	import { injected } from '@wagmi/core';
	import { sepolia } from 'viem/chains';
	import { PUBLIC_WALLETCONNECT_ID } from '$env/static/public';

	onMount(async () => {
		const erckit = defaultConfig({
			appName: 'GO_FUND_YOURSELF',
			chains: [sepolia],
			connectors: [injected()],
			walletConnectProjectId: PUBLIC_WALLETCONNECT_ID
		});

		await erckit.init();
	});
</script>

<Navbar />
<div id="main-content">
	<slot></slot>
</div>
<Footer />

<style scoped lang="scss">
	@import '../lib/styles/constants.scss';

	#main-content {
		max-width: 1080px;
		margin: 0 auto;
	}
</style>
