<script>
	import { leftArrow } from '$lib/assets';

	// STATE VARIABLES
	let textAreaMaxLength = 1500;
	let textAreaMaxContent = '';

	// FUNCTIONS
	function updateCharCounter(event) {
		textAreaMaxContent = event.target.value;
	}
</script>

<div class="content-container">
	<h1>Create new fund raise</h1>

	<div class="form-container">
		<h2 class="h3">Fund raise details</h2>
		<form id="create-fundraise-form">
			<label
				>Name <input
					name="FundRaiseTitle"
					type="text"
					placeholder="My Fund-raise"
					required
				/></label
			>
			<label
				>Fund Raise Goal <input
					name="FundRaiseDescription"
					type="number"
					min="0"
					step="0.01"
					placeholder="0.5 eth"
					required
				/></label
			>
			<label
				>Description

				<textarea
					on:input={updateCharCounter}
					maxlength={textAreaMaxLength}
					placeholder="I would like to raise funds for..."
					rows="10"
					required
				></textarea><span>{textAreaMaxContent.length} / {textAreaMaxLength}</span>
			</label>
			<div class="btn-container">
				<a class="back-btn" href="/fund-yourself"
					><img src={leftArrow} alt="left-arrow-icon" />back</a
				>
				<button class="power-btn">Create</button>
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
