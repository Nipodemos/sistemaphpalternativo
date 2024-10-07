<script lang="ts">
	import { superForm } from 'sveltekit-superforms/client';
	import { z } from 'zod';
	export let data;

	const { form, errors, enhance } = superForm(data.form);
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
				<input class="input" type="password" name="password" bind:value={$form.senha} />
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
