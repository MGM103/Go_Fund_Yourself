<script>
	export let progress = 0; // Percentage of progress (0-100)

	// Calculate the stroke dash offset based on progress
	const radius = 50; // Radius of the circle
	const circumference = 2 * Math.PI * radius; // Circumference of the circle
	$: strokeDashoffset = circumference - (progress / 100) * circumference; // Reactive calculation
</script>

<svg width="120" height="120" viewBox="0 0 120 120">
	<!-- Group for rotation -->
	<g transform="rotate(-90 60 60)">
		<!-- Background Circle -->
		<circle cx="60" cy="60" r={radius} stroke-width="10" fill="none" class="progress-bg" />

		<!-- Progress Circle -->
		<circle
			cx="60"
			cy="60"
			r={radius}
			stroke-width="10"
			fill="none"
			class="progress"
			stroke-dasharray={circumference}
			stroke-dashoffset={strokeDashoffset}
		/>
	</g>

	<!-- Text in the middle -->
	<text x="50%" y="50%" text-anchor="middle" dy=".3em" class="progress-text">
		{progress}%
	</text>
</svg>

<style>
	.progress-bg {
		stroke: var(--color-primary); /* Background circle color */
	}

	.progress {
		stroke: var(--color-tertiary); /* Progress circle color */
		transition: stroke-dashoffset 0.5s ease; /* Animation for smooth progress */
		transform-origin: center; /* Keep transformation around the center */
	}

	.progress-text {
		font-size: 18px;
		fill: var(--color-secondary); /* Text color */
	}
</style>
