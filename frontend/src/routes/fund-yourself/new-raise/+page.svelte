<script>
	import { onMount } from 'svelte';
	import { connected, wagmiConfig } from 'svelte-wagmi';
	import { readContract, waitForTransactionReceipt, writeContract } from '@wagmi/core';
	import { formatEther, hexToNumber, parseEther } from 'viem';
	import {
		FUND_ME_ADDRESS,
		FUND_ME_EVENTS,
		FUND_ME_READS,
		FUND_ME_WRITES
	} from '$lib/contractData/FundMeContract.js';
	import abi from '$lib/contractData/abi/FundMe.json';
	import { leftArrow } from '$lib/assets';
	import { page } from '$app/stores';
	import { goto } from '$app/navigation';

	// STATE VARIABLES
	let textAreaMaxLength = 1500;
	let textAreaContent = '';
	let ethPrice = 0;
	let fundRaiseGoal = 0;

	// LIFECYCLE
	onMount(async () => {
		const ethPriceInGwei = await readContract($wagmiConfig, {
			abi,
			address: FUND_ME_ADDRESS,
			functionName: FUND_ME_READS.GET_ETH_PRICE
		});

		ethPrice = formatEther(ethPriceInGwei);
	});

	// FUNCTIONS
	async function handleSubmit(event) {
		try {
			const formData = new FormData(event.target);
			const fundRaiseTitle = formData.get('FundRaiseTitle');
			const fundRaiseGoalAmount = formData.get('FundRaiseGoalAmount');

			const txnHash = await createNewFundRaise(fundRaiseTitle, parseEther(fundRaiseGoalAmount));
			const txnReceipt = await waitForTransactionReceipt($wagmiConfig, {
				hash: txnHash
			});

			const id = hexToNumber(txnReceipt.logs[0].topics[1]);
			const description = textAreaContent;

			try {
				const response = await fetch(`${$page.url.pathname}`, {
					method: 'POST',
					body: JSON.stringify({ id, description }),
					headers: {
						'content-type': 'application/json'
					}
				});

				if (!response.ok) {
					throw new Error('Failed to add description to db');
				}

				goto('/fund-yourself');
			} catch (err) {
				console.error('Insertion to db failed', err);
			}
		} catch (err) {
			console.error('Error during form submission:', err);
		}
	}

	async function createNewFundRaise(name, goalAmount) {
		const txnHash = await writeContract($wagmiConfig, {
			abi,
			address: FUND_ME_ADDRESS,
			functionName: FUND_ME_WRITES.CREATE_FUND_RAISE,
			args: [name, goalAmount]
		});

		return txnHash;
	}

	function updateCharCounter(event) {
		textAreaContent = event.target.value;
	}
</script>

<div class="content-container">
	<h1>Create new fund raise</h1>

	<div class="form-container">
		<h2 class="h3">Fund raise details</h2>
		<form id="create-fundraise-form" on:submit|preventDefault={handleSubmit}>
			<div class="contract-inputs">
				<label
					>Name <input
						name="FundRaiseTitle"
						type="text"
						placeholder="My Fund-raise"
						required
					/></label
				>
				<label
					>Fund Raise Goal (ETH)<input
						bind:value={fundRaiseGoal}
						name="FundRaiseGoalAmount"
						type="number"
						min="0"
						step="0.01"
						placeholder="0.5 eth"
						required
					/>
					{#if fundRaiseGoal}
						<span>Value USD: ${fundRaiseGoal * ethPrice}</span>
					{/if}
				</label>
			</div>
			<label
				>Description

				<textarea
					on:input={updateCharCounter}
					name="FundRaiseDescription"
					maxlength={textAreaMaxLength}
					placeholder="I would like to raise funds for..."
					rows="10"
					required
				></textarea><span>{textAreaContent.length} / {textAreaMaxLength}</span>
			</label>
			<div class="btn-container">
				<a class="back-btn" href="/fund-yourself"
					><img src={leftArrow} alt="left-arrow-icon" />back</a
				>
				<button class="power-btn" type="submit" disabled={!$connected}>Create</button>
			</div>
		</form>
	</div>
</div>

<style scoped lang="scss">
	@import '../../../lib/styles/constants.scss';

	.content-container {
		h1 {
			padding: 2.5rem 0;
		}

		.form-container {
			background-color: $LIGHT_TEAL;
			border-radius: 8px;
			padding: 2.5rem;

			h2 {
				text-align: center;
			}

			#create-fundraise-form {
				display: flex;
				flex-direction: column;

				label {
					display: flex;
					flex-direction: column;
					font-weight: 500;
					margin-bottom: 2rem;
					position: relative;

					span {
						bottom: -1rem;
						font-size: 12px;
						right: 1rem;
						position: absolute;
						z-index: 1;
					}
				}

				input,
				textarea {
					border: 1px solid grey;
					border-radius: 8px;
					margin-top: 0.5rem;
					padding: 0.33rem 0.5rem;
				}

				textarea {
					box-sizing: border-box;
					font-size: 1rem;
					height: 350px;
					padding-bottom: 1.5rem;
					resize: none;
				}

				.contract-inputs {
					align-items: center;
					display: flex;
					gap: 3rem;
					justify-content: flex-start;
					margin-bottom: 1rem;
					margin-top: 2rem;

					label {
						flex: 1;
					}
				}

				.btn-container {
					align-items: center;
					display: flex;
					justify-content: space-between;
					margin-top: 1rem;
				}
			}
		}
	}
</style>
