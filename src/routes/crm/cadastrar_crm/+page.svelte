<script lang="ts">
	let categorias = [
		{ id: 'apdsjo1', descricao: 'Categoria 1', corTexto: 'black', corFundo: 'white' },
		{ id: 'apdsjo2', descricao: 'Categoria 2', corTexto: 'black', corFundo: 'white' },
		{ id: 'apdsjo3', descricao: 'Categoria 3', corTexto: 'black', corFundo: 'white' },
		{ id: 'apdsjo4', descricao: 'Categoria 4', corTexto: 'black', corFundo: 'white' },
		{ id: 'apdsjo5', descricao: 'Categoria 5', corTexto: 'black', corFundo: 'white' },
		{ id: 'apdsjo6', descricao: 'Categoria 6', corTexto: 'black', corFundo: 'white' },
		{ id: 'apdsjo7', descricao: 'Categoria 7', corTexto: 'black', corFundo: 'white' },
		{ id: 'apdsjo8', descricao: 'Categoria 8', corTexto: 'black', corFundo: 'white' },
		{ id: 'apdsjo9', descricao: 'Categoria 9', corTexto: 'black', corFundo: 'white' },
		{ id: 'apdsjo10', descricao: 'Categoria 10', corTexto: 'black', corFundo: 'white' },
		{ id: 'apdsjo11', descricao: 'Categoria 11', corTexto: 'black', corFundo: 'white' },
		{ id: 'apdsjo12', descricao: 'Categoria 12', corTexto: 'black', corFundo: 'white' },
		{ id: 'apdsjo13', descricao: 'Categoria 13', corTexto: 'black', corFundo: 'white' },
		{ id: 'apdsjo14', descricao: 'Categoria 14', corTexto: 'black', corFundo: 'white' },
		{ id: 'apdsjo15', descricao: 'Categoria 15', corTexto: 'black', corFundo: 'white' },
		{ id: 'apdsjo16', descricao: 'Categoria 16', corTexto: 'black', corFundo: 'white' },
		{ id: 'apdsjo17', descricao: 'Categoria 17', corTexto: 'black', corFundo: 'white' }
	];

	let observacoes: string[] = [];
	let dadosCliente = {
		email: '',
		fone1: '',
		fone2: '',
		nomeContato: '',
		endereco: '',
		numero: '',
		bairro: '',
		cidade: '',
		estado: ''
	};
</script>

<div class="card">
	<h4 class="h4 mb-2">Cadastrar CRM</h4>

	<form>
		<div class="primeiraParte">
			<label class="label">
				<span class="label-text">Categoria</span>
				<select name="categoria" class="select">
					{#each categorias as categoria}
						<option
							value={categoria.id}
							style="color: {categoria.corTexto}; background-color: {categoria.corFundo}"
						>
							{categoria.descricao}
						</option>
					{/each}
				</select>
			</label>
			<label class="label">
				<span class="label-text">Data do procedimento</span>
				<input
					type="datetime"
					name="dataProcedimento"
					class="input"
					placeholder="00/00/0000 00:00"
				/>
			</label>
			<label class="label">
				<span class="label-text">Nome do cliente</span>
				<input type="text" name="nomeCliente" class="input" placeholder="Nome do cliente" />
			</label>
			<p>Email: {dadosCliente.email}</p>
			<p>Telefone 1: {dadosCliente.fone1}</p>
			<p>Telefone 2: {dadosCliente.fone2}</p>
			<p>Nome contato: {dadosCliente.nomeContato}</p>
			<p>Endereço: {dadosCliente.endereco}</p>
			<p>Número: {dadosCliente.numero}</p>
			<p>Bairro: {dadosCliente.bairro}</p>
			<p>Cidade: {dadosCliente.cidade}</p>
			<p>Estado: {dadosCliente.estado}</p>
		</div>
		<div class="segundaParte">
			{#each observacoes as observacao}
				<p>observacao</p>
			{/each}
		</div>
	</form>
</div>

<style>
	.primeiraParte {
		display: grid;
		grid-template-columns: repeat(3, 1fr);
		grid-gap: 1rem;
	}
</style>
