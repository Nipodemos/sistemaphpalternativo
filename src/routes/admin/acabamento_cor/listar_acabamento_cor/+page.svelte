<script lang="ts">
	import { getToastStore } from '@skeletonlabs/skeleton';
	import { superForm } from 'sveltekit-superforms/client';
	import { goto, invalidate } from '$app/navigation';

	let textoPesquisa = '';
	export let data;
	const toastStore = getToastStore();
	let coresAcabamentos = [];

	const { form, enhance, constraints, errors } = superForm(data.form!, {
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

</script>

<div class="flex">
	<div class="mb-8">
		<h2 class="h2">Cadastro de cores/acabamentos</h2>
	</div>
</div>

<form class="row mb-5" use:enhance>
	<div class="col-4">
		<label class="label">
			<span>Select</span>
			<select name="filtro" bind:value={$form.filtro} {...$constraints.filtro} class="select">
				<option value="" selected disabled>-- Selecione ---</option>
				<option value="cor">Cor</option>
				<option value="acabamento">Acabamento</option>
				<option value="ambos">Ambos</option>
			</select>
		</label>
		{#if $errors.filtro}
			{#each $errors.filtro as erro}
				<p class="text-error-500">{erro}</p>
			{/each}
		{/if}
	</div>
	<div class="col-5">
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
	<div class="col-3">
		<button type="submit" class="btn variant-filled">
			<span><i class="fa fa-search" ></i></span>
			<span>Button</span>
		</button>
	</div>
</form>
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
		{:else}
			<tr>
				<td colspan="3" class="text-error-300" ><p>Nenhuma tela encontrada com a pesquisa informada!</p></td>
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
