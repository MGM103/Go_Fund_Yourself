<script>
	import { fade } from 'svelte/transition';
	import { onMount } from 'svelte';
	import { goto } from '$app/navigation';
	import HomeContentSection from './components/HomeContentSection.svelte';
	import typewriter from '$lib';
	import { AnonymousSvg, ChainsCrossedSvg, FirstAidSvg, GlobeSvg } from '$lib/assets';

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
					<GlobeSvg />
					<p>Raise globally</p>
				</div>
				<div in:fade={{ delay: 500, duration: 550 }} out:fade class="section-icon-card">
					<ChainsCrossedSvg />
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
					<FirstAidSvg />
					<p>Aid communities <br /> across the world</p>
				</div>
				<div in:fade={{ delay: 500, duration: 550 }} out:fade class="section-icon-card">
					<AnonymousSvg />
					<p>Pseudo-anonymous <br /> donations by default</p>
				</div>
			</div>
		</div>
	</HomeContentSection>
</div>

<style scoped lang="scss">
	.landing-section {
		align-items: center;
		display: flex;
		height: 80vh;
		flex-direction: column;
		justify-content: center;
		margin: auto;
		position: relative;

		h1 {
			font-size: 108px;
			margin: 0;

			@media (max-width: 680px) {
				font-size: 69px;
			}
		}

		.call-to-action {
			align-items: center;
			display: flex;
			gap: 1rem;
			padding: 2rem 0;

			@media (max-width: 680px) {
				flex-direction: column;

				p {
					word-wrap: break-word;
				}
			}
		}
	}

	.section-container {
		display: flex;
		gap: 2.5rem;

		@media (max-width: 680px) {
			flex-direction: column;
		}

		.section-description-card {
			background-color: var(--color-pre-primary);
			border-radius: 20px;
			border-top: 4px solid var(--color-accent);
			box-shadow:
				0 2px 2px var(--color-shadow-a),
				0 4px 4px var(--color-shadow-b);
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

			@media (max-width: 680px) {
				flex-direction: row;
			}

			.section-icon-card {
				align-items: center;
				background-color: var(--color-pre-primary);
				border-radius: 20px;
				border-top: 4px solid var(--color-accent);
				box-shadow:
					0 2px 2px var(--color-shadow-a),
					0 4px 4px var(--color-shadow-b);
				display: flex;
				flex-direction: column;
				flex: 1;
				height: auto;
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
