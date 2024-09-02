<script>
	import { createEventDispatcher } from 'svelte';
	import { leftArrow, rightArrow } from '$lib/assets';
	import { toCamelCase } from '$lib/utils';
	import Dropdown from './Dropdown.svelte';

	// PROPS
	export let tableTitle;
	export let tableTabs;
	export let tableData;

	// STATE VARIABLES
	let activeTab = 0;
	let currentPage = 0;
	let pageSize = 5;
	let pageSizeOptions = [
		{ name: '5', value: 5 },
		{ name: '10', value: 10 }
	];
	let table;

	// EVENTS / LIFECYCLE
	const dispatch = createEventDispatcher();

	// DERIVED VARIABLES
	$: filteredData = tableData.slice(currentPage * pageSize, currentPage * pageSize + pageSize);
	$: nextBtnDisabled = currentPage + 1 >= Math.ceil(tableData.length / pageSize);
	$: prevBtnDisabled = currentPage <= 0;

	// REACTIVE FUNCTIONALITY
	$: {
		if (tableData && table) {
			adjustTableMinHeight();
		}
	}

	// FUNCTIONS
	function adjustTableMinHeight() {
		const fundHeight = table.querySelector('.fund')?.offsetHeight;
		if (fundHeight) {
			table.style.minHeight = `${(fundHeight + pageSize) * pageSize}px`;
		}
	}

	function updateActiveTab(tabIndex) {
		if (tabIndex <= tableTabs?.length) {
			activeTab = tabIndex;
		}
	}

	function updateTablePage(newPageNumber = currentPage + 1) {
		currentPage = newPageNumber;
	}

	function updateTablePageSize(event) {
		pageSize = event.detail;
	}
</script>

<div class="table-container">
	<h2>{tableTitle}</h2>
	<div class="table-top-row">
		<div class="filter-btns">
			{#each tableTabs as tab, index}
				<button
					class="table-filter-btn"
					class:active={activeTab === index}
					on:click={() => {
						updateActiveTab(index);
						dispatch(toCamelCase(tab), {});
					}}>{tab}</button
				>
			{/each}
		</div>
		<Dropdown selectOptions={pageSizeOptions} on:newVal={updateTablePageSize} />
	</div>
	<div bind:this={table} class="dashboard-table">
		{#each filteredData as fundRaise}
			<div class="fund">
				<h3>{fundRaise.name}</h3>
				<div class="details">
					<p>{fundRaise.goal} eth</p>
					<p>{fundRaise.active ? 'Active' : 'Completed'}</p>
				</div>
			</div>
		{/each}
	</div>
	<div class="pagination-btns">
		<button
			class="pagination-btn"
			on:click={() => updateTablePage(currentPage - 1)}
			disabled={prevBtnDisabled}
		>
			<img src={leftArrow} alt="left-arrow-icon" />
			Prev</button
		>
		<button class="pagination-btn" on:click={() => updateTablePage()} disabled={nextBtnDisabled}>
			Next
			<img src={rightArrow} alt="right-arrow-icon" />
		</button>
	</div>
</div>

<style scoped lang="scss">
	@import '../styles/constants.scss';

	.table-container {
		h2 {
			margin-top: 1rem;
		}

		.table-top-row {
			align-items: center;
			display: flex;
			justify-content: space-between;

			.filter-btns {
				display: flex;
				gap: 1rem;

				.active {
					border-bottom: 2px solid $TEAL_50;
					margin-bottom: -2px;
				}
			}
		}

		.dashboard-table {
			display: flex;
			flex-direction: column;
			gap: 0.25rem;
			padding: 1rem 0;

			.fund {
				align-items: center;
				box-sizing: border-box;
				border-radius: 8px;
				border: 2px solid transparent; /* Adjust border size as necessary */
				box-shadow: 0px 0px 4px #00000015;
				cursor: pointer;
				display: flex;
				justify-content: space-between;
				padding: 1rem;

				h3 {
					margin-right: auto;
				}

				&:hover {
					background:
						linear-gradient($LIGHT_TEAL_10, $LIGHT_TEAL_10) padding-box,
						linear-gradient(0deg, $BLUE 0%, $BLUE 100%) border-box;
					border-radius: 8px;
				}

				.details {
					display: flex;
					gap: 1rem;

					p {
						min-width: 100px;
						text-align: center;
					}
				}
			}
		}
		.pagination-btns {
			align-items: center;
			display: flex;
			justify-content: space-between;
			padding: 1rem;
		}
	}
</style>
