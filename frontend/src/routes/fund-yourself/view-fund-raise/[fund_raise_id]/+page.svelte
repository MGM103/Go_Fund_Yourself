<script>
	import { formatEther } from 'viem';

	//PROPS
	export let data;

	// STATE VARIABLES
	let amountRaised = formatEther(data.amountRaised);
	let funders = data.funders;
	const TOP_FUNDERS_TO_SHOW = 3;

	// FUNCTIONS
	function getTopFunders() {
		const topRange = Math.min(funders?.length, TOP_FUNDERS_TO_SHOW);

		return funders.slice(0, topRange);
	}
</script>

<div class="page-container">
	<div class="header-section">
		<h1>{data.title}</h1>
		<button class="power-btn"> Withdraw</button>
	</div>
	<div class="fund-raise-details">
		<div class="fund-raise-form">
			<h2>Fund raise details</h2>
			<span>Name</span>
			<p>{data.title}</p>
			<span>Goal</span>
			<p>{data.goalAmt} eth</p>
			<span>Description</span>
			<p>{data.descriptionResponse.description}</p>
		</div>
		<div class="fund-raise-analytics">
			<div class="raise-statistics">
				<h2 class="h4">Progress</h2>
				<progress id="fundRaiseProgress" value={amountRaised} max={data.goalAmt}></progress>
				<p>{amountRaised} / {data.goalAmt} eth</p>
			</div>
			<div class="top-funders">
				<h2 class="h4">Top funders</h2>
				{#each getTopFunders() as topFunder}
					<p>{topFunder}</p>
				{/each}
			</div>
			<div class="all-funders">
				<h2 class="h4">All funders</h2>
				{#each data.funders as funder}
					<p>{funder}</p>
				{/each}
			</div>
		</div>
	</div>
</div>

<style scoped lang="scss">
	@import '../../../../lib/styles/constants.scss';
	.page-container {
		.header-section {
			align-items: center;
			display: flex;
			flex-direction: row;
			justify-content: space-between;
			padding: 2.5rem 0;
		}

		.fund-raise-details {
			display: flex;
			gap: 2rem;

			.fund-raise-form {
				background-color: $LIGHT_TEAL;
				border-radius: 8px;
				display: flex;
				flex-direction: column;
				flex: 2;
				padding: 1rem 2.5rem;

				span {
					font-weight: 500;
				}

				p {
					margin-top: 0.5rem;
				}
			}

			.fund-raise-analytics {
				display: flex;
				flex-direction: column;
				flex: 1;
				gap: 1rem;

				.raise-statistics {
					background-color: $LIGHT_TEAL;
					border-radius: 8px;
					padding: 1rem 2.5rem;
				}

				.top-funders {
					background-color: $LIGHT_TEAL;
					border-radius: 8px;
					padding: 1rem 2.5rem;
				}

				.all-funders {
					background-color: $LIGHT_TEAL;
					border-radius: 8px;
					padding: 1rem 2.5rem;
				}
			}
		}
	}
</style>
