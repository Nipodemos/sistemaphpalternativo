import type { LayoutServerLoad } from './$types';
import { jsonify } from 'surrealdb.js';
import db from '$lib/database/connection';
import type { MenuLateral, Tela } from '$lib/types';

export const load: LayoutServerLoad = async ({ fetch }) => {
	const user = await db.info();
	console.log({ user });
	let telas: Tela[] = [];
	if (!user) {
		telas = await db.select<Tela>('tela').then(jsonify);
	} else {
		telas = await db.select<Tela>('tela').then(jsonify);
	}

	const menus: MenuLateral = {};
	telas.forEach((tela) => {
		if (!menus[tela.menu]) {
			menus[tela.menu] = [];
		}
		menus[tela.menu].push(tela);
	});

	const retorno = await fetch('/api/pegar_estados');
	const estados = await retorno.json();

	return {
		telas,
		menus,
		estados
	};
};
