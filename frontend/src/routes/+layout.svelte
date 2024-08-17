<script>
	import '$lib/styles/global.scss';
	import Footer from './components/Footer.svelte';
	import Navbar from './components/Navbar.svelte';
</script>

<Navbar />
<div id="main-content">
	<slot></slot>
</div>

<Footer />

<style scoped lang="scss">
	#main-content {
		max-width: 1080px;
		margin: 0 auto;
	}
</style>
