export interface BaseTabela {
	id: string;
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
