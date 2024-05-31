import db from '$lib/database/connection';
import type { PageServerLoad } from './$types';
import { superValidate } from 'sveltekit-superforms';
import { zod } from 'sveltekit-superforms/adapters';
import { z } from 'zod';

const schema = z.object({
	nome: z.string(),
	email: z.string().email().optional(),
	parceiro: z.boolean(),
	cpfcnpj: z.string().min(11).max(14),
	nascimento: z.date(),
	celular: z.string().min(10).max(11),
	telefone: z.string().min(10).max(11).optional(),
	cep: z.string().min(8).max(8),
	endereco: z.string(),
	numero: z.string(),
	complemento: z.string().optional(),
	bairro: z.string(),
	cidade: z.string(),
	estado: z.string(),
	codMunicipio: z.string().optional(),
	tipoConsumidor: z.enum(['final', 'normal']),
	tipoContribuinte: z.enum(['isento', 'contribuinte', 'naoContribuinte'])
});

export const load: PageServerLoad = async () => {
	const form = await superValidate(zod(schema));
	const clientes = await db.select('cliente');
	console.log(clientes);
	return {
		clientes,
		form
	};
};
