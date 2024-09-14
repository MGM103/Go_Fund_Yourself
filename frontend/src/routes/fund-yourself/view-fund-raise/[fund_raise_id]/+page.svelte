<script>
	import { connected, wagmiConfig } from 'svelte-wagmi';
	import { writeContract } from '@wagmi/core';
	import { formatEther } from 'viem';
	import { FUND_ME_ADDRESS, FUND_ME_WRITES } from '$lib/contractData/FundMeContract';
	import abi from '$lib/contractData/abi/FundMe.json';
	import { enhance } from '$app/forms';
	import { goto } from '$app/navigation';
	import { ProgressIndicator } from '$lib/components';
	import { bronzeMedal, EditSvg, goldMedal, LeftArrowSvg, SaveSvg, silverMedal } from '$lib/assets';
	import { convertAddressToStrAbbreviated } from '$lib/utils';

	//PROPS
	export let data;

	// CONSTANTS
	const fundRaiseId = data.id;
	const TOP_FUNDERS_TO_SHOW = 3;
	const DESCRIPTION_MAX_LENGTH = 1500;
	const medalSvgs = [goldMedal, silverMedal, bronzeMedal];

	// STATE VARIABLES
	let amountRaised = formatEther(data.amountRaised);
	let funders = data.funders;
	let description = data.descriptionResponse.description
		? data.descriptionResponse.description
		: '';

	// DERIVED VARIABLES
	$: descriptionInputEnabled = !description;
	$: isActive = JSON.parse(data.active);

	// FUNCTIONS
	function getTopFunders() {
		const topRange = Math.min(funders?.length, TOP_FUNDERS_TO_SHOW);

		return funders.slice(0, topRange);
	}

	async function handleDescriptionUpdate({ result, update }) {
		if (result.type === 'success') {
			description = result.data.newDescription;
		} else {
			console.error('Form submission failed:', result);
		}
		// Update form state without losing the URL
		await update();
	}

	async function handleWithdraw(id) {
		await withdrawFundRaiseFunds(id);
		goto('/fund-yourself');
	}

	async function withdrawFundRaiseFunds(id) {
		const result = await writeContract($wagmiConfig, {
			abi,
			address: FUND_ME_ADDRESS,
			functionName: FUND_ME_WRITES.WITHDRAW_FUNDS,
			args: [BigInt(id)]
		});

		console.log(result);
	}
</script>

<div class="page-container">
	<div class="header-section">
		<h1>{data.title}</h1>
		{#if isActive}
			<button on:click={() => handleWithdraw(fundRaiseId)} class="power-btn" disabled={!$connected}>
				Withdraw</button
			>
		{/if}
	</div>
	<div class="fund-raise-details">
		<div class="fund-raise-form">
			<h2>Fund raise details</h2>
			<span>Name</span>
			<p>{data.title}</p>
			<span>Status</span>
			<p>{isActive ? 'Active' : 'Completed'}</p>
			<span>Goal</span>
			<p>{data.goalAmt} eth</p>
			<form
				id="update-description"
				method="POST"
				action="?/updateFundRaiseDescription"
				use:enhance={() => handleDescriptionUpdate}
			>
				{#if descriptionInputEnabled}
					<button type="submit"><SaveSvg /></button>
				{:else}
					<button
						type="button"
						on:click={() => (descriptionInputEnabled = !descriptionInputEnabled)}
						><EditSvg /></button
					>
				{/if}
				<label
					>Description

					<textarea
						name="fundRaiseDescription"
						value={description}
						placeholder="Enter in a description for you fund raise here..."
						maxlength={DESCRIPTION_MAX_LENGTH}
						disabled={!descriptionInputEnabled}
					></textarea>
				</label>
			</form>
		</div>
		<div class="fund-raise-analytics">
			<div class="raise-statistics">
				<h2 class="h4">Progress</h2>
				<div class="progress-info">
					<ProgressIndicator progress={(amountRaised / data.goalAmt) * 100} />
					<p id="progress-description">
						Your goal was to raise <span>{data.goalAmt} eth</span> and you have currently raised
						<span>{amountRaised} eth</span>.
					</p>
				</div>
			</div>
			<div class="top-funders">
				<h2 class="h4">Top funders</h2>
				{#each getTopFunders() as topFunder, index}
					<div class="top-funder">
						<img src={medalSvgs[index]} alt={`medal-position-${index}`} />
						<p>{convertAddressToStrAbbreviated(topFunder, 7, 7)}</p>
					</div>
				{/each}
			</div>
			<div class="all-funders">
				<h2 class="h4">All funders</h2>
				<div class="funder-addrs">
					{#each data.funders as funder}
						<p id="addr">{funder}</p>
						<p id="mobile-addr">{convertAddressToStrAbbreviated(funder, 7, 7)}</p>
					{/each}
				</div>
			</div>
		</div>
	</div>
	<a href="/fund-yourself" class="back-btn">
		<LeftArrowSvg />
		back</a
	>
</div>

<style scoped lang="scss">
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
			flex-wrap: wrap;
			gap: 2rem;

			.fund-raise-form {
				background-color: var(--color-pre-primary);
				border-radius: 8px;
				box-shadow: 0 0px 2px var(--color-shadow-a);
				display: flex;
				flex-direction: column;
				flex-grow: 2;
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

				h2 {
					text-align: center;
				}

				.raise-statistics {
					background-color: var(--color-pre-primary);
					border-radius: 8px;
					box-shadow: 0 0px 2px var(--color-shadow-a);
					padding: 1rem 2.5rem;

					.progress-info {
						align-items: flex-start;
						display: flex;
						gap: 2rem;

						span {
							font-weight: 500;
						}

						svg {
							flex: 1;
						}

						p {
							flex: 2;
						}

						@media (max-width: 400px) {
							align-items: center;
							justify-content: center;
							#progress-description {
								display: none;
							}
						}
					}
				}

				.top-funders {
					background-color: var(--color-pre-primary);
					border-radius: 8px;
					box-shadow: 0 0px 2px var(--color-shadow-a);
					padding: 1rem 2.5rem;

					.top-funder {
						align-items: center;
						display: flex;
						gap: 1rem;

						img,
						svg {
							max-height: 1.5rem;
							max-width: 1.5rem;
						}
					}
				}

				.all-funders {
					background-color: var(--color-pre-primary);
					border-radius: 8px;
					box-shadow: 0 0px 2px var(--color-shadow-a);
					padding: 1rem 2.5rem;

					.funder-addrs {
						max-height: 150px;
						overflow-y: auto;
						padding-right: 1rem;

						#mobile-addr {
							display: none;
						}

						@media (max-width: 580px) {
							#mobile-addr {
								display: unset;
								line-height: 1.5rem;
							}

							#addr {
								display: none;
							}
						}
					}
				}
			}
		}

		.back-btn {
			margin: 1rem 0;
			width: fit-content;
		}
	}

	#update-description {
		display: flex;
		flex-direction: column;
		position: relative;

		label {
			display: flex;
			flex-direction: column;
			font-weight: 500;

			textarea {
				background-color: var(--color-surface-1);
				border-radius: 8px;
				border: 1px solid var(--color-primary);
				box-sizing: border-box;
				color: var(--color-secondary);
				font-size: 0.9rem;
				height: 300px;
				margin: 1rem 0;
				padding-bottom: 1.5rem;
				padding: 0.33rem 0.5rem;
				resize: none;

				&:disabled {
					color: var(--color-disabled);
				}
			}
		}

		button {
			background-color: transparent;
			border: 1px solid transparent;
			cursor: pointer;
			padding: 0.25rem;
			position: absolute;
			right: 0;
			top: 0;

			&:hover {
				border-radius: 8px;
				border: 1px solid var(--color-secondary);
			}

			img,
			svg {
				max-height: 1.25rem;
				max-width: 1.25rem;
			}
		}
	}
</style>
