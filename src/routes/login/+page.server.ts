import { initDb } from '$lib/database/connection';
import { fail } from '@sveltejs/kit';

export const actions = {
	default: async ({ cookies, request }) => {
		const data = await request.formData();
		const login = data.get('login');
		const senha = data.get('senha');

		if (typeof login !== 'string' || typeof senha !== 'string' || !login || !senha) {
			return fail(400, { invalid: true });
		}
		const db = await initDb();
		if (!db) {
			return {
				redirect: '/'
			};
		}
		const authenticatedUser = await db.signin({
			namespace: 'test',
			database: 'test',
			access: 'conta_usuario',
			variables: {
				login,
				senha
			}
		});
		console.log({ authenticatedUser });

		cookies.set('tokenUsuario', authenticatedUser, {
			// send cookie for every page
			path: '/',
			// server side only cookie so you can't use `document.cookie`
			httpOnly: true,
			// only requests from same site can send cookies
			// https://developer.mozilla.org/en-US/docs/Glossary/CSRF
			sameSite: 'strict',
			// only sent over HTTPS in production
			secure: process.env.NODE_ENV === 'production',
			// set cookie to expire after a month
			maxAge: 60 * 60 * 24 * 30
		});
		return {
			redirect: '/'
		};
	}
};
