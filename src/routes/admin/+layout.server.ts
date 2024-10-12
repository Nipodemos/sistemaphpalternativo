import type { LayoutServerLoad } from './$types';
import { jsonify } from 'surrealdb';
import { initDb } from '$lib/database/connection';
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
	console.log('token dos cookies :>> ', token);
	if (token) {
		const db = await initDb();
		if (!db) {
			return {
				telas: [],
				menus: {},
				estados: []
			};
		}
		await db.authenticate(token);
		const usuario = await db.info();
		console.log({ usuario });
		if (usuario) {
			const [permissoes] = await db.query<[PermissaoTela[]]>(`
				SELECT tela FROM permissaoTela
				WHERE
					usuario.id = $auth.id AND
					permissao = 'visualizar'
				fetch tela,usuario
			`);
			console.log(permissoes[0]);

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
	} else {
		redirect(303, '/');
	}

	// const token = await db.signin({
	// 	username: 'root',
	// 	password: 'root'
	// });
	// console.log({ token });
	// const user = await db.info();
	// console.log({ user });
	// let telas: Jsonify<Tela>[] = [];

	// if (user) {
	// 	const permissoes = db.query<PermissaoTela[]>(`
	// 		SELECT * FROM permissaoTela
	// 		WHERE
	// 			usuario.id = $auth.id AND
	// 			lojista = $auth.lojista AND
	// 			permissao = 'visualizar'
	// 		fetch tela,usuario
	// 	`);
	// 	console.log({ permissoes });
	// 	telas = jsonify<Tela[]>(await db.select<Tela>('tela'));
	// } else {
	// 	telas = jsonify<Tela[]>(await db.select<Tela>('tela'));
	// }

	// console.log({ telas });

	// const menus: MenuLateral = {};
	// telas.forEach((tela) => {
	// 	if (!menus[tela.menu]) {
	// 		menus[tela.menu] = [];
	// 	}
	// 	menus[tela.menu].push(tela);
	// });

	// const retorno = await fetch('/api/pegar_estados');
	// const estados = await retorno.json();

	// return {
	// 	telas,
	// 	menus,
	// 	estados
	// };
};
