import type { LayoutServerLoad } from './$types';
import { jsonify } from 'surrealdb';
import { getDb } from '$lib/database/connection';
import type { PermissaoTela, Tela } from '$lib/database/types';
import { redirect } from '@sveltejs/kit';

interface MenuLateral {
	[key: string]: Tela[];
}

export const load: LayoutServerLoad = async ({ url, cookies }) => {
	if (url.pathname === '/') {
		return {};
	}
	const token = cookies.get('tokenUsuario');
	if (token) {
		const db = getDb();
		const autenticado = await db.authenticate(token)
		
		
		if (autenticado) {
			try {
				const usuario = await db.info();
				if (usuario) {
					const [permissoes] = await db.query<[PermissaoTela[]]>(`
						SELECT tela.*
						FROM permissaoTela
						WHERE funcionario.id = $auth.funcionario.id
							AND podeVisualizar = true
						FETCH tela
					`);
					
					const menus: MenuLateral = {};
					permissoes.forEach((permissao) => {
						let tela = permissao.tela;
						if (!menus[tela.menu]) {
							menus[tela.menu] = [];
						}
						tela = jsonify(tela);
						menus[tela.menu].push(tela);
					});
					return {
						menus
					};
				}
			} 
			catch (error) {
				if (error instanceof Error) {
					console.log('error.message :>> ', error.message);
					console.log('error.name :>> ', error.name);
				}
				console.log('falha na autenticação do token, voltando para tela de login');
				redirect(303, '/');
			}
		}
		else {
			redirect(303, '/');
		}
	} else {
		redirect(303, '/');
	}
};
