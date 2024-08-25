<script>
	import { createEventDispatcher } from 'svelte';
	import { leftArrow, rightArrow } from '$lib/assets';
	import { toCamelCase } from '$lib/utils';

	// PROPS
	export let tableTitle;
	export let tableTabs;
	export let tableData;

	// STATE VARIABLES
	let activeTab = 0;
	let currentPage = 0;
	let pageSize = 5;

	// EVENTS
	const dispatch = createEventDispatcher();

	// DERIVED VARIABLES
	$: filteredData = tableData.slice(currentPage * pageSize, currentPage * pageSize + pageSize);
	$: nextBtnDisabled = currentPage + 1 >= Math.ceil(tableData.length / pageSize);
	$: prevBtnDisabled = currentPage <= 0;

	// FUNCTIONS
	function updateActiveTab(tabIndex) {
		if (tabIndex <= tableTabs?.length) {
			activeTab = tabIndex;
		}
	}

	function updateTablePage(newPageNumber = currentPage + 1) {
		currentPage = newPageNumber;
	}
</script>

<div class="table-container">
	<h2>{tableTitle}</h2>
	<div class="filter-btns">
		{#each tableTabs as tab, index}
			<button
				class="table-filter-btn"
				class:active={activeTab === index}
				on:click={() => {
					updateActiveTab(index);
					dispatch(toCamelCase(tab), {});
					console.log(toCamelCase(tab));
				}}>{tab}</button
			>
		{/each}
	</div>
	<div class="dashboard-table">
		{#each filteredData as fundRaise}
			<div class="fund">
				<h3>{fundRaise.name}</h3>
				<div class="details">
					<p>{fundRaise.goal} eth</p>
					<p>{fundRaise.active ? 'Active' : 'Completed'}</p>
				</div>
			</div>
		{/each}
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
</div>

<style scoped lang="scss">
	@import '../styles/constants.scss';

	.table-container {
		padding: 2.5rem 0;

		.filter-btns {
			display: flex;
			gap: 1rem;

			.active {
				border-bottom: 2px solid $TEAL_50;
				margin-bottom: -2px;
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

			.pagination-btns {
				align-items: center;
				display: flex;
				justify-content: space-between;
				padding: 1rem;
			}
		}
	}
</style>
