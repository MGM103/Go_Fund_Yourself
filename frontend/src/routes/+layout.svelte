<script>
	import '$lib/styles/global.scss';
	import Navbar from './components/Navbar.svelte';
</script>

<Navbar />
<div id="main-content">
	<slot></slot>
</div>

<style scoped lang="scss">
	#main-content {
		max-width: 1080px;
		margin: 0 auto;
	}
</style>
