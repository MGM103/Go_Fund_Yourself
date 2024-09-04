import { initialiseDatabase } from '$lib/db/database';

initialiseDatabase();

export async function handle({ event, resolve }) {
	return resolve(event);
}
