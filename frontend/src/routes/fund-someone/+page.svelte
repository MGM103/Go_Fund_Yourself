<script>
	import { goto } from '$app/navigation';
	import { connected } from 'svelte-wagmi';
	import { DashboardTable, DisconnectedTablePlaceholder } from '$lib/components';
	import mockFunds from '$lib/mocks/mockFunds.js';

	// PROPS
	export let data;

	// STATE VARIABLES
	let dashboardData = data.fundRaises;
	let filteredData = data.fundRaises;

	// FUNCTIONS
	function handleAllRaises() {
		filteredData = dashboardData;
	}

	function handleActiveRaises() {
		filteredData = dashboardData.filter((fund) => {
			return fund.active;
		});
	}

	function handleCompletedRaises() {
		filteredData = dashboardData.filter((fund) => {
			return !fund.active;
		});
	}
</script>

<div>
	<div class="page-title">
		<h1>Fund someone</h1>
	</div>

	{#if $connected}
		<DashboardTable
			tableTitle={'Fund raises'}
			tableTabs={['All raises', 'Active', 'Completed']}
			tableData={filteredData}
			on:allRaises={handleAllRaises}
			on:active={handleActiveRaises}
			on:completed={handleCompletedRaises}
		/>
	{:else}
		<DisconnectedTablePlaceholder />
	{/if}
</div>

<style scoped lang="scss">
	@import '../../lib/styles/constants.scss';

	.page-title {
		padding-bottom: 1rem;
		padding-top: 2.5rem;
	}
</style>
