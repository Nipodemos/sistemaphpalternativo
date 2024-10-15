<script lang="ts">
	import type { Funcionario } from '$lib/database/types.js';
	import { SlideToggle } from '@skeletonlabs/skeleton';
	import SuperDebug from 'sveltekit-superforms';
	import { superForm } from 'sveltekit-superforms';
	export let data;
	const { form } = superForm(data.form);
	// const funcionarios = data.funcionarios!;
	const dadosDaTela = data.dadosDaTela!;
	let permissoes = ['Visualizar', 'Inserir', 'Alterar', 'Excluir', 'Relatório'];
	const temPermissao = (perm: string, func: Funcionario) => {
		if (data.dadosDaTela) {
			let tela = func.permissoesTela.find((p) => p.tela.id == data.dadosDaTela.id);
			if (tela) {
				let permissao = tela.permissoes.find((p) => p === perm);
				if (permissao) {
					return true;
				}
			}
		}

		return false;
	};
</script>

<SuperDebug data={$form} />
<div class="flex">
	<div class="mb-8">
		<h3 class="h3">Editar permissões da tela de {dadosDaTela.submenu}</h3>
	</div>
</div>

<div class="table-container">
	<!-- Native Table Element -->
	<table class="table table-hover">
		<thead>
			<tr>
				<th>Funcionário</th>
				{#each permissoes as permissao}
					<th>{permissao}</th>
				{/each}
			</tr>
		</thead>
		<tbody>
			<!-- {#each funcionarios as funcionario}
				<tr>
					<td>{funcionario.nome}</td>
					{#each permissoes as p}
						<td class="text-left">
							<SlideToggle name={funcionario.id + ';' + p} checked={temPermissao(p, funcionario)} />
						</td>
					{/each}
				</tr>
			{/each} -->
		</tbody>
	</table>
</div>
