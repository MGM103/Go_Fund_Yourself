<script>
	import { fade } from 'svelte/transition';
	import { onMount } from 'svelte';
	import { goto } from '$app/navigation';
	import HomeContentSection from './components/HomeContentSection.svelte';
	import typewriter from '$lib';
	import { aid, anonymous, chains, globe } from '$lib/assets';

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
					class="shadow-btn"
					transition:fade={{ delay: 5000, duration: 1000 }}
					on:click={() => goto('/fund-yourself')}>Raise funds</button
				>
			</div>
		{/if}
	</section>
	<HomeContentSection revealThreshold={0.4}>
		<div class="section-container">
			<div in:fade={{ delay: 100, duration: 550 }} out:fade class="section-description-card">
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
				<button class="shadow-btn" on:click={() => goto('/fund-yourself')}>Fund yourself</button>
			</div>
			<div class="section-icon-container">
				<div in:fade={{ delay: 300, duration: 550 }} out:fade class="section-icon-card">
					<img src={globe} alt="globe icon" />
					<p>Raise globally</p>
				</div>
				<div in:fade={{ delay: 500, duration: 550 }} out:fade class="section-icon-card">
					<img src={chains} alt="chain icon" />
					<p>Raise without censorship</p>
				</div>
			</div>
		</div>
	</HomeContentSection>
	<HomeContentSection revealThreshold={0.2}>
		<div class="section-container">
			<div in:fade={{ delay: 100, duration: 550 }} out:fade class="section-description-card">
				<h2>Donate to initiatives around the world</h2>
				<p>
					Donate to unique initiatives around the globe and aid different communities and people to
					help them achieve their goals.
				</p>
				<p>
					Being built on top of blockchain technology donations are pseudo-anonymous by default. So
					you can donate to different causes with piece of mind that your identity is not
					broadcasted every time you make a donation.
				</p>
				<p>Get started donating today.</p>
				<button class="shadow-btn" on:click={() => goto('/fund-someone')}>Fund someone</button>
			</div>
			<div class="section-icon-container">
				<div in:fade={{ delay: 300, duration: 550 }} out:fade class="section-icon-card">
					<img src={aid} alt="first-aid kit icon" />
					<p>Aid communities <br /> across the world</p>
				</div>
				<div in:fade={{ delay: 500, duration: 550 }} out:fade class="section-icon-card">
					<img src={anonymous} alt="anonymous icon" />
					<p>Pseudo-anonymous <br /> donations by default</p>
				</div>
			</div>
		</div>
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
		}
	}

	.section-container {
		display: flex;
		gap: 2.5rem;

		.section-description-card {
			border-radius: 20px;
			border-top: 4px solid $TEAL_25;
			box-shadow: 0px 12px 12px #00000015;
			flex: 1;
			padding: 2rem;

			button {
				margin: 1rem 0;
			}
		}

		.section-icon-container {
			display: flex;
			flex-direction: column;
			gap: 1rem;

			.section-icon-card {
				align-items: center;
				border-radius: 20px;
				border-top: 4px solid $TEAL_25;
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
					border-radius: 50%;
					max-height: 100px;
					max-width: 100px;
				}
			}
		}
	}
</style>
