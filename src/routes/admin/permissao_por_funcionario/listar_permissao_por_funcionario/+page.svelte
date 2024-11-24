<script lang="ts">
	let textoPesquisa = $state('');
	let { data } = $props();

	let funcionariosFiltrados = $derived.by(() => {
		if (textoPesquisa === '') {
			return data.funcionarios;
		} else {
			return data.funcionarios.filter((func) => {
				let cpfcnpjLimpo = func.cpfcnpj.replace(/[^0-9]/g, '');
				return (
					func.nome.toLowerCase().includes(textoPesquisa.toLowerCase()) ||
					func.cpfcnpj.toLowerCase().includes(textoPesquisa.toLowerCase()) ||
					cpfcnpjLimpo.includes(textoPesquisa)
				);
			});
		}
	});
</script>

<div class="flex">
	<div class="mb-8">
		<h2 class="h2">Cadastro de permissões por funcionário</h2>
	</div>
</div>

<div class="row mb-5">
	<div class="col-12">
		<label class="label">
			<span>Pesquisar funcionários:</span>
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
	<table class="table-hover table">
		<thead>
			<tr>
				<th>Menu</th>
				<th>Submenu</th>
				<th>Ações</th>
			</tr>
		</thead>
		<tbody>
			{#each funcionariosFiltrados as funcionario}
				<tr>
					<td>{funcionario.menu}</td>
					<td>{funcionario.submenu}</td>
					<td class="text-center">
						<a
							href="/admin/permissao_por_funcionario/alterar_permissao_por_funcionario?id={funcionario.id}"
							class="variant-filled btn-icon"
							aria-label="Editar"
						>
							<i class="fa fa-pencil"></i>
						</a>
					</td>
				</tr>
			{:else}
				<tr>
					<td colspan="3" class="text-error-300"
						><p>Nenhuma tela encontrada com a pesquisa informada!</p></td
					>
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
