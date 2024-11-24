import { getDb } from '$lib/database/connection';
import { jsonify, Table } from 'surrealdb';
import type { PageServerLoad } from './$types';
import type { Funcionario } from '$lib/database/types';

export const load: PageServerLoad = async () => {
	const db = getDb();
	let funcionarios = await db.select<Funcionario>(new Table('funcionario'));
	funcionarios = jsonify<Funcionario[]>(funcionarios);
	return {
		funcionarios
	};
};
