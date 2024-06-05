<script lang="ts">
	import type { MenuLateral } from '$lib/types';
	export let menus: MenuLateral;
	import { Accordion, AccordionItem } from '@skeletonlabs/skeleton';
</script>

<Accordion>
	{#each Object.keys(menus) as nomeMenu}
		<AccordionItem>
			<svelte:fragment slot="lead"><i class={menus[nomeMenu][0].icone}></i></svelte:fragment>
			<svelte:fragment slot="summary">{nomeMenu}</svelte:fragment>
			<svelte:fragment slot="content">
				<nav class="list-nav">
					<ul>
						{#each menus[nomeMenu] as dadosMenu}
							<li>
								<a href={dadosMenu.url}>
									<span class="badge bg-primary-500"><i class="fa-solid fa-arrow-right"></i></span>
									<span class="flex-auto">{dadosMenu.submenu}</span>
								</a>
							</li>
						{/each}
					</ul>
				</nav>
			</svelte:fragment>
		</AccordionItem>
	{/each}
</Accordion>
