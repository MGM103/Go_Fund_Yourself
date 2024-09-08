<script>
	import { createEventDispatcher, onMount } from 'svelte';
	import { getBalance, readContract } from '@wagmi/core';
	import { connected, signerAddress, wagmiConfig } from 'svelte-wagmi';
	import { formatEther } from 'viem';
	import abi from '$lib/contractData/abi/FundMe.json';
	import { FUND_ME_ADDRESS, FUND_ME_READS } from '$lib/contractData/FundMeContract';

	// PROPS
	export let title;
	export let description;

	// STATE VARIABLES
	let amount = 0;
	let maxAmount;
	let minAmount;
	let modal;
	let ethPrice;

	// DERIVED VALUES
	$: amountUsd = amount * ethPrice;

	// LIFE CYCLE / EVENTS
	onMount(async () => {
		const maxAmountWei = await getBalance($wagmiConfig, {
			address: $signerAddress
		});

		maxAmount = formatEther(maxAmountWei.value);

		const ethPriceWei = await readContract($wagmiConfig, {
			abi,
			address: FUND_ME_ADDRESS,
			functionName: FUND_ME_READS.GET_ETH_PRICE
		});

		ethPrice = formatEther(ethPriceWei);

		const minDonationUsdWei = await readContract($wagmiConfig, {
			abi,
			address: FUND_ME_ADDRESS,
			functionName: FUND_ME_READS.GET_MINIMUM_DONATION_USD
		});

		const minDonationUsd = formatEther(minDonationUsdWei);

		minAmount = minDonationUsd / ethPrice;

		document.addEventListener('click', handleClickOutside);

		return () => {
			document.removeEventListener('click', handleClickOutside);
		};
	});

	const dispatch = createEventDispatcher();

	// FUNCTIONS
	function formatToCurrency(amount) {
		const formatter = new Intl.NumberFormat('en-US', {
			style: 'currency',
			currency: 'USD',
			minimumFractionDigits: 2,
			maximumFractionDigits: 2
		});

		return formatter.format(amount);
	}

	function handleClickOutside(event) {
		if (modal && !modal.contains(event.target)) {
			dispatch('closeModal');
		}
	}

	function handleMaxBalance() {
		const newAmt = parseFloat(maxAmount);
		amount = newAmt.toFixed(4);
		console.log(newAmt, amount);
	}
</script>

<div class="modal-overlay">
	<div bind:this={modal} class="modal" aria-label="donation amount modal">
		<h1 class="h2">{title}</h1>
		<p>{description}</p>
		<div class="donation-amount">
			<div class="input-group">
				<input type="number" min={minAmount} max={maxAmount} bind:value={amount} />
				<input
					type="range"
					min={minAmount}
					max={maxAmount}
					bind:value={amount}
					class="slider"
					id="myRange"
				/>
			</div>
			<div class="donation-amount-display">
				<span>{amount} eth</span>
				<p>≈ {formatToCurrency(amountUsd)} (USD)</p>
				<button class="max-btn" on:click={() => handleMaxBalance()}>max</button>
			</div>
		</div>
		<div class="btn-group">
			<button class="cancel-btn" on:click={() => dispatch('closeModal')}>cancel</button>
			<button
				class="shadow-btn"
				disabled={!$connected}
				on:click={() => dispatch('donate', { amount })}>Donate</button
			>
		</div>
	</div>
</div>

<style scoped lang="scss">
	@import '../styles/constants.scss';
	.modal {
		align-items: flex-start;
		background-color: $LIGHT_TEAL_25;
		border-radius: 8px;
		display: flex;
		flex-direction: column;
		justify-content: center;
		padding: 2rem;

		h1 {
			margin-top: 0;
		}

		.donation-amount {
			align-items: center;
			display: flex;
			gap: 2.5rem;
			justify-content: center;
			width: 100%;

			.input-group {
				display: flex;
				flex: 1;
				flex-direction: column;
				gap: 0.25rem;
			}

			.donation-amount-display {
				flex: 1;
				position: relative;

				button {
					bottom: 0.25rem;
					right: 0;
					position: absolute;
				}

				span {
					font-size: 18px;
					font-weight: 500;
				}

				p {
					font-size: 12px;
				}
			}
		}
	}

	.modal-overlay {
		position: fixed;
		top: 0;
		left: 0;
		width: 100%;
		height: 100%;
		background: rgba(0, 0, 0, 0.5); /* Dark overlay */
		display: flex;
		justify-content: center;
		align-items: center;
		z-index: 1000; /* Make sure the modal is above other content */
	}

	.btn-group {
		align-items: center;
		display: flex;
		gap: 1rem;
		justify-content: flex-start;
		padding-top: 1.5rem;
		width: 100%;
	}
</style>
