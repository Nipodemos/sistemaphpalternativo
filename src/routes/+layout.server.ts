import type { LayoutServerLoad } from './$types';
import { jsonify } from 'surrealdb';
import { initDb } from '$lib/database/connection';
import type { Tela } from '$lib/database/types';

interface MenuLateral {
	[key: string]: Tela[];
}

type Jsonified<T> = Omit<T, 'id'> & { id: `${string}:${string}` };

export const load: LayoutServerLoad = async ({ fetch }) => {
	const db = await initDb();
	if (!db) {
		return {
			telas: [],
			menus: {},
			estados: []
		};
	}
	const token = await db.signin({
		username: 'root',
		password: 'root'
	});
	console.log({ token });
	const user = await db.info();
	console.log({ user });
	let telas: Jsonified<Tela>[] = [];
	if (!user) {
		telas = jsonify(await db.select<Tela>('tela'));
	} else {
		telas = jsonify(await db.select('tela'));
	}

	console.log({ telas });

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
