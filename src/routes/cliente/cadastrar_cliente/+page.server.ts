import db from '$lib/database/connection';
import { fail } from '@sveltejs/kit';
import type { PageServerLoad } from './$types';
import { message, superValidate } from 'sveltekit-superforms';
import { zod } from 'sveltekit-superforms/adapters';
import { z } from 'zod';

const schema = z.object({
	nome: z.string(),
	fantasia: z.string().optional(),
	cpfcnpj: z.string().min(14).max(18),
	nascimento: z.date(),
	inscricaoEstadual: z.string().optional(),
	endereco: z.string(),
	numero: z.string(),
	complemento: z.string().optional(),
	bairro: z.string(),
	cidade: z.string(),
	estado: z.string(),
	cep: z.string().min(8).max(8),
	celular: z.string().min(10).max(11),
	telefone: z.string().min(10).max(11).optional(),
	email: z.string().email().optional()
});

export const load: PageServerLoad = async () => {
	const form = await superValidate(zod(schema));
	const clientes = await db.select('cliente');
	console.log(clientes);
	return {
		clientes,
		form,
		estaCadastrando: true
	};
};

export const actions = {
	default: async (request) => {
		const form = await superValidate(request, zod(schema));

		if (!form.valid) {
			return fail(400, { form });
		}

		await db.insert('cliente', form);
		return message(form, 'Cliente cadastrado com sucesso!');
	}
};
