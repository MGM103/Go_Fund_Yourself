<footer id="site-footer">
	<section id="top-row">
		<h2 class="h3">Go Fund Yourself</h2>
	</section>
	<section id="bottom-row">
		<div id="funding-option">
			<h3 class="h6">Funding options</h3>
			<ul>
				<li><a href="/fund-yourself">Start you own fund raise</a></li>
				<li><a href="/fund-someone">Support another cause</a></li>
			</ul>
		</div>
		<div id="about-creator">
			<h3 class="h6">About the creator</h3>
			<ul>
				<li>
					<a href="https://github.com/MGM103?tab=overview&from=2024-08-01&to=2024-08-15"
						>Portfolio</a
					>
				</li>
				<li><a href="/">Website (coming soon!)</a></li>
			</ul>
		</div>
	</section>
</footer>

<style scoped lang="scss">
	#site-footer {
		color: var(--color-primary);
		display: flex;
		flex-direction: column;
		margin: 0 auto;
		max-width: 1080px;
		padding-top: 2.5rem;
		padding-bottom: 2.5rem;
		position: sticky;
		top: 100vh;

		#bottom-row {
			display: flex;
			flex-direction: row;
			gap: 4rem;
		}

		ul {
			list-style-type: none;
			margin: 0;
			padding: 0;
		}

		li {
			margin-bottom: 0.25rem;
		}
		a {
			color: var(--color-primary);
			text-decoration: none;

			&:hover {
				color: var(--color-secondary);
			}
		}

		&::before {
			content: '';
			background-color: var(--color-secondary);
			height: 100%;
			left: 50%;
			position: absolute;
			top: 0;
			transform: translateX(-50%);
			width: 100vw;
			z-index: -1;
		}
	}
</style>
