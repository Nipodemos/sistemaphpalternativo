import { getDb } from '$lib/database/connection';
import type { Funcionario, Tela } from '$lib/database/types';
import { jsonify, StringRecordId } from 'surrealdb';
import type { PageServerLoad } from './$types';

export const load: PageServerLoad = async ({ url }) => {
	const telaID = url.searchParams.get('id');
	if (!telaID) return { status: 404 };
	const db = getDb();

	let funcionarios = await db.select<Funcionario>('funcionario');
	funcionarios = jsonify<Funcionario[]>(funcionarios);
	console.log('telaID :>> ', telaID);

	let dadosDaTela = await db.select<Tela>(new StringRecordId(telaID));
	dadosDaTela = jsonify<Tela>(dadosDaTela);
	console.log('tela :>> ', dadosDaTela);

	return { funcionarios, dadosDaTela };
};
