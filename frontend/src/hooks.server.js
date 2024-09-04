import { initialiseDatabase } from '$lib/server/db/database';

initialiseDatabase();

export async function handle({ event, resolve }) {
	return resolve(event);
}
