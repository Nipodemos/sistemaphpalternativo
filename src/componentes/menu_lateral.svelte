<script lang="ts">
	import { page } from '$app/stores';
	import type { Tela } from '$lib/database/types';
	type MenuLateral = {
		[key: string]: Tela[];
	};

	let valueSingle = $page.route.id;
	export let menus: MenuLateral | undefined;
	import { Accordion, Navigation } from '@skeletonlabs/skeleton-svelte';
</script>

{#if menus}
	<Accordion>
		{#each Object.keys(menus) as menu}
			<Accordion.Item panelPadding={'p-0'} panelClasses={'overflow-hidden'} value={menu}>
				{#snippet lead()}
					<i class={menus[menu][0].icone}></i>
				{/snippet}
				{#snippet control()}{menu}{/snippet}
				{#snippet panel()}
					{#each menus[menu] as dadosMenu (dadosMenu.id)}
						<Navigation.Rail expanded>
							{#snippet tiles()}
								<Navigation.Tile
									id="0"
									labelExpanded={dadosMenu.submenu}
									href={dadosMenu.url}
								>
									<i class="fa-solid fa-arrow-right"></i>
								</Navigation.Tile>
							{/snippet}
						</Navigation.Rail>
					{/each}
					<!-- <nav class="list-nav">
						<ul>
							<li>
								<a
									href={dadosMenu.url}
									class="variant-soft hover:variant-tertiary chip"
								>
									<span>{dadosMenu.submenu}</span>
									<span class="flex-1"></span>
									<i class="fa-solid fa-arrow-right"></i>
								</a>
							</li>
						</ul>
					</nav> -->
				{/snippet}
			</Accordion.Item>
		{/each}
	</Accordion>
{/if}
