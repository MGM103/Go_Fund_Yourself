function toCamelCase(...strings) {
	return strings
		.map((str, index) => {
			// Lowercase the entire string and split it by spaces or hyphens
			let words = str.toLowerCase().split(/[\s-_]+/);
			// Capitalize the first letter of each word except the first one
			return words
				.map((word, i) => {
					if (i === 0 && index === 0) {
						// Keep the first word of the first string lowercase
						return word;
					} else {
						// Capitalize the first letter of each subsequent word
						return word.charAt(0).toUpperCase() + word.slice(1);
					}
				})
				.join('');
		})
		.join('');
}

export default toCamelCase;
