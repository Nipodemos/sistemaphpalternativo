<script lang="ts">
	let textoPesquisa = '';
	export let data;
	let telasFiltradas = data.telas;

	$: if (textoPesquisa === '') {
		telasFiltradas = data.telas;
	} else {
		telasFiltradas = data.telas.filter((item) => {
			return (
				item.menu.toLowerCase().includes(textoPesquisa.toLowerCase()) ||
				item.submenu.toLowerCase().includes(textoPesquisa.toLowerCase())
			);
		});
	}
</script>

<div class="flex">
	<div class="mb-8">
		<h2 class="h2">Cadastro de permissões</h2>
	</div>
	<div class="flex-1"></div>
	<div class=" text-right">
		<a href="/admin/permissao/cadastrar_permissao" class="btn variant-filled-primary">
			Adicionar <i class="ml-2 fa-solid fa-plus"></i>
		</a>
	</div>
</div>

<div class="row mb-5">
	<div class="col-12">
		<label class="label">
			<span>Pesquisar telas:</span>
			<input
				class="input"
				type="text"
				placeholder="Digite aqui a pesquisa"
				bind:value={textoPesquisa}
			/>
		</label>
	</div>
</div>
<div class="table-container">
	<!-- Native Table Element -->
	<table class="table table-hover">
		<thead>
			<tr>
				<th>Menu</th>
				<th>Submenu</th>
				<th>Ações</th>
			</tr>
		</thead>
		<tbody>
			{#each telasFiltradas as tela}
				<tr>
					<td>{tela.menu}</td>
					<td>{tela.submenu}</td>
					<td class="text-center">
						<a
							href="/admin/permissao/alterar_permissao?id={tela.id}"
							class="btn-icon variant-filled"
						>
							<i class="fa fa-pencil"></i>
						</a>
					</td>
				</tr>
			{/each}
		</tbody>
		<tfoot>
			<tr>
				<th>Menu</th>
				<th>Submenu</th>
				<th>Ações</th>
			</tr>
		</tfoot>
	</table>
</div>
