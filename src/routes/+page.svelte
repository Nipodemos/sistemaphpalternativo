<script lang="ts">
	import SuperDebug, { superForm } from 'sveltekit-superforms';

	export let data;

	const { form } = superForm(data.form);
</script>

<h1>página de login</h1>
<SuperDebug data={form} />
<form method="post">
	<label class="label">
		<p>Email ou login</p>
		<div class="input-group input-group-divider grid-cols-[auto_1fr_auto]">
			<div class="input-group-shim">@</div>
			<input type="text" name="login" placeholder="email ou login" bind:value={$form.login} />
		</div>
	</label>

	<label class="label">
		<input type="password" class="input" name="senha" bind:value={$form.senha} />
	</label>

	<button class="btn variant-filled" type="submit">login</button>
</form>
