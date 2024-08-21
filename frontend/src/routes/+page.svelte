<script>
	import { fade } from 'svelte/transition';
	import { onMount } from 'svelte';
	import { goto } from '$app/navigation';
	import HomeContentSection from './components/HomeContentSection.svelte';
	import typewriter from '$lib';
	import chains from '$lib/assets/chains-crossed.svg';
	import globe from '$lib/assets/globe.svg';

	// STATE VARIABLES
	let landingVisible = false;

	// LIFE-CYCLE LOGIC
	onMount(() => {
		landingVisible = true;
		window.scrollTo(0, 0);
	});
</script>

<div class="content-container">
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
	<HomeContentSection revealThreshold={0.4}>
		<div class="fund-yourself-container">
			<div in:fade={{ delay: 100 }} out:fade class="fund-yourself-description-card">
				<h2>Raise funds for a special cause</h2>
				<p>
					This platform allows you to leverage the power of smart contracts on the blockchain to
					raise funds for any type of cause near and dear to your heart in a decentralized and
					permissionless manner.
				</p>
				<p>
					This means that Go Fund Yourself facilitates fund raising that is censorship resistant and
					global in its out-reach. No one can take down your fund-raising initiative and anyone with
					an internet connection can contribute to your cause.
				</p>
				<p>Get started raising today.</p>
				<button class="shadow-btn">Fund yourself</button>
			</div>
			<div class="fund-yourself-icon-container">
				<div in:fade={{ delay: 300 }} out:fade class="fund-yourself-icon-card">
					<img src={globe} alt="globe icon" />
					<p>Raise globally</p>
				</div>
				<div in:fade={{ delay: 500 }} out:fade class="fund-yourself-icon-card">
					<img src={chains} alt="chain icon" />
					<p>Raise without censorship</p>
				</div>
			</div>
		</div>
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
		align-items: center;
		height: 80vh;
		justify-content: center;
		margin: auto;

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
	}

	.fund-yourself-container {
		display: flex;
		gap: 2.5rem;

		.fund-yourself-description-card {
			border-radius: 20px;
			box-shadow: 0px 12px 12px #00000015;
			flex: 1;
			padding: 2rem;

			button {
				margin: 1rem 0;
			}
		}

		.fund-yourself-icon-container {
			display: flex;
			flex-direction: column;
			gap: 1rem;

			.fund-yourself-icon-card {
				align-items: center;
				border-radius: 20px;
				box-shadow: 0px 12px 12px #00000015;
				display: flex;
				flex-direction: column;
				flex: 1;
				height: 80px;
				justify-content: center;
				padding: 1rem;

				p {
					font-weight: 500;
					margin-bottom: 0;
				}

				img {
					max-height: 100px;
					max-width: 100px;
				}
			}
		}
	}
</style>
