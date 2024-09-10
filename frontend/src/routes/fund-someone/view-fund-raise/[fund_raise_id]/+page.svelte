<script>
	import { connected, wagmiConfig } from 'svelte-wagmi';
	import { waitForTransactionReceipt, writeContract } from '@wagmi/core';
	import { parseEther } from 'viem';
	import abi from '$lib/contractData/abi/FundMe.json';
	import { FUND_ME_ADDRESS, FUND_ME_WRITES } from '$lib/contractData/FundMeContract';
	import { Modal, ProgressIndicator } from '$lib/components';
	import { bronzeMedal, goldMedal, leftArrow, silverMedal } from '$lib/assets';
	import { convertAddressToStrAbbreviated } from '$lib/utils';

	// PROPS
	export let data;

	// CONSTANTS
	const fundRaiseId = data.id;
	const medalSvgs = [goldMedal, silverMedal, bronzeMedal];
	const TOP_FUNDERS_TO_SHOW = 3;

	// STATE VARIABLES
	let amountRaised = Number(data.amountRaisedEth);
	let description = data.descriptionResponse.description;
	let goalAmount = Number(data.goalAmt);
	let funders = data.funders;
	let showModal = false;

	// FUNCTIONS
	async function donate(donationAmtEth) {
		const donationAmtWei = parseEther(donationAmtEth);
		console.log(donationAmtWei);
		const result = await writeContract($wagmiConfig, {
			abi,
			address: FUND_ME_ADDRESS,
			functionName: FUND_ME_WRITES.DONATE,
			args: [BigInt(fundRaiseId)],
			value: donationAmtWei
		});

		console.log(result);
		return result;
	}

	async function handleDonation(event) {
		console.log(`Amount received: ${event.detail.amount}`);
		const donationAmt = event.detail.amount?.toString();
		const txnReceipt = await donate(donationAmt);
		handleModalClose();
		await waitForTransactionReceipt($wagmiConfig, {
			hash: txnReceipt
		});
		location.reload();
	}

	function handleModalClose() {
		showModal = false;
	}

	function getTopFunders() {
		const topRange = Math.min(funders?.length, TOP_FUNDERS_TO_SHOW);

		return funders.slice(0, topRange);
	}
</script>

{#if showModal}
	<Modal
		title={'Donation Amount'}
		description={'Please select the amount you would like to donate:'}
		on:closeModal={handleModalClose}
		on:donate={handleDonation}
	/>
{/if}
<div class="page-container">
	<div class="page-heading">
		<h1 id="page-title">{data.title}</h1>
		<button class="power-btn" on:click={() => (showModal = true)} disabled={!$connected}
			>Donate</button
		>
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
		<div class="description-block">
			<p>{description}</p>
		</div>
	</div>
	<div class="progress content-container">
		<h2 class="h4">Progress</h2>
		<div class="progress-info">
			<ProgressIndicator progress={((amountRaised / goalAmount) * 100).toFixed(0)} />
			<p>
				The goal for this fund raise is <span>{goalAmount} eth</span> and has currently raised
				<span>{amountRaised} eth</span>.
			</p>
		</div>
	</div>
	<div class="top-funders content-container">
		<h2 class="h4">Top funders</h2>
		{#each getTopFunders() as funder, index}
			<div class="top-funder">
				<img src={medalSvgs[index]} alt={`Medal icon position ${index}`} />
				<p>{convertAddressToStrAbbreviated(funder, 7, 7)}</p>
			</div>
		{/each}
	</div>
	<div class="all-funders content-container">
		<h2 class="h4">All funders</h2>
		<div class="all-funders-list">
			{#each data.funders as funder}
				<p>{funder}</p>
			{/each}
		</div>
	</div>
</div>
<a href="/fund-someone" class="back-btn">
	<img src={leftArrow} alt="left-arrow" />
	back</a
>

<style scoped lang="scss">
	.content-container {
		background-color: var(--color-primary);
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
			grid-area: page-title;
			justify-content: space-between;
			padding-bottom: 1.5rem;
			padding-top: 2.5rem;
		}

		.fund-raise-details {
			grid-area: fund-raise-details;
			overflow: hidden;
			word-wrap: break-word;

			span {
				font-weight: 500;
			}

			.description-block {
				max-height: 300px;
				overflow-y: auto;
				padding-right: 2rem;
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

			.top-funder {
				align-items: center;
				display: flex;
				gap: 1rem;
				justify-items: flex-start;

				img {
					max-height: 1.5rem;
					max-width: 1.5rem;
				}
			}
		}

		.all-funders {
			grid-area: all-funders;

			.all-funders-list {
				max-height: 150px;
				overflow-y: auto;
				padding-right: 1rem;
			}
		}
	}

	.back-btn {
		width: max-content;
	}
</style>
