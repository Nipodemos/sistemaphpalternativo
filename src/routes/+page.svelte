<script lang="ts">
	import '../app.css';
	import { superForm } from 'sveltekit-superforms/client';
	import { goto } from '$app/navigation';
	import { getToastStore } from '@skeletonlabs/skeleton';
	export let data;

	const toastStore = getToastStore();

	const { form, errors, enhance } = superForm(data.form, {
		onResult: ({ result }) => {
			if (result.type === 'success') {
				// Show success toast
				toastStore.trigger({
					message: 'Login realizado com sucesso!',
					background: 'variant-filled-success'
				});
				// Redirect after a short delay
				setTimeout(() => {
					goto('/admin');
				}, 750);
			}
		}
	});
</script>

<div class="container h-full mx-auto flex justify-center items-center">
	<div class="card p-4 w-full max-w-sm">
		<h2 class="h2 mb-4">Login</h2>
		<form method="POST" use:enhance>
			<label class="label">
				<span>Email ou login</span>
				<input class="input" type="text" name="login" bind:value={$form.login} />
			</label>
			{#if $errors.login}
				{#each $errors.login as erro}
					<p class="text-error-500">{erro}</p>
				{/each}
			{/if}

			<label class="label mt-4">
				<span>Senha</span>
				<input class="input" type="password" name="senha" bind:value={$form.senha} />
			</label>
			{#if $errors.senha}
				{#each $errors.senha as erro}
					<p class="text-error-500">{erro}</p>
				{/each}
			{/if}

			<button type="submit" class="btn variant-filled-primary w-full mt-4">Login</button>
		</form>
	</div>
</div>
