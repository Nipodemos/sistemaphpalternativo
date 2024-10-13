import { getDb } from '$lib/database/connection';
import type { Funcionario, PermissaoTela } from '$lib/database/types';
import { jsonify, type Jsonify } from 'surrealdb';
import type { PageServerLoad } from './$types';

export const load: PageServerLoad = async ({ url }) => {
	const telaID = url.searchParams.get('id');
	if (!telaID) return { status: 404 };
	const db = getDb();
	//let array = db.query();

	let funcionarios = await db.select<Funcionario>('funcionario');
	funcionarios = jsonify<Funcionario[]>(funcionarios);
	let permissoes = await db.select<PermissaoTela>('permissaoTela');
	permissoes = jsonify<PermissaoTela[]>(permissoes);
	const nomeDaTela = permissoes[0].tela.menu;
	const permissoesPorFuncionario = unificarFuncionariosPermissoes(funcionarios, permissoes);
	return { permissoesPorFuncionario, nomeDaTela };
};

const unificarFuncionariosPermissoes = (
	funcionarios: Jsonify<Funcionario[]>,
	permissoes: Jsonify<PermissaoTela[]>
) => {
	return funcionarios.map((funcionario) => {
		// Filtra as permissões do funcionário atual
		const permissoesFuncionario = permissoes
			.filter((permissao) => permissao.funcionario.id === funcionario.id)
			.reduce((acumulado: { [key: string]: string[] }, permissao) => {
				const nomeTela = permissao.tela.id as unknown as string;
				if (!acumulado[nomeTela]) acumulado[nomeTela] = [];
				acumulado[nomeTela].push(permissao.permissao);
				return acumulado;
			}, {});

		// Adiciona as permissões ao objeto do funcionário
		return { ...funcionario, permissoes: permissoesFuncionario };
	});
};
