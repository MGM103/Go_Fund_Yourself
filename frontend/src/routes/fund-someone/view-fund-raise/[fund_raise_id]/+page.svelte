<script>
	import { ProgressIndicator } from '$lib/components';
	import { bronzeMedal, edit, goldMedal, leftArrow, save, silverMedal } from '$lib/assets';

	// PROPS
	export let data;
	console.log(data);

	// STATE VARIABLES
	let amountRaised = Number(data.amountRaisedEth);
	let description = data.descriptionResponse.description;
	let goalAmount = Number(data.goalAmt);
	console.log(amountRaised, goalAmount);
</script>

<div class="page-container">
	<div class="page-heading">
		<h1 id="page-title">{data.title}</h1>
		<button class="power-btn">Donate</button>
	</div>
	<div class="fund-raise-details content-container">
		<h2>Fund raise detail</h2>
		<span>Name</span>
		<p>{data.title}</p>
		<span>Status</span>
		<p>{data.active}</p>
		<span>Goal</span>
		<p>{data.goalAmt} eth</p>
		<span>Description</span>
		<p>{description}</p>
	</div>
	<div class="progress content-container">
		<h2 class="h4">Progress</h2>
		<div class="progress-info">
			<ProgressIndicator progress={(amountRaised / goalAmount) * 100} />
			<p>
				The goal for this fund raise is <span>{goalAmount} eth</span> and has currently raised
				<span>{amountRaised} eth</span>.
			</p>
		</div>
	</div>
	<div class="top-funders content-container">
		<h2 class="h4">Top funders</h2>
		{#each data.funders as funder}
			<p>{funder}</p>
		{/each}
	</div>
	<div class="all-funders content-container">
		<h2 class="h4">All funders</h2>
		{#each data.funders as funder}
			<p>{funder}</p>
		{/each}
	</div>
</div>
<a href="/fund-yourself" class="back-btn">
	<img src={leftArrow} alt="left-arrow" />
	back</a
>

<style scoped lang="scss">
	@import '../../../../lib/styles/constants.scss';
	.content-container {
		background-color: $LIGHT_TEAL;
		border-radius: 8px;
		padding: 1rem 2.5rem;
	}

	.page-container {
		column-gap: 2rem;
		display: grid;
		grid-template-columns: 1fr 1fr;
		grid-template-areas:
			'page-title page-title'
			'fund-raise-details progress'
			'fund-raise-details top-funders'
			'fund-raise-details all-funders';
		margin-bottom: 2rem;
		row-gap: 1rem;

		.page-heading {
			align-items: center;
			display: flex;
			justify-content: space-between;
			grid-area: page-title;
			padding: 2.5rem 0;
		}

		.fund-raise-details {
			grid-area: fund-raise-details;

			span {
				font-weight: 500;
			}
		}

		.progress {
			grid-area: progress;

			.progress-info {
				align-items: center;
				display: flex;
				gap: 1rem;

				p {
					flex: 2;
				}

				span {
					font-weight: 500;
				}

				svg {
					flex: 1;
				}
			}
		}

		.top-funders {
			grid-area: top-funders;
		}

		.all-funders {
			grid-area: all-funders;
		}
	}
</style>
