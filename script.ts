import db from './src/lib/database/connection.ts';

type Cidade = { codigo_ibge: string; nome: string };
type Estado = {
	id: number;
	sigla: string;
	nome: string;
};
async function main() {
	const retornoEstados = await fetch('https://brasilapi.com.br/api/ibge/uf/v1');
	// console.log('retorno :>> ', retorno);

	const estados: Estado[] = await retornoEstados.json();

	for (const estado of estados) {
		const retornoCidades = await fetch(
			`https://brasilapi.com.br/api/ibge/municipios/v1/${estado.sigla}?providers=dados-abertos-br,gov,wikipedia`
		);

		const cidades: Cidade[] = await retornoCidades.json();

		const estadoDB = await db.query(
			`INSERT INTO estados (id, sigla, nome) VALUES (${estado.id}, '${estado.sigla}', '${estado.nome}')`
		);

		for (const cidade of cidades) {
			const cidadeDB = await db.query(
				`INSERT INTO cidades (codigo_ibge, nome, estado_id) VALUES ('${cidade.codigo_ibge}', '${cidade.nome}', ${estado.id})`
			);
		}
	}
}
