import { Surreal } from 'surrealdb';

let db: Surreal | undefined;

export async function initDb(): Promise<Surreal | undefined> {
	if (db) return db;
	db = new Surreal();
	const tentativas = 3;
	for (let i = 0; i < tentativas; i++) {
		try {
			await db.connect('http://127.0.0.1:8000/rpc');
			await db.use({ namespace: 'test', database: 'test' });
			return db;
		} catch (err) {
			await new Promise((resolve) => setTimeout(resolve, 500));
			console.error('Failed to connect to SurrealDB:', err);
		}
	}
}

export async function closeDb(): Promise<void> {
	if (!db) return;
	await db.close();
	db = undefined;
}

export function getDb(): Surreal | undefined {
	return db;
}
// highlight-end
