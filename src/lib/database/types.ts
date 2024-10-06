import type { RecordId } from 'surrealdb';

export interface BaseTabela {
	id: RecordId;
	[x: string]: unknown;
	criadoEm: Date;
	atualizadoEm: Date;
	canceladoEm: Date | null;
}
export interface Estado extends BaseTabela {
	nome: string;
	sigla: string;
	listaCidades: Cidade[] | string[];
}

export interface Cidade extends BaseTabela {
	nome: string;
	estado: Estado | string;
	codigoIbge: string;
}

export interface Tela extends BaseTabela {
	menu: string;
	submenu: string;
	codigo: string;
	icone: string;
	url: string;
}

export interface PermissaoTela extends BaseTabela {
	usuario: RecordId<'usuario'>;
	tela: RecordId<'tela'>;
	permissao: 'visualizar' | 'criar' | 'editar' | 'deletar' | 'relatorio';
	lojista: string;
}
