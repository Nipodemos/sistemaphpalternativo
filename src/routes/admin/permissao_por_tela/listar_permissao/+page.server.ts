import { getDb } from '$lib/database/connection';
import { jsonify, Table } from 'surrealdb';
import type { PageServerLoad } from './$types';
import type { Tela } from '$lib/database/types';

export const load: PageServerLoad = async () => {
	const db = getDb();
	let telas = await db.select<Tela>(new Table('tela'));
	telas = jsonify<Tela[]>(telas);
	return {
		telas
	};
};
