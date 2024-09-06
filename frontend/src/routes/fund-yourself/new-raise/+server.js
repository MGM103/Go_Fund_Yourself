import { json, text } from '@sveltejs/kit';
import { addDescription } from '$lib/server/db/database';

export async function POST({ request }) {
	try {
		const { id, description } = await request.json();

		addDescription(id, description);
		return json({ message: 'Description added successfully' }, { status: 200 });
	} catch (err) {
		console.error('Error while adding description:', err);
		return json({ error: 'Failed to add description' }, { status: 500 });
	}
}

export async function fallback({ request }) {
	return text(`I caught your ${request.method} request!`);
}
