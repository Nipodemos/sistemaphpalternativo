import type { LayoutServerLoad } from './$types';
import { jsonify } from 'surrealdb.js';
import db from '$lib/database/connection';
import type { MenuLateral, Tela } from '$lib/types';

export const load: LayoutServerLoad = async () => {
	const user = await db.info();
	console.log({ user });
	let telas: Tela[] = [];
	if (!user) {
		telas = await db.select<Tela>('tela').then(jsonify);
		console.log(telas);
	} else {
		telas = await db.select<Tela>('tela').then(jsonify);
		console.log(telas);
	}

	const menus: MenuLateral = {};
	telas.forEach((tela) => {
		if (!menus[tela.menu]) {
			menus[tela.menu] = [];
		}
		menus[tela.menu].push(tela);
	});

	console.log(telas);
	console.log(menus);
	return {
		telas,
		menus
	};
};
