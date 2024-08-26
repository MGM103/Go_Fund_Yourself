<script>
	import { goto } from '$app/navigation';
	import { connected } from 'svelte-wagmi';
	import { DashboardTable, DisconnectedTablePlaceholder } from '$lib/components';
	import mockFunds from '$lib/mocks/mockFunds.js';

	// STATE VARIABLES
	let filteredData = mockFunds;

	// FUNCTIONS
	function handleAllRaises() {
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
