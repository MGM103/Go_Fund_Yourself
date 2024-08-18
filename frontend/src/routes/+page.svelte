<section class="landing-section">
	<h1>Go</h1>
	<h1>Fund</h1>
	<h1>Yourself</h1>
	<div class="call-to-action">
		<p>Harness the power of crowd-sourced fund-raising today</p>
		<button>Raise funds</button>
	</div>
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

	.landing-section {
		padding-top: 4rem;

		.call-to-action {
			display: flex;
			gap: 1rem;
		}
	}
</style>
