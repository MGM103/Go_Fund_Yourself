<script>
	import { onMount } from 'svelte';
	import {
		connected,
		configuredConnectors,
		disconnectWagmi,
		loading,
		signerAddress,
		wagmiConfig
	} from 'svelte-wagmi';
	import { connect } from '@wagmi/core';
	import { account } from '$lib/assets';

	// STATE VARIABLES
	let navBar;

	// LIFECYCLE
	onMount(() => {
		window.addEventListener('scroll', updateNavbarShadow);

		return () => {
			window.removeEventListener('scroll', updateNavbarShadow);
		};
	});

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

	const updateNavbarShadow = () => {
		const scrollTop = window.scrollY;

		if (scrollTop > 0) {
			navBar.style.setProperty('--nav-shadow', '0 -8px 24px var(--color-secondary)');
		} else {
			navBar.style.setProperty('--nav-shadow', 'none');
		}
	};
</script>

<nav bind:this={navBar}>
	<div class="title-and-links">
		<h2><a id="nav-logo" href="/">Go Fund Yourself</a></h2>
		<ul>
			<li><a href="/fund-yourself">Fund yourself</a></li>
			<li><a href="/fund-someone">Fund someone</a></li>
		</ul>
	</div>

	{#if $connected}
		<button class="connected-btn" on:click={disconnectWallet} title="Disconnect wallet">
			<img src={account} alt="account-icon" />
			{`${$signerAddress.slice(0, 5)}...${$signerAddress.slice(-4)}`}
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
</nav>

<style scoped lang="scss">
	nav {
		align-items: center;
		display: flex;
		flex-direction: row;
		justify-content: space-between;
		margin: 0 auto;
		max-width: 1080px;
		position: sticky;
		top: 0;
		width: 100%;
		z-index: 1;

		.title-and-links {
			align-items: center;
			display: flex;
			flex-direction: row;
			gap: 2.5rem;
			z-index: 1;

			ul {
				display: flex;
				list-style-type: none;
				margin: 0;
				padding: 0;

				li {
					margin-right: 1.75rem;
				}

				li:last-child {
					margin-right: 0;
				}
			}

			a {
				color: var(--color-secondary);
				text-decoration: none;

				&:not(#nav-logo) {
					display: block;
				}

				&:hover:not(#nav-logo) {
					transform: scale(1.025);
					transition: transform 0.1s ease;
				}
			}
		}

		.connect-btn,
		.connected-btn {
			z-index: 1;
		}

		&::before {
			content: '';
			background-color: var(--color-primary);
			box-shadow: var(--nav-shadow);
			height: 100%;
			top: 0;
			left: 50%;
			position: absolute;
			transform: translateX(-50%);
			transition: box-shadow 0.5s ease;
			width: 100vw;
			z-index: 0;
		}
	}
</style>
