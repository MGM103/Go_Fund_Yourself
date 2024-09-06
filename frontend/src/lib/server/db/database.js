import Database from 'better-sqlite3';

const db = new Database('./data/fund-yourself.db', { verbose: console.log });

export function initialiseDatabase() {
	const sql = `
    CREATE TABLE IF NOT EXISTS descriptions (
      id INTEGER PRIMARY KEY,
      description TEXT NOT NULL
    );
  `;
	const stmt = db.prepare(sql);
	stmt.run();
}

// Get description by ID
export function getDescriptionById(id) {
	const sql = `
    SELECT description FROM descriptions WHERE id = $id
  `;

	const stmt = db.prepare(sql);
	const descriptionRecord = stmt.get({ id });

	return descriptionRecord;
}

// Get all descriptions
export function getDescriptions() {
	const sql = `
    SELECT id, description FROM descriptions
  `;

	const stmt = db.prepare(sql);
	const descriptionRecords = stmt.all();

	return descriptionRecords;
}

// Insert a description
export function addDescription(id, description) {
	const sql = `
    INSERT OR IGNORE INTO descriptions (id, description) VALUES ($id, $description)
  `;

	const stmt = db.prepare(sql);
	stmt.run({ id, description });
}

// Update a description
export function updateDescription(id, description) {
	const sql = `
		INSERT OR REPLACE INTO descriptions (id, description) VALUES ($id, $description)
	`;

	const stmt = db.prepare(sql);
	stmt.run({ id, description });
}
