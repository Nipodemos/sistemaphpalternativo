<script lang="ts">
	import { Tab, TabGroup } from '@skeletonlabs/skeleton';
	import { superForm } from 'sveltekit-superforms';
	import SuperDebug from 'sveltekit-superforms';
	import { SlideToggle } from '@skeletonlabs/skeleton';
	import { Contact, Users } from 'lucide-svelte';
	import type { PageData } from './$types';
	export let data: PageData;
	let tabSet: number = 1;
	const { form } = superForm(data.form);
</script>

<h2 class="h2">Cadastrar cliente</h2>
<form>
	<TabGroup>
		<Tab bind:group={tabSet} name="tab1" value={1}>
			<span>Cadastro</span>
		</Tab>
		<!-- <Tab bind:group={tabSet} name="tab1" value={2}>
			<span>Referências Pessoais</span>
		</Tab> -->

		<!-- Tab Panels --->
		<svelte:fragment slot="panel">
			<div class="p-4">
				{#if tabSet === 1}
					<SuperDebug data={$form} />
					<div class="row">
						<div class="sm:col-6 md:col-4 mb-2">
							<label class="label">
								<span>Nome</span>
								<input class="input" type="text" name="nome" bind:value={$form.nome} />
							</label>
						</div>
						<div class="sm:col-6 md:col-4 mb-2">
							<label class="label">
								<span>Email</span>
								<input class="input" type="email" name="email" bind:value={$form.email} />
							</label>
						</div>
						<div class="sm:col-6 md:col-4 mb-2">
							<!-- svelte-ignore a11y-label-has-associated-control -->
							<label class="label flex flex-col">
								<span>Parceiro</span>
								<SlideToggle size="lg" name="slide" bind:checked={$form.parceiro} />
							</label>
						</div>

						<div class="sm:col-6 md:col-4 mb-2">
							<label class="label">
								<span>CPF/CNPJ</span>
								<input class="input" type="text" name="cpfcnpj" bind:value={$form.cpfcnpj} />
							</label>
						</div>

						<!-- campo de nascimento -->
						<div class="sm:col-4 md:col-2 mb-2">
							<label class="label">
								<span>Data de Nascimento</span>
								<input class="input" type="date" name="nascimento" bind:value={$form.nascimento} />
							</label>
						</div>
						<div class="col-12"></div>
						<!-- campo de celular -->
						<div class="sm:col-6 md:col-4 mb-2">
							<label class="label">
								<span>Celular</span>
								<input class="input" type="text" name="celular" bind:value={$form.celular} />
							</label>
						</div>
						<!-- campo de telefone secundário (opcional) -->
						<div class="sm:col-6 md:col-4 mb-2">
							<label class="label">
								<span>Telefone</span>
								<input class="input" type="text" name="telefone" bind:value={$form.telefone} />
							</label>
						</div>
						<div class="col-12"></div>
						<!-- campo de cep -->
						<div class="sm:col-4 md:col-2 mb-2">
							<label class="label">
								<span>CEP</span>
								<input class="input" type="text" name="cep" bind:value={$form.cep} />
							</label>
						</div>
						<!-- campo de endereço -->
						<div class="sm:col-6 md:col-4 mb-2">
							<label class="label">
								<span>Endereço</span>
								<input class="input" type="text" name="endereco" bind:value={$form.endereco} />
							</label>
						</div>
						<!-- campo de número -->
						<div class="sm:col-4 md:col-2 mb-2">
							<label class="label">
								<span>Número</span>
								<input class="input" type="number" name="numero" bind:value={$form.numero} />
							</label>
						</div>
						<!-- campo de complemento -->
						<div class="sm:col-6 md:col-4 mb-2">
							<label class="label">
								<span>Complemento</span>
								<input
									class="input"
									type="text"
									name="complemento"
									bind:value={$form.complemento}
								/>
							</label>
						</div>
						<!-- campo de bairro -->
						<div class="sm:col-6 md:col-4 mb-2">
							<label class="label">
								<span>Bairro</span>
								<input class="input" type="text" name="bairro" bind:value={$form.bairro} />
							</label>
						</div>
						<!-- campo de cidade -->
						<div class="sm:col-6 md:col-4 mb-2">
							<label class="label">
								<span>Cidade</span>
								<input class="input" type="text" name="cidade" bind:value={$form.cidade} />
							</label>
						</div>
						<!-- campo de estado -->
						<div class="sm:col-6 md:col-4 mb-2">
							<label class="label">
								<span>Estado</span>
								<input class="input" type="text" name="estado" bind:value={$form.estado} />
								<select class="select">
									<option value="1">Option 1</option>
									<option value="2">Option 2</option>
									<option value="3">Option 3</option>
									<option value="4">Option 4</option>
									<option value="5">Option 5</option>
								</select>
							</label>
						</div>
						<!-- campo de código de município -->
						<div class="sm:col-6 md:col-4 mb-2">
							<label class="label">
								<span>Código de Município</span>
								<input
									class="input"
									type="text"
									name="codMunicipio"
									bind:value={$form.codMunicipio}
								/>
							</label>
						</div>
						<!-- radio group de tipo consumidor, tendo as opções Consumidor final e consumidor normal -->
						<div class="sm:col-4 md:col-2 mb-2">
							<label class="label">
								<span>Tipo de consumidor</span>
								<label class="flex items-center label space-x-2">
									<input
										class="radio"
										type="radio"
										bind:group={$form.tipoConsumidor}
										name="tipoConsumidor"
										value="final"
									/>
									<p>Consumidor Final</p>
								</label>
								<label class="flex items-center space-x-2">
									<input
										class="radio"
										type="radio"
										bind:group={$form.tipoConsumidor}
										name="tipoConsumidor"
										value="normal"
									/>
									<p>Consumidor Normal</p>
								</label>
							</label>
						</div>
						<div class="sm:col-8 md:col-6 mb-2">
							<label class="label">
								<span>Tipo Contribuinte</span>
								<label class="flex items-center label space-x-2">
									<input
										class="radio"
										type="radio"
										bind:group={$form.tipoConsumidor}
										name="tipoConsumidor"
										value="contribuinte"
									/>
									<p>Contribuinte de ICMS (IE do destinatário obrigatória)</p>
								</label>
								<label class="flex items-center space-x-2">
									<input
										class="radio"
										type="radio"
										bind:group={$form.tipoConsumidor}
										name="tipoConsumidor"
										value="isento"
									/>
									<p>Contribuinte isento de Inscrição no cadastro de contribuintes do ICMS</p>
								</label>
								<label class="flex items-center space-x-2">
									<input
										class="radio"
										type="radio"
										bind:group={$form.tipoConsumidor}
										name="tipoConsumidor"
										value="naoContribuinte"
									/>
									<p>
										Não Contribuinte pode ou não possuir IE no cadastro de contribuintes do ICMS
									</p>
								</label>
							</label>
						</div>
					</div>
				{:else if tabSet === 2}
					<div class="row"></div>
				{/if}
			</div>
		</svelte:fragment>
	</TabGroup>
</form>
