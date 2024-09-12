<script>
	import { onMount } from 'svelte';
	import WalletButton from '$lib/components/WalletButton.svelte';
	import { HamburgerSvg } from '$lib/assets';

	// STATE VARIABLES
	let navBar;
	let screenSize;
	let showMobileMenu = false;

	// DERIVED VARIABLES
	$: displayLinks = showMobileMenu || screenSize > 680;

	// LIFECYCLE
	onMount(() => {
		window.addEventListener('resize', updateScreenSize);
		window.addEventListener('scroll', updateNavbarShadow);
		updateScreenSize();

		return () => {
			window.removeEventListener('resize', updateScreenSize);
			window.removeEventListener('scroll', updateNavbarShadow);
		};
	});

	// FUNCTIONS
	const toggleMobileMenu = () => {
		showMobileMenu = !showMobileMenu;
	};

	const updateNavbarShadow = () => {
		const scrollTop = window.scrollY;

		if (scrollTop > 0) {
			navBar.style.setProperty('--nav-shadow', '0 -8px 24px var(--color-secondary)');
		} else {
			navBar.style.setProperty('--nav-shadow', 'none');
		}
	};

	const updateScreenSize = () => {
		screenSize = window.innerWidth;
	};
</script>

<nav bind:this={navBar}>
	<h2><a id="nav-logo" href="/">Go Fund Yourself</a></h2>
	<button id="mobile-menu-btn" on:click={toggleMobileMenu}><HamburgerSvg /></button>
	{#if displayLinks}
		<ul id="links-container">
			<li><a href="/fund-yourself">Fund yourself</a></li>
			<li><a href="/fund-someone">Fund someone</a></li>
			<WalletButton />
		</ul>
	{/if}
</nav>

<style scoped lang="scss">
	nav {
		align-items: center;
		display: flex;
		flex-direction: row;
		gap: 2.5rem;
		margin-inline: auto;
		position: sticky;
		top: 0;
		width: 100%;
		z-index: 1;

		#nav-logo {
			display: block;
			position: relative;
			width: max-content;
		}

		ul {
			align-items: center;
			display: flex;
			gap: 2rem;
			position: relative;
			width: 100%;

			@media (max-width: 680px) {
				flex-direction: column-reverse;
				gap: 1.5rem;
				padding: 0.5rem;
				position: absolute;
				right: 0;
				top: 100%;
				width: unset;

				&::before {
					background-color: var(--color-pre-primary);
					border-radius: 8px;
					border: 1px solid var(--color-tertiary);
					content: '';
					height: 80%;
					margin-top: 0.5rem;
					padding: 1rem 0.5rem;
					position: absolute;
					top: 0;
					width: 100%;
					z-index: -1;
				}
			}
		}

		a {
			color: var(--color-secondary);
			text-decoration: none;

			&:hover:not(#nav-logo) {
				transform: scale(1.025);
				transition: transform 0.1s ease;
			}
		}

		#mobile-menu-btn {
			background-color: transparent;
			border: none;
			display: none;
			z-index: 1;

			@media (max-width: 680px) {
				align-items: center;
				display: flex;
				margin-left: auto;
			}
		}

		&::before {
			content: '';
			background-color: var(--color-primary);
			box-shadow: var(--nav-shadow);
			height: 100%;
			top: 0;
			left: 50%;
			position: absolute;
			transform: translateX(-50%);
			transition: box-shadow 0.5s ease;
			width: 100vw;
			z-index: 0;
		}
	}
</style>
