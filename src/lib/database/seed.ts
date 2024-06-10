import { RecordId } from 'surrealdb.js';
import db from './connection';
import type { Estado, Cidade } from './types';
type retornoApiCidade = {
	codigo_ibge: string;
	nome: string;
};
type retornoApiEstado = {
	id: number;
	sigla: string;
	nome: string;
};
async function main() {
	console.log(await db.info());
	const retorno = await db.query<Estado[]>('SELECT * FROM estado');
	console.log('retorno :>> ', retorno);

	const retornoEstados = await fetch('https://brasilapi.com.br/api/ibge/uf/v1');
	// console.log('retorno :>> ', retorno);

	console.log('Vai inserir os estados');
	const estados: retornoApiEstado[] = await retornoEstados.json();

	for (const estado of estados) {
		console.log('estado.nome :>> ', estado.nome);

		// checar se estado existe antes de inserir
		const [estadoExiste] = await db.query<Estado[][]>(`SELECT * FROM estado:${estado.sigla}`);

		if (estadoExiste.length === 0) {
			console.log('    estado não existe, inserindo');
			const resultInsert = await db.insert('estado', {
				id: estado.sigla,
				nome: estado.nome,
				sigla: estado.sigla
			});

			if (!resultInsert) {
				throw new Error('    Erro ao inserir estado');
			}
		} else {
			console.log('    estado já existe');
		}

		const retornoCidades = await fetch(
			`https://brasilapi.com.br/api/ibge/municipios/v1/${estado.sigla}?providers=dados-abertos-br,gov,wikipedia`
		);

		console.log('    inserindo cidades');
		const cidades: retornoApiCidade[] = await retornoCidades.json();
		console.log('        ' + cidades.length + ' cidades encontradas');
		for (const cidade of cidades) {
			// checar se cidade existe antes de inserir
			const [cidadeExiste] = await db.query<Cidade[][]>(
				`SELECT * FROM cidade:${cidade.codigo_ibge}`
			);
			if (cidadeExiste.length > 0) {
				console.log('        cidade já existe: ' + cidade.nome + ' - ' + cidade.codigo_ibge);
				continue;
			}
			const resultInsert = await db.insert('cidade', {
				id: cidade.codigo_ibge,
				nome: cidade.nome,
				estado: new RecordId('estado', estado.sigla),
				codigoIbge: cidade.codigo_ibge
			});
			if (!resultInsert) {
				throw new Error('        Erro ao inserir cidade');
			} else {
				console.log(
					'        cidade inserida com sucesso: ' + cidade.nome + ' - ' + cidade.codigo_ibge
				);
			}
		}

		if (cidades.length > 0) {
			db.merge(new RecordId('estado', estado.sigla), {
				listaCidades: cidades.map((cidade) => new RecordId('cidade', cidade.codigo_ibge))
			});
		}
		console.log('        cidades inseridas com sucesso');
	}
	console.log('Estados inseridos com sucesso');
}

main().then(() => {
	console.log('Seed finalizado');
	process.exit(0);
});
