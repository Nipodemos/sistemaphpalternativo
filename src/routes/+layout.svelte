<script>
	import '../app.css';
	import { AppShell } from '@skeletonlabs/skeleton';
	import { AppBar } from '@skeletonlabs/skeleton';
	import ArrowLeft from 'lucide-svelte/icons/arrow-left';
	import Paperclip from 'lucide-svelte/icons/paperclip';
	import Calendar from 'lucide-svelte/icons/calendar';
	import CircleUser from 'lucide-svelte/icons/circle-user';
</script>

<div class="meuContainer w-full">
	<AppShell>
		<svelte:fragment slot="header">
			<AppBar>
				<svelte:fragment slot="lead">(icon)</svelte:fragment>
				EVG Sistemas
				<svelte:fragment slot="trail">(actions)</svelte:fragment>
			</AppBar>
		</svelte:fragment>
		<svelte:fragment slot="sidebarLeft">Sidebar Left</svelte:fragment>
		<!-- (sidebarRight) -->
		<!-- (pageHeader) -->
		<!-- Router Slot -->
		<slot />
		<!-- ---- / ---- -->
		<!-- (pageFooter) -->
		<!-- (footer) -->
	</AppShell>

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
