import { getDb } from '$lib/database/connection';
import type { Funcionario, Tela } from '$lib/database/types';
import { jsonify, StringRecordId, surql } from 'surrealdb';
import type { PageServerLoad } from './$types';
import { fail, message, superValidate } from 'sveltekit-superforms';
import { zod } from 'sveltekit-superforms/adapters';
import { z } from 'zod';
import { invalidate } from '$app/navigation';

const permissaoPorFuncionarioSchema = z.array(
	z.object({
		idPermissaoTela: z.string().optional(),
		idFuncionario: z.string(),
		nomeFuncionario: z.string(),
		podeVisualizar: z.boolean(),
		podeCriar: z.boolean(),
		podeEditar: z.boolean(),
		podeDeletar: z.boolean(),
		podeGerarRelatorio: z.boolean()
	})
);
// Defina o esquema para Funcionario
const formSchema = z.object({
	idTela: z.string(),
	permissaoPorFuncionario: permissaoPorFuncionarioSchema
});

export const load: PageServerLoad = async ({ url }) => {
	const idTela = url.searchParams.get('id');
	if (!idTela) return { status: 404 };
	const db = getDb();

	const funcionarios = await db.select<Funcionario>('funcionario');

	let dadosDaTela = await db.select<Tela>(new StringRecordId(idTela));
	dadosDaTela = jsonify<Tela>(dadosDaTela);

	const permissaoPorFuncionario: z.infer<typeof permissaoPorFuncionarioSchema> = funcionarios.map(
		(funcionario) => {
			const permissaoTela = funcionario.permissoesTela.find((permissao) => {
				return permissao.tela.toString() === idTela;
			});

			return {
				idPermissaoTela: permissaoTela?.id.toString(),
				idFuncionario: funcionario.id.toString(),
				nomeFuncionario: funcionario.nome,
				podeVisualizar: permissaoTela?.podeVisualizar ?? false,
				podeCriar: permissaoTela?.podeVisualizar ?? false,
				podeEditar: permissaoTela?.podeVisualizar ?? false,
				podeDeletar: permissaoTela?.podeVisualizar ?? false,
				podeGerarRelatorio: permissaoTela?.podeVisualizar ?? false
			};
		}
	);

	const form = await superValidate({ idTela, permissaoPorFuncionario }, zod(formSchema));
	return { form, dadosDaTela };
};

interface InsertPermissaoTela {
	funcionario: StringRecordId;
	tela: StringRecordId;
	podeVisualizar: boolean;
	podeCriar: boolean;
	podeEditar: boolean;
	podeDeletar: boolean;
	podeGerarRelatorio: boolean;
	[x: string]: unknown;
}

interface UpdatePermissaoTela {
	podeVisualizar: boolean;
	podeCriar: boolean;
	podeEditar: boolean;
	podeDeletar: boolean;
	podeGerarRelatorio: boolean;
	[x: string]: unknown;
}
export const actions = {
	default: async ({ request }) => {
		const form = await superValidate(request, zod(formSchema));
		console.log('form.data.funcionariosFormatado :>> ', form.data.permissaoPorFuncionario);

		if (!form.valid) {
			return fail(400, { form });
		}

		const db = getDb();
		const funcionarios = form.data.permissaoPorFuncionario;
		
		try {
			for (const funcionario of funcionarios) {
				if (funcionario.idPermissaoTela) {
					const id = new StringRecordId(funcionario.idPermissaoTela);
					const sql = `
						UPDATE ${id} 
						SET 
							podeVisualizar = ${funcionario.podeVisualizar},
							podeCriar = ${funcionario.podeCriar},
							podeEditar = ${funcionario.podeEditar},
							podeDeletar = ${funcionario.podeDeletar},
							podeGerarRelatorio = ${funcionario.podeGerarRelatorio};
					`;
					console.log(sql);
					const [resultUpdate] = await db.query<[UpdatePermissaoTela]>(sql);
					/*const resultUpdate = await db.update<UpdatePermissaoTela>(
						new StringRecordId(funcionario.idPermissaoTela),
						{
							podeVisualizar: funcionario.podeVisualizar,
							podeCriar: funcionario.podeCriar,
							podeEditar: funcionario.podeEditar,
							podeDeletar: funcionario.podeDeletar,
							podeGerarRelatorio: funcionario.podeGerarRelatorio
						}
					)*/ 
					console.log('resultUpdate :>> ', resultUpdate);
				} else {
					const resultInsert = await db.insert<InsertPermissaoTela>('permissaoTela', {
						funcionario: new StringRecordId(funcionario.idFuncionario),
						tela: new StringRecordId(form.data.idTela),
						podeVisualizar: funcionario.podeVisualizar,
						podeCriar: funcionario.podeCriar,
						podeEditar: funcionario.podeEditar,
						podeDeletar: funcionario.podeDeletar,
						podeGerarRelatorio: funcionario.podeGerarRelatorio
					});
					console.log('resultInsert :>> ', resultInsert);
				}
			}
		}
		catch (error) {
			fail()
		}

		

		await invalidate('/admin');
		return message(form, 'Form posted successfully!');
	}
};
