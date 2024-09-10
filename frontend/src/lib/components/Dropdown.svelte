<script>
	import { createEventDispatcher } from 'svelte';

	// PROPS
	export let selectOptions;
	export let labelText = '';
	export let disabled = false;
	export let defaultValue = selectOptions[0].value;

	// STATE VARIABLES
	let selectedItem = defaultValue;

	// EVENTS
	const dispatch = createEventDispatcher();

	// FUNCTIONS
	const updateDropdownVal = () => {
		dispatch('newVal', selectedItem);
	};
</script>

<label>
	{labelText}
	<select
		bind:value={selectedItem}
		on:change={updateDropdownVal}
		{disabled}
		aria-label="Select Item"
	>
		{#each selectOptions as selectOption}
			<option value={selectOption.value}>{selectOption.name}</option>
		{/each}
	</select>
</label>

<style scoped lang="scss">
	label {
		align-items: center;
		display: flex;
		gap: 0.75rem;
		justify-content: center;
	}

	select {
		background-color: transparent;
		border: 1px solid var(--color-tertiary);
		border-radius: 8px;
		color: var(--color-secondary);
		padding: 6px 12px;
	}
</style>
