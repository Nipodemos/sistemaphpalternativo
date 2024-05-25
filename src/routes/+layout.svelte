<script>
	import '../app.css';
	import { AppBar } from '@skeletonlabs/skeleton-svelte';
	import ArrowLeft from 'lucide-svelte/icons/arrow-left';
	import Paperclip from 'lucide-svelte/icons/paperclip';
	import Calendar from 'lucide-svelte/icons/calendar';
	import CircleUser from 'lucide-svelte/icons/circle-user';
</script>

<div class="meuContainer w-full">
	<AppBar>
		{#snippet lead()}
			<ArrowLeft size={24} />
		{/snippet}
		Title
		{#snippet trail()}
			<Paperclip size={20} />
			<Calendar size={20} />
			<CircleUser size={20} />
		{/snippet}
	</AppBar>

	<div class="content">
		<div class="sidebar preset-filled-surface-100-900">SIDEBAR</div>

		<main class="m-5 overflow-y-auto p-4 preset-filled-surface-100-900">
			<div class="card"><slot></slot></div>
		</main>
	</div>
</div>

<style>
	.meuContainer {
		width: 100%;
		display: flex;
		flex-direction: column;
	}

	.content {
		display: flex;
	}

	.sidebar {
		width: 200px;
		height: calc(100vh - 56px); /* Subtrai a altura do menu fixo */
	}

	main {
		flex-grow: 1;
	}
</style>
