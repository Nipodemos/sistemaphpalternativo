<script lang="ts">
	export let data;
	const permissoesPorFuncionario = data.permissoesPorFuncionario;
</script>

<div class="flex">
	<div class="mb-8">
		<h2 class="h2">Editar permissões da tela</h2>
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
