<script>
	import '../app.css';
	import { AppShell } from '@skeletonlabs/skeleton';
	import { AppBar } from '@skeletonlabs/skeleton';
	import type { AfterNavigate } from '@sveltejs/kit';
	import { afterNavigate } from '$app/navigation';

	afterNavigate((params: AfterNavigate) => {
		const isNewPage = params.from?.url.pathname !== params.to?.url.pathname;
		const elemPage = document.querySelector('#page');
		if (isNewPage && elemPage !== null) {
			elemPage.scrollTop = 0;
		}
	});
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
		<div class="p-4 bg-slate-500">
			<slot />
		</div>
		<!-- ---- / ---- -->
		<!-- (pageFooter) -->
		<!-- (footer) -->
	</AppShell>
</div>

<style>
	.meuContainer {
		width: 100%;
		display: flex;
		flex-direction: column;
	}
</style>
