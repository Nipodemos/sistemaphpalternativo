<script lang="ts">
	import { page } from '$app/stores';
	import type { Tela } from '$lib/database/types';
	type MenuLateral = {
		[key: string]: Tela[];
	};

	let valueSingle = $page.route.id;
	console.log('valueSingle :>> ', valueSingle);
	export let menus: MenuLateral | undefined;
	import { Accordion, AccordionItem } from '@skeletonlabs/skeleton';
</script>

{#if menus}
	<Accordion>
		{#each Object.keys(menus) as menu}
			<AccordionItem>
				<svelte:fragment slot="lead"><i class={menus[menu][0].icone}></i></svelte:fragment>
				<svelte:fragment slot="summary">{menu}</svelte:fragment>
				<svelte:fragment slot="content">
					<nav class="list-nav">
						<ul>
							{#each menus[menu] as dadosMenu (dadosMenu.id)}
								<li>
									<a href={dadosMenu.url} class="chip variant-soft hover:variant-tertiary">
										<span>{dadosMenu.submenu}</span>
										<span class="flex-1"></span>
										<i class="fa-solid fa-arrow-right"></i>
									</a>
								</li>
							{/each}
						</ul>
					</nav>
				</svelte:fragment>
			</AccordionItem>
		{/each}
	</Accordion>
{/if}
