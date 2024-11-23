<script lang="ts">
	import '../../app.css';
	import type { AfterNavigate } from '@sveltejs/kit';
	import { afterNavigate } from '$app/navigation';

	import { page } from '$app/stores';
	// import MenuLateral from '../../componentes/menu_lateral.svelte';
	import { AppBar, ToastProvider } from '@skeletonlabs/skeleton-svelte';

	const url = $page.url.pathname;
	let { children, data } = $props();
	let menus = data.menus;

	afterNavigate((params: AfterNavigate) => {
		const isNewPage = params.from?.url.pathname !== params.to?.url.pathname;
		const elemPage = document.querySelector('#page');
		if (isNewPage && elemPage !== null) {
			elemPage.scrollTop = 0;
		}
	});
</script>

<ToastProvider>
	<div class="grid h-screen grid-rows-[auto_1fr_auto]">
		<!-- Header -->
		<header class="bg-red-500 p-4">
			<AppBar>
				{#snippet lead()}
					<i class="fa-solid fa-arrow-left"></i>
					EVG Sistemas
				{/snippet}
				{#snippet trail()}
					menu pra sair
				{/snippet}
				<span>Title</span>
			</AppBar>
		</header>
		<!-- Grid Columns -->
		<div class="grid grid-cols-1 md:grid-cols-[auto_1fr]">
			<!-- Left Sidebar. -->
			<aside class="w-52 bg-yellow-500 p-4">
				<!-- <MenuLateral {menus} /> -->
			</aside>
			<!-- Main Content -->
			<main class="space-y-4 bg-green-500 p-4">
				{@render children()}
			</main>
		</div>
		<!-- Footer -->
		<footer class="bg-blue-500 p-4">EVG sistemas, todos os direitos reservados</footer>
	</div>
</ToastProvider>
