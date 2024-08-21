<script>
	import { onMount } from 'svelte';

	// PROPS
	export let revealThreshold;

	// STATE VARIABLES
	let isVisible = false;
	let element;

	// LIFE-CYCLE LOGIC
	onMount(() => {
		// create observer for section
		const observer = new IntersectionObserver(
			(entries) => {
				const [entry] = entries;
				isVisible = entry.isIntersecting;
			},
			{
				root: null,
				rootMargin: '10px',
				threshold: revealThreshold
			}
		);

		observer.observe(element);

		return () => {
			observer.unobserve(element);
		};
	});
</script>

<section bind:this={element} class="home-content-section">
	{#if isVisible}
		<slot></slot>
	{/if}
</section>

<style scoped lang="scss">
	section {
		display: flex;
		flex-direction: column;
		height: 50vh;
		margin: 4rem 0;
		position: relative;
	}
</style>
