export type Tela = {
	id: string;
	menu: string;
	submenu: string;
	codigo: number;
	icone: string;
	url: string;
	criadoEm: string;
	atualizadoEm: string;
	canceladoEm: string;
};

export type MenuLateral = {
	[key: string]: Tela[];
};
