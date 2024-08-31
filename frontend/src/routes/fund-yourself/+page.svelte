<script>
	import { onMount } from 'svelte';
	import { connected, signerAddress, wagmiConfig } from 'svelte-wagmi';
	import { readContract } from '@wagmi/core';
	import { formatEther } from 'viem';
	import abi from '$lib/contractData/abi/FundMe.json';
	import { add } from '$lib/assets';
	import { goto } from '$app/navigation';
	import { DashboardTable, DisconnectedTablePlaceholder } from '$lib/components';
	import { FUND_ME_ADDRESS, FUND_ME_GETTERS } from '$lib/contractData/FundMeContract.js';

	// STATE VARIABLES
	let totalFundRaises = 0;
	let totalFunding = 0;
	let totalDonors = 0;
	let dashboardData = [];

	// DERIVED VARIABLES
	$: filteredData = dashboardData;

	// LIFE CYCLE
	onMount(async () => {
		const userFundRaises = await getUserFundRaisesIDArr();
		totalFundRaises = userFundRaises.length;

		for (let i = 0; i < userFundRaises.length; i++) {
			let id = Number(userFundRaises[i]);

			const userFundDataGetters = [
				getFundRaiseDescription(id),
				getFundRaiseGoalAmount(id),
				getFundRaiseStatus(id),
				getFundsRaised(id),
				getAllFundRaiseDonors(id)
			];

			const userFundData = await Promise.all(userFundDataGetters);

			totalFunding += Number(formatEther(userFundData[3]));
			totalDonors += userFundData[4]?.length;

			dashboardData.push({
				id,
				name: userFundData[0],
				goal: formatEther(userFundData[1]),
				active: Boolean(userFundData[2])
			});
		}

		dashboardData = dashboardData;
	});

	// FUNCTIONS
	async function getUserFundRaisesIDArr() {
		const fundRaisesIDArr = await readContract($wagmiConfig, {
			abi,
			address: FUND_ME_ADDRESS,
			functionName: FUND_ME_GETTERS.GET_CREATOR_FUND_RAISES,
			args: [$signerAddress]
		});

		return fundRaisesIDArr;
	}

	async function getFundRaiseDescription(id) {
		const description = await readContract($wagmiConfig, {
			abi,
			address: FUND_ME_ADDRESS,
			functionName: FUND_ME_GETTERS.GET_DESCRIPTION,
			args: [id]
		});

		return description;
	}

	async function getFundRaiseStatus(id) {
		const status = await readContract($wagmiConfig, {
			abi,
			address: FUND_ME_ADDRESS,
			functionName: FUND_ME_GETTERS.GET_FUND_RAISE_STATUS,
			args: [id]
		});

		return status;
	}

	async function getFundRaiseGoalAmount(id) {
		const goalAmount = readContract($wagmiConfig, {
			abi,
			address: FUND_ME_ADDRESS,
			functionName: FUND_ME_GETTERS.GET_FUND_RAISE_GOAL,
			args: [id]
		});

		return goalAmount;
	}

	async function getFundsRaised(id) {
		const fundsRaised = readContract($wagmiConfig, {
			abi,
			address: FUND_ME_ADDRESS,
			functionName: FUND_ME_GETTERS.GET_RAISED_AMOUNT,
			args: [id]
		});

		return fundsRaised;
	}

	async function getAllFundRaiseDonors(id) {
		const allDonors = readContract($wagmiConfig, {
			abi,
			address: FUND_ME_ADDRESS,
			functionName: FUND_ME_GETTERS.GET_FUND_RAISE_DONORS,
			args: [id]
		});

		return allDonors;
	}

	function handleYourRaises() {
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
	<div class="create-new-raise">
		<h1>Fund yourself</h1>
		<button class="power-btn" on:click={() => goto('/fund-yourself/new-raise')}>
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
		margin-bottom: 4rem;
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
