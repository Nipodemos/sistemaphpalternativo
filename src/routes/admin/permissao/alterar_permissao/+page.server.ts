import { getDb } from '$lib/database/connection';
import { type Funcionario, type Tela } from '$lib/database/types';
import { jsonify, StringRecordId } from 'surrealdb';
import type { PageServerLoad } from './$types';
import { message, superValidate } from 'sveltekit-superforms';
import { zod } from 'sveltekit-superforms/adapters';
import { z } from 'zod';

type Permissao = {
	visualizar: boolean;
	criar: boolean;
	editar: boolean;
	deletar: boolean;
	relatorio: boolean;
};

// Defina o esquema para Funcionario
const formSchema = z.array(
	z.object({
		id: z.string(),
		nome: z.string(),
		// Adicione outras propriedades de Funcionario aqui
		permissoes: z.object({
			visualizar: z.boolean(),
			criar: z.boolean(),
			editar: z.boolean(),
			deletar: z.boolean(),
			relatorio: z.boolean()
		})
	})
);

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

	const funcionariosFormatado = funcionarios.map((funcionario) => {
		const permissaoTela = funcionario.permissoesTela.find(
			(permissao) => permissao.tela.id.toString() === telaID
		);

		let retorno: Permissao;
		if (!permissaoTela) {
			retorno = {
				visualizar: false,
				criar: false,
				editar: false,
				deletar: false,
				relatorio: false
			};
		} else {
			retorno = {
				visualizar: permissaoTela.permissoes.includes('visualizar'),
				criar: permissaoTela.permissoes.includes('criar'),
				editar: permissaoTela.permissoes.includes('editar'),
				deletar: permissaoTela.permissoes.includes('deletar'),
				relatorio: permissaoTela.permissoes.includes('relatorio')
			};
		}
		funcionario.permissoes = retorno;
		return funcionario;
	});
	console.log('oi');
	const form = await superValidate(funcionariosFormatado, zod(formSchema));
	return { funcionariosFormatado, form, dadosDaTela };
};
