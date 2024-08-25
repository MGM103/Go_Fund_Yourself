<script>
	import { add } from '$lib/assets';
	import { goto } from '$app/navigation';
	import { connected } from 'svelte-wagmi';
	import { DashboardTable, DisconnectedTablePlaceholder } from '$lib/components';
	import mockFunds from '$lib/mocks/mockFunds.js';

	// STATE VARIABLES
	let totalFundRaises = 0;
	let totalFunding = 0;
	let totalDonors = 0;
	let filteredData = mockFunds;

	// FUNCTIONS
	function handleYourRaises() {
		filteredData = mockFunds;
	}

	function handleActiveRaises() {
		filteredData = mockFunds.filter((fund) => {
			return fund.active;
		});
	}

	function handleCompletedRaises() {
		filteredData = mockFunds.filter((fund) => {
			return !fund.active;
		});
	}
</script>

<div>
	<div class="create-new-raise">
		<h1>Fund yourself</h1>
		<button class="power-btn" on:click={() => goto('/create-fund-raise')}>
			<img src={add} alt="add-icon" />
			New fund raise</button
		>
	</div>

	<div class="fund-raise-analytics">
		<div class="analytic">
			<h2>{totalFundRaises}</h2>
			<p>Total fund raises</p>
		</div>
		<div class="analytic">
			<h2>{totalFunding}</h2>
			<p>Total funding received</p>
		</div>
		<div class="analytic">
			<h2>{totalDonors}</h2>
			<p>Total donors</p>
		</div>
	</div>

	{#if $connected}
		<DashboardTable
			tableTitle={'Your fund raises'}
			tableTabs={['Your raises', 'Active', 'Completed']}
			tableData={filteredData}
			on:yourRaises={handleYourRaises}
			on:active={handleActiveRaises}
			on:completed={handleCompletedRaises}
		/>
	{:else}
		<DisconnectedTablePlaceholder />
	{/if}
</div>

<style scoped lang="scss">
	@import '../../lib/styles/constants.scss';

	.create-new-raise {
		align-items: center;
		display: flex;
		justify-content: space-between;
		padding: 2.5rem 0;
	}

	.fund-raise-analytics {
		align-items: center;
		border-radius: 12px;
		border-top: 4px solid $TEAL_25;
		box-shadow: 0 8px 8px #00000015;
		display: flex;
		justify-content: space-between;
		padding: 2rem;

		.analytic {
			align-items: center;
			border-right: 1px solid $DEEP_BLUE_25;
			display: flex;
			flex-direction: column;
			flex: 1;
			justify-content: center;

			&:last-child {
				border-right: none;
			}
		}
	}
</style>
