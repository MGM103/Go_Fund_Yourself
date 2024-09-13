<script>
	import { onMount } from 'svelte';
	import { connected, signerAddress, wagmiConfig } from 'svelte-wagmi';
	import { readContract } from '@wagmi/core';
	import { formatEther } from 'viem';
	import abi from '$lib/contractData/abi/FundMe.json';
	import { AddSvg } from '$lib/assets';
	import { goto } from '$app/navigation';
	import { DashboardTable, DisconnectedTablePlaceholder } from '$lib/components';
	import { FUND_ME_ADDRESS, FUND_ME_READS } from '$lib/contractData/FundMeContract.js';

	// STATE VARIABLES
	let totalFundRaises = 0;
	let totalFunding = 0;
	let totalDonors = 0;
	let dashboardData = [];
	const navigationUrl = '/fund-yourself/view-fund-raise/';

	// DERIVED VARIABLES
	$: filteredData = dashboardData;

	// LIFE CYCLE
	onMount(async () => {
		if ($connected) {
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
					active: userFundData[2],
					url: navigationUrl
				});
			}

			dashboardData = dashboardData;
			totalFunding = totalFunding.toFixed(2);
		}
	});

	// FUNCTIONS
	async function getUserFundRaisesIDArr() {
		const fundRaisesIDArr = await readContract($wagmiConfig, {
			abi,
			address: FUND_ME_ADDRESS,
			functionName: FUND_ME_READS.GET_CREATOR_FUND_RAISES,
			args: [$signerAddress]
		});

		return fundRaisesIDArr;
	}

	async function getFundRaiseDescription(id) {
		const description = await readContract($wagmiConfig, {
			abi,
			address: FUND_ME_ADDRESS,
			functionName: FUND_ME_READS.GET_DESCRIPTION,
			args: [id]
		});

		return description;
	}

	async function getFundRaiseStatus(id) {
		const status = await readContract($wagmiConfig, {
			abi,
			address: FUND_ME_ADDRESS,
			functionName: FUND_ME_READS.GET_FUND_RAISE_STATUS,
			args: [id]
		});

		return status;
	}

	async function getFundRaiseGoalAmount(id) {
		const goalAmount = readContract($wagmiConfig, {
			abi,
			address: FUND_ME_ADDRESS,
			functionName: FUND_ME_READS.GET_FUND_RAISE_GOAL,
			args: [id]
		});

		return goalAmount;
	}

	async function getFundsRaised(id) {
		const fundsRaised = readContract($wagmiConfig, {
			abi,
			address: FUND_ME_ADDRESS,
			functionName: FUND_ME_READS.GET_RAISED_AMOUNT,
			args: [id]
		});

		return fundsRaised;
	}

	async function getAllFundRaiseDonors(id) {
		const allDonors = readContract($wagmiConfig, {
			abi,
			address: FUND_ME_ADDRESS,
			functionName: FUND_ME_READS.GET_FUND_RAISE_DONORS,
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

<div class="page-container">
	<div class="create-new-raise">
		<h1>Fund yourself</h1>
		<button class="power-btn" on:click={() => goto('/fund-yourself/new-raise')}>
			<AddSvg />
			<span>New fund raise</span></button
		>
	</div>

	<div class="fund-raise-analytics">
		<div class="analytic">
			<h2>{totalFundRaises}</h2>
			<p id="label">Total fund raises</p>
			<p id="mobile-label"># raises:</p>
		</div>
		<div class="analytic">
			<h2>{totalFunding} eth</h2>
			<p id="label">Total funding received</p>
			<p id="mobile-label">Funding:</p>
		</div>
		<div class="analytic">
			<h2>{totalDonors}</h2>
			<p id="label">Total donors</p>
			<p id="mobile-label"># donors:</p>
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
	.page-container {
		display: grid;
		grid-template-rows: 0.5fr 1fr auto;
		gap: 4rem;
		height: 100%;

		@media (max-width: 680px) {
			gap: 2rem;
		}
	}

	.create-new-raise {
		align-items: center;
		display: flex;
		justify-content: space-between;
		padding-top: 2.5rem;

		@media (max-width: 680px) {
			span {
				display: none;
			}
		}
	}

	.fund-raise-analytics {
		align-items: center;
		background-color: var(--color-pre-primary);
		border-radius: 12px;
		border-top: 4px solid var(--color-tertiary);
		box-shadow:
			0 2px 2px var(--color-shadow-a),
			0 4px 4px var(--color-shadow-b);
		display: flex;
		justify-content: space-between;
		padding: 2rem;

		@media (max-width: 680px) {
			flex-direction: column;
		}

		.analytic {
			align-items: center;
			border-right: 1px solid var(--color-secondary);
			display: flex;
			flex-direction: column;
			flex: 1;
			justify-content: center;
			word-wrap: break-word;

			#mobile-label {
				display: none;
			}

			&:last-child {
				border-right: none;
			}

			@media (max-width: 680px) {
				border-right: none;
				flex-direction: row-reverse;
				gap: 1rem;
				justify-content: flex-start;

				#label {
					display: none;
				}

				#mobile-label {
					display: unset;
				}
			}
		}
	}
</style>
