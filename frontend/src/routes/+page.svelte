<script>
	import { fade } from 'svelte/transition';
	import { onMount } from 'svelte';
	import { goto } from '$app/navigation';

	// STATE VARIABLES
	let visible = false;

	// LIFECYCLE FUNCTIONS
	onMount(() => {
		visible = true;
	});

	// UTILITY FUNCTIONS
	function typewriter(node, { delay = 0, speed = 2 }) {
		const valid = node.childNodes.length === 1 && node.childNodes[0].nodeType === Node.TEXT_NODE;

		if (!valid) {
			throw new Error(`This transition only works on elements with a single text node child`);
		}

		const text = node.textContent;
		const duration = text.length / (speed * 0.01);

		return {
			delay,
			duration,
			tick: (t) => {
				const i = Math.trunc(text.length * t);
				node.textContent = text.slice(0, i);
			}
		};
	}
</script>

<section class="landing-section">
	{#if visible}
		<h1 in:fade={{ duration: 3000, delay: 100 }}>Go</h1>
		<h1 in:fade={{ duration: 3000, delay: 800 }}>Fund</h1>
		<h1 in:fade={{ duration: 3000, delay: 1500 }}>Yourself</h1>
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
<section class="fund-yourself-description">
	<h2>Raise funds for a special cause</h2>
</section>
<section class="fund-someone-description">
	<h2>Donate to initiatives around the world</h2>
</section>

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
