<nav>
	<div class="title-and-links">
		<h2><a id="nav-logo" href="/">Go Fund Yourself</a></h2>
		<ul>
			<li><a href="/fund-yourself">Fund yourself</a></li>
			<li><a href="/fund-someone">Fund someone</a></li>
		</ul>
	</div>

	<button class="connect-btn">Connect</button>
</nav>

<style scoped lang="scss">
	@import '../../lib/styles/constants.scss';

	nav {
		align-items: center;
		display: flex;
		flex-direction: row;
		justify-content: space-between;
		margin: 0 auto;
		max-width: 1080px;
		position: sticky;
		top: 0;
		width: 100%;
		z-index: 1;

		.title-and-links {
			align-items: center;
			display: flex;
			flex-direction: row;
			gap: 2.5rem;
			z-index: 1;

			ul {
				display: flex;
				list-style-type: none;
				margin: 0;
				padding: 0;

				li {
					margin-right: 1.75rem;
				}

				li:last-child {
					margin-right: 0;
				}
			}

			a {
				color: black;
				text-decoration: none;

				&:not(#nav-logo) {
					display: block;
				}

				&:hover:not(#nav-logo) {
					color: $DEEP_BLUE;
					transform: scale(1.025);
					transition: transform 0.1s;
				}
			}
		}

		.connect-btn {
			z-index: 1;
		}

		&::before {
			content: '';
			background-color: $LIGHT_TEAL;
			box-shadow: 0 6px 12px 0 rgba($color: #000000, $alpha: 0.1);
			height: 100%;
			top: 0;
			left: 50%;
			position: absolute;
			transform: translateX(-50%);
			width: 100vw;
			z-index: 0;
		}
	}
</style>
