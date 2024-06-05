define table fornecedor schemafull TYPE NORMAL
	PERMISSIONS
		FOR SELECT,CREATE,UPDATE,DELETE FULL
;
DEFINE FIELD nome									ON fornecedor TYPE string ASSERT string::len($value) > 1 && string::len($value) < 256;
DEFINE FIELD fantasia							ON fornecedor TYPE string ASSERT string::len($value) > 1 && string::len($value) < 256;
DEFINE FIELD codigo								ON fornecedor TYPE int READONLY DEFAULT {
		LET $max_codigo = ((select value codigo from fornecedor order by codigo desc limit 1)[0] || 0);
		RETURN $max_codigo+1;
};
DEFINE FIELD cpfcnpj							ON fornecedor TYPE string ASSERT	string::len($value) == 14 || string::len($value) == 18;
DEFINE FIELD pessoa								ON fornecedor TYPE string ASSERT string::contains($value, "F") || string::contains($value, "J");
DEFINE FIELD inscricaoEstadual		ON fornecedor TYPE string ASSERT $value != NONE && string::len($value) < 20;
DEFINE FIELD endereco							ON fornecedor TYPE string ASSERT $value != NONE && string::len($value) > 1;
DEFINE FIELD numero								ON fornecedor TYPE string ASSERT $value != NONE && string::len($value) > 1;
DEFINE FIELD bairro								ON fornecedor TYPE string ASSERT $value != NONE && string::len($value) > 1;
DEFINE FIELD cidade								ON fornecedor TYPE string ASSERT string::len($value) > 1;
DEFINE FIELD codMunicipio					ON fornecedor TYPE string ASSERT string::len($value) == 7 || $value == NONE;
DEFINE FIELD uf										ON fornecedor TYPE string ASSERT string::len($value) == 2;
DEFINE FIELD cep									ON fornecedor TYPE string ASSERT string::len($value) == 8;
DEFINE FIELD telefone1						ON fornecedor TYPE string ASSERT string::len($value) > 1;
DEFINE FIELD telefone2						ON fornecedor TYPE string;
DEFINE FIELD email								ON fornecedor TYPE string ASSERT string::is::email($value) || $value == NONE;
DEFINE FIELD observacao						ON fornecedor TYPE string;
DEFINE FIELD responsavelNome			ON fornecedor TYPE string;
DEFINE FIELD responsavelEmail			ON fornecedor TYPE string ASSERT string::is::email($value) || $value == NONE;
DEFINE FIELD responsavelTelefone	ON fornecedor TYPE string;
DEFINE FIELD parceiro							ON fornecedor TYPE bool DEFAULT false;
DEFINE FIELD site									ON fornecedor TYPE string;
DEFINE FIELD criadoEm							ON fornecedor TYPE datetime VALUE $before OR time::now() DEFAULT time::now() READONLY;
DEFINE FIELD canceladoEm					ON fornecedor TYPE datetime;
DEFINE FIELD atualizadoEm					ON fornecedor TYPE datetime VALUE time::now() DEFAULT time::now() READONLY;
DEFINE INDEX codigo_index					ON fornecedor FIELDS codigo UNIQUE;
DEFINE INDEX cpfcnpj_index				ON fornecedor FIELDS cpfcnpj UNIQUE;


DEFINE TABLE tabela SCHEMAFULL TYPE NORMAL
	PERMISSIONS
		FOR SELECT,CREATE,UPDATE,DELETE FULL
;
DEFINE FIELD descricao						ON tabela TYPE string ASSERT string::len($value) > 2;
DEFINE FIELD criadoEm							ON tabela TYPE datetime VALUE $before OR time::now() DEFAULT time::now() READONLY;
DEFINE FIELD atualizadoEm					ON tabela TYPE datetime VALUE time::now() DEFAULT time::now() READONLY;
DEFINE INDEX tabela_desc_index		ON tabela FIELDS descricao UNIQUE;


DEFINE TABLE grupo SCHEMAFULL TYPE NORMAL
	PERMISSIONS
		FOR SELECT,CREATE,UPDATE,DELETE FULL
;
DEFINE FIELD descricao						ON grupo TYPE string ASSERT string::len($value) > 2;
DEFINE FIELD tabela								ON grupo TYPE record<tabela> ASSERT $value != NONE;
DEFINE FIELD criadoEm							ON grupo TYPE datetime VALUE $before OR time::now() DEFAULT time::now() READONLY;
DEFINE FIELD atualizadoEm					ON grupo TYPE datetime VALUE time::now() DEFAULT time::now() READONLY;
DEFINE INDEX tabela_grupo_index		ON grupo FIELDS tabela,descricao UNIQUE;


DEFINE TABLE subgrupo SCHEMAFULL TYPE NORMAL
	PERMISSIONS
		FOR SELECT,CREATE,UPDATE,DELETE FULL
;
DEFINE FIELD descricao						ON subgrupo TYPE string ASSERT string::len($value) > 2;
DEFINE FIELD comissao							ON subgrupo TYPE number ASSERT $value >= 0 && $value <= 100 DEFAULT 0;
DEFINE FIELD grupo								ON subgrupo TYPE record<grupo> ASSERT $value != NONE;
DEFINE FIELD criadoEm							ON subgrupo TYPE datetime VALUE $before OR time::now() DEFAULT time::now() READONLY;
DEFINE FIELD atualizadoEm					ON subgrupo TYPE datetime VALUE time::now() DEFAULT time::now() READONLY;
DEFINE INDEX grupo_subgrupo_index ON subgrupo FIELDS grupo,descricao UNIQUE;


DEFINE TABLE produto SCHEMAFULL TYPE NORMAL
	PERMISSIONS
		FOR SELECT,CREATE,UPDATE,DELETE FULL
;
DEFINE FIELD fornecedor						ON produto TYPE record<fornecedor> ASSERT $value != NONE;
DEFINE FIELD descricao						ON produto TYPE string ASSERT string::len($value) > 2;
DEFINE FIELD unidade							ON produto TYPE string ASSERT string::len($value) > 1;
DEFINE FIELD tabela								ON produto TYPE record<tabela> ASSERT $value != NONE;
DEFINE FIELD grupo								ON produto TYPE record<grupo> ASSERT $value != NONE;
DEFINE FIELD subgrupo							ON produto TYPE record<subgrupo> ASSERT $value != NONE;
DEFINE FIELD ativo								ON produto TYPE bool DEFAULT true;
DEFINE FIELD precoCompraAprovar		ON produto TYPE number ASSERT $value > 0;
DEFINE FIELD precoCompraAprovado	ON produto TYPE number ASSERT $value > 0;
DEFINE FIELD precoVendaAprovar		ON produto TYPE number ASSERT $value > 0;
DEFINE FIELD precoVendaAprovado		ON produto TYPE number ASSERT $value > 0;
DEFINE FIELD precoCustoAprovar		ON produto TYPE number ASSERT $value > 0;
DEFINE FIELD precoCustoAprovado		ON produto TYPE number ASSERT $value > 0;
DEFINE FIELD descontoMaximo				ON produto TYPE number ASSERT $value >= 0 && $value <= 100 DEFAULT 0;
DEFINE FIELD comissao							ON produto TYPE number ASSERT $value >= 0 && $value <= 100 DEFAULT 0;
DEFINE FIELD comissaoGerente			ON produto TYPE number ASSERT $value >= 0 && $value <= 100 DEFAULT 0;
DEFINE FIELD mix									ON produto TYPE bool DEFAULT false;
DEFINE FIELD codigoBarra					ON produto TYPE string;
DEFINE FIELD codigo								ON produto TYPE number READONLY DEFAULT {
	LET $max_codigo = (select value codigo from produto order by codigo desc limit 1)[0] || 0;
	RETURN $max_codigo+1;
};
DEFINE FIELD codigoDisplay				ON produto TYPE string READONLY DEFAULT {
	RETURN string::concat("S",$this.fornecedor.codigo,"P",$this.codigo)
};
DEFINE FIELD criadoEm							ON produto TYPE datetime VALUE $before OR time::now() DEFAULT time::now() READONLY;
DEFINE FIELD atualizadoEm					ON produto TYPE datetime VALUE time::now() DEFAULT time::now() READONLY;
DEFINE INDEX codigo_index					ON produto FIELDS codigo UNIQUE;
DEFINE INDEX codigoDisplay_index	ON produto FIELDS codigoDisplay UNIQUE;
DEFINE INDEX descricao_index 			ON produto FIELDS descricao UNIQUE;


DEFINE TABLE acabamento SCHEMAFULL TYPE NORMAL
	PERMISSIONS
		FOR SELECT,CREATE,UPDATE,DELETE FULL
;
DEFINE FIELD descricao						ON acabamento TYPE string ASSERT string::len($value) > 2;
DEFINE FIELD criadoEm							ON acabamento TYPE datetime VALUE $before OR time::now() DEFAULT time::now() READONLY;
DEFINE FIELD atualizadoEm					ON acabamento TYPE datetime VALUE time::now() DEFAULT time::now() READONLY;
DEFINE FIELD codigo								ON acabamento TYPE number READONLY DEFAULT {
	LET $max_codigo = (select value codigo from acabamento order by codigo desc limit 1)[0] || 0;
	RETURN $max_codigo+1;
};
DEFINE INDEX descricao_index 			ON acabamento FIELDS descricao UNIQUE;
DEFINE INDEX codigo_index					ON acabamento FIELDS codigo UNIQUE;


DEFINE TABLE cor SCHEMAFULL TYPE NORMAL
	PERMISSIONS
		FOR SELECT,CREATE,UPDATE,DELETE FULL
;
DEFINE FIELD descricao						ON cor TYPE string ASSERT string::len($value) > 2;
DEFINE FIELD criadoEm							ON cor TYPE datetime VALUE $before OR time::now() DEFAULT time::now() READONLY;
DEFINE FIELD atualizadoEm					ON cor TYPE datetime VALUE time::now() DEFAULT time::now() READONLY;
DEFINE FIELD codigo								ON cor TYPE number READONLY DEFAULT {
	LET $max_codigo = (select value codigo from cor order by codigo desc limit 1)[0] || 0;
	RETURN $max_codigo+1;
};
DEFINE INDEX descricao_index 			ON cor FIELDS descricao UNIQUE;
DEFINE INDEX codigo_index					ON cor FIELDS codigo UNIQUE;


DEFINE TABLE produtoGrade SCHEMAFULL TYPE NORMAL
	PERMISSIONS
		FOR SELECT,CREATE,UPDATE,DELETE FULL
;
DEFINE FIELD produto							ON produtoGrade TYPE record<produto> ASSERT $value != NONE;
DEFINE FIELD cor									ON produtoGrade TYPE record<cor> ASSERT $value != NONE;
DEFINE FIELD acabamento						ON produtoGrade TYPE record<acabamento>;
DEFINE FIELD ativo								ON produtoGrade TYPE bool DEFAULT true;
DEFINE FIELD criadoEm							ON produtoGrade TYPE datetime VALUE $before OR time::now() DEFAULT time::now() READONLY;
DEFINE FIELD atualizadoEm					ON produtoGrade TYPE datetime VALUE time::now() DEFAULT time::now() READONLY;
DEFINE INDEX produtoGrade_index 	ON produtoGrade FIELDS produto,cor,acabamento UNIQUE;


DEFINE TABLE empresa SCHEMAFULL TYPE NORMAL
	PERMISSIONS
		FOR SELECT,CREATE,UPDATE,DELETE FULL
;
DEFINE FIELD nome									ON empresa TYPE string ASSERT string::len($value) > 2;
DEFINE FIELD codigo								ON cor TYPE number READONLY DEFAULT {
	LET $max_codigo = (select value codigo from cor order by codigo desc limit 1)[0] || 0;
	RETURN $max_codigo+1;
};
DEFINE FIELD fantasia							ON empresa TYPE string ASSERT string::len($value) > 2;
DEFINE FIELD cnpj									ON empresa TYPE string ASSERT string::len($value) == 14;
DEFINE FIELD inscricaoEstadual		ON empresa TYPE string ASSERT string::len($value) < 20;
DEFINE FIELD endereco							ON empresa TYPE string ASSERT string::len($value) > 2;
DEFINE FIELD numero								ON empresa TYPE string ASSERT string::len($value) > 1;
DEFINE FIELD complemento					ON empresa TYPE string;
DEFINE FIELD bairro								ON empresa TYPE string ASSERT string::len($value) > 1;
DEFINE FIELD cidade								ON empresa TYPE string ASSERT string::len($value) > 1;
DEFINE FIELD codMunicipio					ON empresa TYPE string ASSERT string::len($value) == 7;
DEFINE FIELD uf										ON empresa TYPE string ASSERT string::len($value) == 2;
DEFINE FIELD cep									ON empresa TYPE string ASSERT string::len($value) == 8;
DEFINE FIELD telefone1						ON empresa TYPE string ASSERT string::len($value) > 1;
DEFINE FIELD telefone2						ON empresa TYPE string;
DEFINE FIELD email								ON empresa TYPE string;
DEFINE FIELD criadoEm							ON empresa TYPE datetime VALUE $before OR time::now() DEFAULT time::now() READONLY;
DEFINE FIELD atualizadoEm					ON empresa TYPE datetime VALUE time::now() DEFAULT time::now() READONLY;


DEFINE TABLE cliente SCHEMAFULL TYPE NORMAL
	PERMISSIONS
		FOR SELECT,CREATE,UPDATE,DELETE FULL
;
DEFINE FIELD nome									ON cliente TYPE string ASSERT string::len($value) > 2;
DEFINE FIELD fantasia							ON cliente TYPE string ASSERT string::len($value) > 2;
DEFINE FIELD cpfcnpj							ON cliente TYPE string ASSERT string::len($value) == 14 || string::len($value) == 18;
DEFINE FIELD pessoa								ON cliente TYPE string ASSERT string::contains($value, "F") || string::contains($value, "J");
DEFINE FIELD inscricaoEstadual		ON cliente TYPE string ASSERT string::len($value) < 20;
DEFINE FIELD endereco							ON cliente TYPE string ASSERT $value != NONE && string::len($value) > 1;
DEFINE FIELD numero								ON cliente TYPE string ASSERT $value != NONE && string::len($value) > 1;
DEFINE FIELD complemento					ON cliente TYPE string;
DEFINE FIELD bairro								ON cliente TYPE string ASSERT $value != NONE && string::len($value) > 1;
DEFINE FIELD cidade								ON cliente TYPE string ASSERT string::len($value) > 1;
DEFINE FIELD codMunicipio					ON cliente TYPE string ASSERT string::len($value) == 7;
DEFINE FIELD uf										ON cliente TYPE string ASSERT string::len($value) == 2;
DEFINE FIELD cep									ON cliente TYPE string ASSERT string::len($value) == 8;
DEFINE FIELD telefone1						ON cliente TYPE string ASSERT string::len($value) > 1;
DEFINE FIELD telefone2						ON cliente TYPE string;
DEFINE FIELD email								ON cliente TYPE string ASSERT string::len($value) > 1;
DEFINE FIELD criadoEm							ON cliente TYPE datetime VALUE $before OR time::now() DEFAULT time::now() READONLY;
DEFINE FIELD canceladoEm					ON cliente TYPE datetime;
DEFINE FIELD atualizadoEm					ON cliente TYPE datetime VALUE time::now() DEFAULT time::now() READONLY;


DEFINE TABLE funcionario SCHEMAFULL TYPE NORMAL
	PERMISSIONS
		FOR SELECT,CREATE,UPDATE,DELETE FULL
;
DEFINE FIELD nome									ON funcionario TYPE string ASSERT string::len($value) > 2;
DEFINE FIELD cpfcnpj							ON funcionario TYPE string ASSERT string::len($value) == 14;
DEFINE FIELD pessoa								ON funcionario TYPE string ASSERT $value INSIDE ['F','J'];
DEFINE FIELD inscricaoEstadual		ON funcionario TYPE string ASSERT string::len($value) < 20;
DEFINE FIELD nascimento						ON funcionario TYPE datetime ASSERT type::is::datetime(type::datetime($value));
DEFINE FIELD endereco							ON funcionario TYPE string ASSERT $value != NONE && string::len($value) > 1;
DEFINE FIELD numero								ON funcionario TYPE string ASSERT $value != NONE && string::len($value) > 1;
DEFINE FIELD complemento					ON funcionario TYPE string;
DEFINE FIELD bairro								ON funcionario TYPE string ASSERT $value != NONE && string::len($value) > 1;
DEFINE FIELD cidade								ON funcionario TYPE string ASSERT string::len($value) > 1;
DEFINE FIELD codMunicipio					ON funcionario TYPE string ASSERT string::len($value) == 7;
DEFINE FIELD uf										ON funcionario TYPE string ASSERT string::len($value) == 2;
DEFINE FIELD cep									ON funcionario TYPE string ASSERT string::len($value) == 8;
DEFINE FIELD telefone1						ON funcionario TYPE string ASSERT string::len($value) > 1;
DEFINE FIELD telefone2						ON funcionario TYPE string;
DEFINE FIELD email								ON funcionario TYPE string ASSERT string::len($value) > 1;
DEFINE FIELD apelido							ON funcionario TYPE string;
DEFINE FIELD comissao							ON funcionario TYPE number ASSERT $value >= 0 && $value <= 100;
DEFINE FIELD admitidoEm						ON funcionario TYPE datetime ASSERT type::is::datetime(type::datetime($value));
DEFINE FIELD demitidoEm						ON funcionario TYPE datetime;
DEFINE FIELD criadoEm							ON funcionario TYPE datetime VALUE $before OR time::now() DEFAULT time::now() READONLY;
DEFINE FIELD canceladoEm					ON funcionario TYPE datetime;
DEFINE FIELD atualizadoEm					ON funcionario TYPE datetime VALUE time::now() DEFAULT time::now() READONLY;


DEFINE TABLE pedidoVenda SCHEMAFULL TYPE NORMAL
	PERMISSIONS
		FOR SELECT,CREATE,UPDATE,DELETE FULL
;
DEFINE FIELD empresa							ON pedidoVenda TYPE record<empresa> ASSERT $value != NONE;
DEFINE FIELD cliente							ON pedidoVenda TYPE record<cliente> ASSERT $value != NONE;
DEFINE FIELD produtoGrade					ON pedidoVenda TYPE record<produtoGrade> ASSERT $value != NONE;
DEFINE FIELD funcionario					ON pedidoVenda TYPE record<funcionario> ASSERT $value != NONE;
DEFINE FIELD dataPedido						ON pedidoVenda TYPE datetime ASSERT type::is::datetime(type::datetime($value));
DEFINE FIELD dataEntrega					ON pedidoVenda TYPE datetime ASSERT type::is::datetime(type::datetime($value));
DEFINE FIELD observacao						ON pedidoVenda TYPE string;
DEFINE FIELD criadoEm							ON pedidoVenda TYPE datetime VALUE $before OR time::now() DEFAULT time::now() READONLY;
DEFINE FIELD canceladoEm					ON pedidoVenda TYPE datetime;
DEFINE FIELD atualizadoEm					ON pedidoVenda TYPE datetime VALUE time::now() DEFAULT time::now() READONLY;


DEFINE TABLE crmCategoria SCHEMAFULL TYPE NORMAL
	PERMISSIONS
		FOR SELECT,CREATE,UPDATE,DELETE FULL
;
DEFINE FIELD descricao						ON crmCategoria TYPE string ASSERT string::len($value) > 2;
DEFINE FIELD corTexto							ON crmCategoria TYPE record<cor> ASSERT $value != NONE;
DEFINE FIELD corFundo							ON crmCategoria TYPE record<cor> ASSERT $value != NONE;
DEFINE FIELD criadoEm							ON crmCategoria TYPE datetime VALUE $before OR time::now() DEFAULT time::now() READONLY;
DEFINE FIELD atualizadoEm					ON crmCategoria TYPE datetime VALUE time::now() DEFAULT time::now() READONLY;


DEFINE TABLE crm SCHEMAFULL TYPE NORMAL
	PERMISSIONS
		FOR SELECT,CREATE,UPDATE,DELETE FULL
;
DEFINE FIELD empresa							ON crm TYPE record<empresa> ASSERT $value != NONE;
DEFINE FIELD cliente							ON crm TYPE record<cliente> ASSERT $value != NONE;
DEFINE FIELD categoria						ON crm TYPE record<crmCategoria> ASSERT $value != NONE;
DEFINE FIELD funcionario					ON crm TYPE record<funcionario> ASSERT $value != NONE;
DEFINE FIELD dataAgendada					ON crm TYPE datetime ASSERT type::is::datetime(type::datetime($value));
DEFINE FIELD dataRealizada				ON crm TYPE datetime;
DEFINE FIELD criadoEm							ON crm TYPE datetime VALUE $before OR time::now() DEFAULT time::now() READONLY;
DEFINE FIELD canceladoEm					ON crm TYPE datetime;
DEFINE FIELD atualizadoEm					ON crm TYPE datetime VALUE time::now() DEFAULT time::now() READONLY;


DEFINE TABLE crmObservacoes SCHEMAFULL TYPE NORMAL
	PERMISSIONS
		FOR SELECT,CREATE,UPDATE,DELETE FULL
;
DEFINE FIELD crm									ON crmObservacoes TYPE record<crm> ASSERT $value != NONE;
DEFINE FIELD descricao						ON crmObservacoes TYPE string ASSERT string::len($value) > 2;
DEFINE FIELD categoriaAntes				ON crmObservacoes TYPE record<crmCategoria>;
DEFINE FIELD categoriaDepois			ON crmObservacoes TYPE record<crmCategoria>;
DEFINE FIELD criadoEm							ON crmObservacoes TYPE datetime VALUE $before OR time::now() DEFAULT time::now() READONLY;
DEFINE FIELD atualizadoEm					ON crmObservacoes TYPE datetime VALUE time::now() DEFAULT time::now() READONLY;


DEFINE TABLE usuario TYPE NORMAL SCHEMAFULL PERMISSIONS FOR SELECT,CREATE,UPDATE,DELETE FULL;

DEFINE FIELD email 								ON usuario TYPE string ASSERT string::is::email($value) || $value == NONE;
DEFINE FIELD empresa 							ON usuario TYPE record<empresa> ASSERT $value != NONE;
DEFINE FIELD funcionario 					ON usuario TYPE record<funcionario> ASSERT $value != NONE;
DEFINE FIELD login 								ON usuario TYPE string ASSERT $value != NONE;
DEFINE FIELD senha 								ON usuario TYPE string ASSERT string::len($value) > 6;
DEFINE FIELD criadoEm 						ON usuario TYPE datetime VALUE $before OR time::now() DEFAULT time::now() READONLY;
DEFINE FIELD atualizadoEm 				ON usuario TYPE datetime VALUE time::now() DEFAULT time::now() READONLY;
DEFINE FIELD canceladoEm 					ON usuario TYPE datetime;

DEFINE INDEX login_unico ON usuario FIELDS login UNIQUE;

DEFINE TABLE tela SCHEMAFULL TYPE NORMAL
	PERMISSIONS
		FOR SELECT,CREATE,UPDATE,DELETE FULL
;
DEFINE FIELD menu									ON tela TYPE string ASSERT string::len($value) >= 2;
DEFINE FIELD submenu							ON tela TYPE string ASSERT string::len($value) >= 2;
DEFINE FIELD codigo								ON tela TYPE number ASSERT $value > 0;
DEFINE FIELD icone								ON tela TYPE string ASSERT string::len($value) > 2;
DEFINE FIELD url									ON tela TYPE string ASSERT $value != NONE;
DEFINE FIELD criadoEm 						ON tela TYPE datetime VALUE $before OR time::now() DEFAULT time::now() READONLY;
DEFINE FIELD atualizadoEm 				ON tela TYPE datetime VALUE time::now() DEFAULT time::now() READONLY;
DEFINE FIELD canceladoEm 					ON tela TYPE option<datetime>;

DEFINE INDEX codigo_unico ON tela FIELDS codigo UNIQUE;
DEFINE INDEX submenu_unico ON tela FIELDS submenu UNIQUE;
DEFINE INDEX ordem_unica ON tela FIELDS ordem UNIQUE;

DEFINE TABLE permissaoTela SCHEMAFULL TYPE NORMAL
	PERMISSIONS
		FOR SELECT,CREATE,UPDATE,DELETE FULL
;
DEFINE FIELD usuario							ON permissaoTela TYPE record<usuario> ASSERT $value != NONE;
DEFINE FIELD tela									ON permissaoTela TYPE record<tela> ASSERT $value != NONE;
DEFINE FIELD permissao						ON permissaoTela TYPE string ASSERT $value INSIDE ['visualizar','criar','editar','deletar','relatorio'];
DEFINE FIELD criadoEm 						ON permissaoTela TYPE datetime VALUE $before OR time::now() DEFAULT time::now() READONLY;
DEFINE FIELD atualizadoEm 				ON permissaoTela TYPE datetime VALUE time::now() DEFAULT time::now() READONLY;
DEFINE FIELD canceladoEm 					ON permissaoTela TYPE datetime;

DEFINE INDEX usuario_tela_unico ON permissaoTela FIELDS usuario,tela,permissao UNIQUE;

