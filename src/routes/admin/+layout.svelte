<script lang="ts">
	import '../../app.css';
	import type { AfterNavigate } from '@sveltejs/kit';
	import { afterNavigate } from '$app/navigation';
	import { page } from '$app/stores';
	import MenuLateral from '../../componentes/menu_lateral.svelte';
	import { AppBar, ProgressRing, ToastProvider } from '@skeletonlabs/skeleton-svelte';
	import { onNavigate } from '$app/navigation';
	import { navigating } from '$app/stores';
	import { Progress } from '@skeletonlabs/skeleton-svelte';

	const url = $page.url.pathname;
	let { children, data } = $props();
	let menus = data.menus;
	onNavigate((navigation) => {
		if (!document.startViewTransition) return;

		return new Promise((resolve) => {
			document.startViewTransition(async () => {
				resolve();
				await navigation.complete;
			});
		});
	});

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
		<header>
			<AppBar>
				{#snippet lead()}
					<i class="fa-solid fa-arrow-left"></i>
					<a href="/admin/" class="ml-2">EVG Sistemas</a>
				{/snippet}
				{#snippet trail()}
					menu pra sair
				{/snippet}
				{#if $navigating}
					<div class="mx-auto w-44"><Progress classes="w-10" value={null} /></div>
				{:else}
					<span>Title</span>
				{/if}
			</AppBar>
		</header>
		<!-- Grid Columns -->
		<div class="grid grid-cols-1 md:grid-cols-[auto_1fr]">
			<!-- Left Sidebar. -->
			<aside class="row-span-2 w-56 bg-surface-200-800">
				<MenuLateral {menus} />
			</aside>
			<!-- Main Content -->
			<main
				class="card m-4 box-border border-[1px] p-2 border-surface-200-800 preset-filled-surface-100-900"
			>
				{@render children()}
			</main>
			<footer class="border-l-2 p-4 bg-surface-200-800">
				EVG sistemas, todos os direitos reservados
			</footer>
		</div>
		<!-- Footer -->
	</div>
</ToastProvider>
