import { initDb } from '$lib/database/connection';
import { jsonify, Table } from 'surrealdb';
import type { PageServerLoad } from './$types';
import type { Tela } from '$lib/database/types';
import { redirect } from '@sveltejs/kit';

export const load: PageServerLoad = async () => {
	const db = await initDb();
	if (db) {
		let telas = await db.select<Tela>(new Table('tela'));
		telas = jsonify<Tela[]>(telas);
		return {
			telas
		};
	} else {
		redirect(303, '/');
	}
};
