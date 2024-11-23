<script lang="ts">
	import { getToastStore, SlideToggle } from '@skeletonlabs/skeleton';
	import SuperDebug from 'sveltekit-superforms';
	import { superForm } from 'sveltekit-superforms';
	import { goto, invalidate } from '$app/navigation';
	export let data;

	const toastStore = getToastStore();
	const { form, enhance } = superForm(data.form!, { 
		dataType: 'json',
		onUpdated: ({ form }) => {
			if (form.valid) {
				// Show success toast
				toastStore.trigger({
					message: 'Permissões alteradas com sucesso!',
					background: 'variant-filled-success'
				});
				// Redirect after a short delay
				setTimeout(async () => {
					await invalidate('/admin');
					await goto('/admin/listar_permissao');
				}, 750);
			}
		} 
	});
	const dadosDaTela = data.dadosDaTela!;
</script>

<SuperDebug data={$form} />
<div class="flex">
	<div class="mb-8">
		<h3 class="h3">Editar permissões da tela de {dadosDaTela.submenu}</h3>
	</div>
</div>

<form method="POST" use:enhance class="table-container">
	<!-- Native Table Element -->
	<table class="table table-hover">
		<thead>
			<tr>
				<th>Funcionário</th>
				<th>Visualizar</th>
				<th>Criar</th>
				<th>Editar</th>
				<th>Deletar</th>
				<th>Relatório</th>
			</tr>
		</thead>
		<tbody>
			{#each $form.permissaoPorFuncionario as funcionario}
				<tr>
					<td>{funcionario.nomeFuncionario}</td>
					<td class="text-left">
						<SlideToggle name="visualizar" bind:checked={funcionario.podeVisualizar} />
					</td>
					<td class="text-left">
						<SlideToggle name="criar" bind:checked={funcionario.podeCriar} />
					</td>
					<td class="text-left">
						<SlideToggle name="editar" bind:checked={funcionario.podeEditar} />
					</td>
					<td class="text-left">
						<SlideToggle name="deletar" bind:checked={funcionario.podeDeletar} />
					</td>
					<td class="text-left">
						<SlideToggle name="relatorio" bind:checked={funcionario.podeGerarRelatorio} />
					</td>
				</tr>
			{/each}
		</tbody>
	</table>
	<button type="submit" class="btn variant-filled">Salvar</button>
</form>
