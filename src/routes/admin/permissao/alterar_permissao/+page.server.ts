import { initDb } from '$lib/database/connection';
import type { PageServerLoad } from './$types';

export const load: PageServerLoad = async () => {
	const db = await initDb();
	if (db) {
		let usuarios = await db.select('usuario');
	}
};

const unificarDados = (usuarios: Usuario, permissoes) => {
	return usuarios.map((usuario) => {
		// Filtra as permissões do usuário atual
		const permissoesUsuario = permissoes
			.filter((p) => p.usuario === usuario.id)
			.reduce((acc, p) => {
				const tela = p.tela.replace('tela:', '');
				if (!acc[tela]) acc[tela] = [];
				acc[tela].push(p.permissao);
				return acc;
			}, {});

		// Adiciona as permissões ao objeto do usuário
		return { ...usuario, permissoes: permissoesUsuario };
	});
};
