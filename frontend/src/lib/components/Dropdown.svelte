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
	@import '../styles/constants.scss';

	select {
		background-color: transparent;
		border: 1px solid $DEEP_BLUE_25;
		border-radius: 8px;
		padding: 6px 12px;
	}
</style>
