<script>
	import { fade } from 'svelte/transition';
	import { onMount } from 'svelte';
	import { goto } from '$app/navigation';
	import HomeContentSection from './components/HomeContentSection.svelte';
	import typewriter from '$lib';

	// STATE VARIABLES
	let landingVisible = false;

	// LIFE-CYCLE LOGIC
	onMount(() => {
		landingVisible = true;
		window.scrollTo(0, 0);
	});
</script>

<div>
	<section class="landing-section">
		{#if landingVisible}
			<h1 in:fade={{ duration: 3000, delay: 100 }}>Go</h1>
			<h1 in:fade={{ duration: 3000, delay: 800 }}>Fund</h1>
			<h1 in:fade={{ duration: 3000, delay: 1500 }}>Yourself.</h1>
			<div class="call-to-action">
				<p transition:typewriter={{ speed: 2, delay: 2000 }}>
					Harness the power of crowd-sourced fund-raising today
				</p>
				<button
					class="connect-btn"
					transition:fade={{ delay: 5000, duration: 1000 }}
					on:click={() => goto('/fund-yourself')}>Raise funds</button
				>
			</div>
		{/if}
	</section>
	<HomeContentSection revealThreshold={0.1}>
		<h2>Raise funds for a special cause</h2>
	</HomeContentSection>
	<HomeContentSection revealThreshold={0.2}>
		<h2 in:fade>Donate to initiatives around the world</h2>
	</HomeContentSection>
</div>

<style scoped lang="scss">
	@import '../lib/styles/constants.scss';

	section {
		display: flex;
		flex-direction: column;
		height: 50vh;
		position: relative;
	}

	.landing-section {
		padding-top: 4rem;

		h1 {
			font-size: 108px;
			margin: 0;
		}

		.call-to-action {
			align-items: center;
			display: flex;
			gap: 1rem;
			padding: 2rem 0;

			button {
				max-height: 35px;
			}
		}

		&::before {
			content: '';
			background-color: $LIGHT_TEAL_25;
			height: 100%;
			top: 0;
			left: 50%;
			position: absolute;
			transform: translateX(-50%);
			width: 100vw;
			z-index: -1;
		}
	}
</style>
