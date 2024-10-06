<script lang="ts">
	import '../app.css';
	import { AppShell } from '@skeletonlabs/skeleton';
	import { AppBar } from '@skeletonlabs/skeleton';
	import type { AfterNavigate } from '@sveltejs/kit';
	import { afterNavigate } from '$app/navigation';

	import { page } from '$app/stores';
	import MenuLateral from '../componentes/menu_lateral.svelte';

	const url = $page.url.pathname;
	export let data;
	let menus = data.menus;

	afterNavigate((params: AfterNavigate) => {
		const isNewPage = params.from?.url.pathname !== params.to?.url.pathname;
		const elemPage = document.querySelector('#page');
		if (isNewPage && elemPage !== null) {
			elemPage.scrollTop = 0;
		}
	});
</script>

<AppShell slotSidebarLeft="w-60" slotPageContent="p-4 bg-slate-400">
	<svelte:fragment slot="header">
		<AppBar>
			<svelte:fragment slot="lead"><i class="fa-solid fa-user"></i></svelte:fragment>
			EVG Sistemas
			<svelte:fragment slot="trail">(actions)</svelte:fragment>
		</AppBar>
	</svelte:fragment>

	<svelte:fragment slot="sidebarLeft">
		{#if url !== '/login'}
			<MenuLateral {menus} />
		{/if}
	</svelte:fragment>
	<!-- (sidebarRight) -->
	<!-- (pageHeader) -->
	<!-- Router Slot -->
	<div class="card p-4 container">
		<slot />
	</div>
	<!-- ---- / ---- -->
	<!-- (pageFooter) -->
	<!-- (footer) -->
</AppShell>
