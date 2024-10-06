DEFINE TABLE estado SCHEMAFULL CHANGEFEED 30d
	PERMISSIONS
		FOR SELECT,CREATE,UPDATE,DELETE FULL
;
DEFINE FIELD nome									ON estado TYPE string ASSERT string::len($value) > 2;
DEFINE FIELD sigla								ON estado TYPE string ASSERT string::len($value) == 2;
DEFINE FIELD listaCidades 				ON estado TYPE array<record<cidade>> DEFAULT [];
DEFINE FIELD criadoEm 						ON estado TYPE datetime VALUE $before OR time::now() DEFAULT time::now() READONLY;
DEFINE FIELD canceladoEm 					ON estado TYPE datetime | null DEFAULT null;
DEFINE FIELD atualizadoEm 				ON estado TYPE datetime VALUE time::now() DEFAULT time::now() READONLY;

DEFINE INDEX uf_unico ON estado FIELDS sigla UNIQUE;

DEFINE TABLE cidade SCHEMAFULL
	PERMISSIONS
		FOR SELECT,CREATE,UPDATE,DELETE FULL
;
DEFINE FIELD nome									ON cidade TYPE string ASSERT string::len($value) > 2;
DEFINE FIELD estado								ON cidade TYPE record<estado> ;
DEFINE FIELD codigoIbge						ON cidade TYPE string ASSERT string::len($value) == 7;
DEFINE FIELD criadoEm 						ON cidade TYPE datetime VALUE $before OR time::now() DEFAULT time::now() READONLY;
DEFINE FIELD canceladoEm 					ON cidade TYPE datetime | null DEFAULT null;
DEFINE FIELD atualizadoEm 				ON cidade TYPE datetime VALUE time::now() DEFAULT time::now() READONLY;

DEFINE INDEX codigoIbge 					ON cidade FIELDS codigoIbge UNIQUE;

DEFINE TABLE enderecoCompleto SCHEMAFULL
	PERMISSIONS
		FOR SELECT,CREATE,UPDATE,DELETE FULL
;
DEFINE FIELD dono									ON enderecoCompleto TYPE record;
DEFINE FIELD rua									ON enderecoCompleto TYPE string ASSERT string::len($value) > 2;
DEFINE FIELD numero								ON enderecoCompleto TYPE number ASSERT $value > 0;
DEFINE FIELD complemento					ON enderecoCompleto TYPE string | null DEFAULT null;
DEFINE FIELD bairro								ON enderecoCompleto TYPE string ASSERT string::len($value) > 2;
DEFINE FIELD cidade								ON enderecoCompleto TYPE record<cidade>;
DEFINE FIELD estado								ON enderecoCompleto TYPE record<estado>;
DEFINE FIELD cep									ON enderecoCompleto TYPE string ASSERT string::len($value) == 8;
DEFINE FIELD criadoEm 						ON enderecoCompleto TYPE datetime VALUE $before OR time::now() DEFAULT time::now() READONLY;
DEFINE FIELD canceladoEm 					ON enderecoCompleto TYPE datetime | null DEFAULT null;
DEFINE FIELD atualizadoEm 				ON enderecoCompleto TYPE datetime VALUE time::now() DEFAULT time::now() READONLY;

DEFINE EVENT enderecoadicionado ON TABLE enderecoCompleto WHEN $event = 'CREATE' THEN {
    let $ids = SELECT value id FROM enderecoCompleto where dono == $after.dono;
    UPDATE $after.dono SET enderecos = (
        SELECT value id FROM enderecoCompleto where dono = $after.dono
    )
};


define table fornecedor schemafull
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
DEFINE FIELD inscricaoEstadual		ON fornecedor TYPE string | null DEFAULT null;
DEFINE FIELD enderecoCompleto			ON fornecedor TYPE record<enderecoCompleto> ;
DEFINE FIELD telefone1						ON fornecedor TYPE string ASSERT string::len($value) > 1;
DEFINE FIELD telefone2						ON fornecedor TYPE string | null DEFAULT null;
DEFINE FIELD email								ON fornecedor TYPE string | null DEFAULT null ASSERT string::is::email($value) || $value == null;
DEFINE FIELD observacao						ON fornecedor TYPE string | null DEFAULT null;
DEFINE FIELD responsavelNome			ON fornecedor TYPE string | null DEFAULT null;
DEFINE FIELD responsavelEmail			ON fornecedor TYPE string | null DEFAULT null ASSERT string::is::email($value) || $value == null;
DEFINE FIELD responsavelTelefone	ON fornecedor TYPE string | null DEFAULT null;
DEFINE FIELD parceiro							ON fornecedor TYPE bool DEFAULT false;
DEFINE FIELD site									ON fornecedor TYPE string | null DEFAULT null;
DEFINE FIELD criadoEm							ON fornecedor TYPE datetime VALUE $before OR time::now() DEFAULT time::now() READONLY;
DEFINE FIELD canceladoEm					ON fornecedor TYPE datetime| null DEFAULT null;
DEFINE FIELD atualizadoEm					ON fornecedor TYPE datetime VALUE time::now() DEFAULT time::now() READONLY;
DEFINE INDEX codigo_index					ON fornecedor FIELDS codigo UNIQUE;
DEFINE INDEX cpfcnpj_index				ON fornecedor FIELDS cpfcnpj UNIQUE;

DEFINE TABLE produtoCategoria SCHEMAFULL
	PERMISSIONS
		FOR SELECT,CREATE,UPDATE,DELETE FULL
;
DEFINE FIELD tabela								ON produtoCategoria TYPE string ASSERT string::len($value) > 2;
DEFINE FIELD grupo								ON produtoCategoria TYPE string ASSERT string::len($value) > 2;
DEFINE FIELD subgrupo							ON produtoCategoria TYPE string ASSERT string::len($value) > 2;
DEFINE FIELD criadoEm							ON produtoCategoria TYPE datetime VALUE $before OR time::now() DEFAULT time::now() READONLY;
DEFINE FIELD canceladoEm					ON produtoCategoria TYPE datetime| null DEFAULT null;
DEFINE FIELD atualizadoEm					ON produtoCategoria TYPE datetime VALUE time::now() DEFAULT time::now() READONLY;
DEFINE FIELD comissao							ON produtoCategoria TYPE number ASSERT $value >= 0 && $value <= 100 DEFAULT 0;

DEFINE TABLE produto SCHEMAFULL
	PERMISSIONS
		FOR SELECT,CREATE,UPDATE,DELETE FULL
;
DEFINE FIELD fornecedor						ON produto TYPE record<fornecedor> ;
DEFINE FIELD descricao						ON produto TYPE string ASSERT string::len($value) > 2;
DEFINE FIELD unidade							ON produto TYPE string ASSERT string::len($value) > 1;
DEFINE FIELD produtoCategoria			ON produto TYPE record<produtoCategoria> ;
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
DEFINE FIELD codigoBarra					ON produto TYPE string | null DEFAULT null;
DEFINE FIELD codigo								ON produto TYPE number READONLY DEFAULT {
	LET $max_codigo = (select value codigo from produto order by codigo desc limit 1)[0] || 0;
	RETURN $max_codigo+1;
};
DEFINE FIELD criadoEm							ON produto TYPE datetime VALUE $before OR time::now() DEFAULT time::now() READONLY;
DEFINE FIELD canceladoEm					ON produto TYPE datetime | null DEFAULT null;
DEFINE FIELD atualizadoEm					ON produto TYPE datetime VALUE time::now() DEFAULT time::now() READONLY;
DEFINE INDEX codigo_index					ON produto FIELDS codigo UNIQUE;
DEFINE INDEX codigoDisplay_index	ON produto FIELDS codigoDisplay UNIQUE;
DEFINE INDEX descricao_index 			ON produto FIELDS descricao UNIQUE;


DEFINE TABLE acabamento SCHEMAFULL
	PERMISSIONS
		FOR SELECT,CREATE,UPDATE,DELETE FULL
;
DEFINE FIELD descricao						ON acabamento TYPE string ASSERT string::len($value) > 2;
DEFINE FIELD criadoEm							ON acabamento TYPE datetime VALUE $before OR time::now() DEFAULT time::now() READONLY;
DEFINE FIELD canceladoEm					ON acabamento TYPE datetime | null DEFAULT null;
DEFINE FIELD atualizadoEm					ON acabamento TYPE datetime VALUE time::now() DEFAULT time::now() READONLY;
DEFINE FIELD codigo								ON acabamento TYPE number READONLY DEFAULT {
	LET $max_codigo = (select value codigo from acabamento order by codigo desc limit 1)[0] || 0;
	RETURN $max_codigo+1;
};
DEFINE INDEX descricao_index 			ON acabamento FIELDS descricao UNIQUE;
DEFINE INDEX codigo_index					ON acabamento FIELDS codigo UNIQUE;


DEFINE TABLE cor SCHEMAFULL
	PERMISSIONS
		FOR SELECT,CREATE,UPDATE,DELETE FULL
;
DEFINE FIELD descricao						ON cor TYPE string ASSERT string::len($value) > 2;
DEFINE FIELD criadoEm							ON cor TYPE datetime VALUE $before OR time::now() DEFAULT time::now() READONLY;
DEFINE FIELD canceladoEm					ON cor TYPE datetime | null DEFAULT null;
DEFINE FIELD atualizadoEm					ON cor TYPE datetime VALUE time::now() DEFAULT time::now() READONLY;
DEFINE FIELD codigo								ON cor TYPE number READONLY DEFAULT {
	LET $max_codigo = (select value codigo from cor order by codigo desc limit 1)[0] || 0;
	RETURN $max_codigo+1;
};
DEFINE INDEX descricao_index 			ON cor FIELDS descricao UNIQUE;
DEFINE INDEX codigo_index					ON cor FIELDS codigo UNIQUE;


DEFINE TABLE produtoGrade SCHEMAFULL
	PERMISSIONS
		FOR SELECT,CREATE,UPDATE,DELETE FULL
;
DEFINE FIELD produto							ON produtoGrade TYPE record<produto> ;
DEFINE FIELD cor									ON produtoGrade TYPE record<cor> ;
DEFINE FIELD acabamento						ON produtoGrade TYPE record<acabamento> | null;
DEFINE FIELD ativo								ON produtoGrade TYPE bool DEFAULT true;
DEFINE FIELD criadoEm							ON produtoGrade TYPE datetime VALUE $before OR time::now() DEFAULT time::now() READONLY;
DEFINE FIELD canceladoEm					ON produtoGrade TYPE datetime | null DEFAULT null;
DEFINE FIELD atualizadoEm					ON produtoGrade TYPE datetime VALUE time::now() DEFAULT time::now() READONLY;
DEFINE INDEX produtoGrade_index 	ON produtoGrade FIELDS produto,cor,acabamento UNIQUE;


DEFINE TABLE empresa SCHEMAFULL
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
DEFINE FIELD enderecoCompleto			ON empresa TYPE record<enderecoCompleto> ;
DEFINE FIELD telefone1						ON empresa TYPE string ASSERT string::len($value) > 1;
DEFINE FIELD telefone2						ON empresa TYPE string | null DEFAULT null;
DEFINE FIELD email								ON empresa TYPE string | null ASSERT $value == null || string::is::email($value) DEFAULT null;
DEFINE FIELD criadoEm							ON empresa TYPE datetime VALUE $before OR time::now() DEFAULT time::now() READONLY;
DEFINE FIELD canceladoEm					ON empresa TYPE datetime | null DEFAULT null;
DEFINE FIELD atualizadoEm					ON empresa TYPE datetime VALUE time::now() DEFAULT time::now() READONLY;


DEFINE TABLE cliente SCHEMAFULL
	PERMISSIONS
		FOR SELECT,CREATE,UPDATE,DELETE FULL
;
DEFINE FIELD nome									ON cliente TYPE string ASSERT string::len($value) > 2;
DEFINE FIELD fantasia							ON cliente TYPE string ASSERT string::len($value) > 2 || $value == null DEFAULT null;
DEFINE FIELD cpfcnpj							ON cliente TYPE string ASSERT string::len($value) == 14 || string::len($value) == 18;
DEFINE FIELD pessoa								ON cliente TYPE string ASSERT string::contains($value, "F") || string::contains($value, "J");
DEFINE FIELD nascimento						ON cliente TYPE datetime ASSERT type::is::datetime(type::datetime($value));
DEFINE FIELD inscricaoEstadual		ON cliente TYPE string | null ASSERT string::len($value) < 20 || $value == null DEFAULT null;
DEFINE FIELD enderecoCompleto			ON cliente TYPE record<enderecoCompleto | null> DEFAULT null;
DEFINE FIELD telefone1						ON cliente TYPE string ASSERT string::len($value) == 16 || string::len($value) == 14;
DEFINE FIELD telefone2						ON cliente TYPE string | null ASSERT type::is::null($value) || string::len($value) == 16 || string::len($value) == 14 DEFAULT null;
DEFINE FIELD email								ON cliente TYPE string | null ASSERT type::is::null($value) || string::is::email($value);
DEFINE FIELD criadoEm							ON cliente TYPE datetime VALUE $before OR time::now() DEFAULT time::now() READONLY;
DEFINE FIELD canceladoEm					ON cliente TYPE datetime | null DEFAULT null;
DEFINE FIELD atualizadoEm					ON cliente TYPE datetime VALUE time::now() DEFAULT time::now() READONLY;


DEFINE TABLE funcionario SCHEMAFULL
	PERMISSIONS
		FOR SELECT,CREATE,UPDATE,DELETE FULL
;
DEFINE FIELD nome									ON funcionario TYPE string ASSERT string::len($value) > 2;
DEFINE FIELD cpfcnpj							ON funcionario TYPE string ASSERT string::len($value) == 14;
DEFINE FIELD pessoa								ON funcionario TYPE string ASSERT $value INSIDE ['F','J'];
DEFINE FIELD inscricaoEstadual		ON funcionario TYPE string ASSERT string::len($value) < 20;
DEFINE FIELD nascimento						ON funcionario TYPE datetime ASSERT type::is::datetime(type::datetime($value));
DEFINE FIELD enderecoCompleto			ON funcionario TYPE record<enderecoCompleto | null> DEFAULT null;
DEFINE FIELD telefone1						ON funcionario TYPE string ASSERT string::len($value) > 1;
DEFINE FIELD telefone2						ON funcionario TYPE string | null DEFAULT null;
DEFINE FIELD email								ON funcionario TYPE string | null DEFAULT null;
DEFINE FIELD apelido							ON funcionario TYPE string | null DEFAULT null;
DEFINE FIELD comissao							ON funcionario TYPE number ASSERT $value >= 0 && $value <= 100;
DEFINE FIELD admitidoEm						ON funcionario TYPE datetime ASSERT type::is::datetime(type::datetime($value));
DEFINE FIELD demitidoEm						ON funcionario TYPE datetime;
DEFINE FIELD criadoEm							ON funcionario TYPE datetime VALUE $before OR time::now() DEFAULT time::now() READONLY;
DEFINE FIELD canceladoEm					ON funcionario TYPE datetime;
DEFINE FIELD atualizadoEm					ON funcionario TYPE datetime VALUE time::now() DEFAULT time::now() READONLY;


DEFINE TABLE pedidoVenda SCHEMAFULL
	PERMISSIONS
		FOR SELECT,CREATE,UPDATE,DELETE FULL
;
DEFINE FIELD empresa							ON pedidoVenda TYPE record<empresa> ;
DEFINE FIELD cliente							ON pedidoVenda TYPE record<cliente> ;
DEFINE FIELD produtoGrade					ON pedidoVenda TYPE record<produtoGrade> ;
DEFINE FIELD funcionario					ON pedidoVenda TYPE record<funcionario> ;
DEFINE FIELD dataPedido						ON pedidoVenda TYPE datetime ASSERT type::is::datetime(type::datetime($value));
DEFINE FIELD dataEntrega					ON pedidoVenda TYPE datetime ASSERT type::is::datetime(type::datetime($value));
DEFINE FIELD observacao						ON pedidoVenda TYPE string;
DEFINE FIELD criadoEm							ON pedidoVenda TYPE datetime VALUE $before OR time::now() DEFAULT time::now() READONLY;
DEFINE FIELD canceladoEm					ON pedidoVenda TYPE datetime | null DEFAULT null;
DEFINE FIELD atualizadoEm					ON pedidoVenda TYPE datetime VALUE time::now() DEFAULT time::now() READONLY;


DEFINE TABLE crmCategoria SCHEMAFULL
	PERMISSIONS
		FOR SELECT,CREATE,UPDATE,DELETE FULL
;
DEFINE FIELD descricao						ON crmCategoria TYPE string ASSERT string::len($value) > 2;
DEFINE FIELD corTexto							ON crmCategoria TYPE record<cor> ;
DEFINE FIELD corFundo							ON crmCategoria TYPE record<cor> ;
DEFINE FIELD criadoEm							ON crmCategoria TYPE datetime VALUE $before OR time::now() DEFAULT time::now() READONLY;
DEFINE FIELD atualizadoEm					ON crmCategoria TYPE datetime VALUE time::now() DEFAULT time::now() READONLY;
DEFINE FIELD canceladoEm					ON crmCategoria TYPE datetime | null DEFAULT null;


DEFINE TABLE crm SCHEMAFULL
	PERMISSIONS
		FOR SELECT,CREATE,UPDATE,DELETE FULL
;
DEFINE FIELD empresa							ON crm TYPE record<empresa> ;
DEFINE FIELD cliente							ON crm TYPE record<cliente> ;
DEFINE FIELD categoria						ON crm TYPE record<crmCategoria> ;
DEFINE FIELD funcionario					ON crm TYPE record<funcionario> ;
DEFINE FIELD dataAgendada					ON crm TYPE datetime ASSERT type::is::datetime(type::datetime($value));
DEFINE FIELD dataRealizada				ON crm TYPE datetime;
DEFINE FIELD criadoEm							ON crm TYPE datetime VALUE $before OR time::now() DEFAULT time::now() READONLY;
DEFINE FIELD canceladoEm					ON crm TYPE datetime | null DEFAULT null;
DEFINE FIELD atualizadoEm					ON crm TYPE datetime VALUE time::now() DEFAULT time::now() READONLY;


DEFINE TABLE crmObservacoes SCHEMAFULL
	PERMISSIONS
		FOR SELECT,CREATE,UPDATE,DELETE FULL
;
DEFINE FIELD crm									ON crmObservacoes TYPE record<crm> ;
DEFINE FIELD descricao						ON crmObservacoes TYPE string ASSERT string::len($value) > 2;
DEFINE FIELD categoriaAntes				ON crmObservacoes TYPE record<crmCategoria>;
DEFINE FIELD categoriaDepois			ON crmObservacoes TYPE record<crmCategoria>;
DEFINE FIELD criadoEm							ON crmObservacoes TYPE datetime VALUE $before OR time::now() DEFAULT time::now() READONLY;
DEFINE FIELD atualizadoEm					ON crmObservacoes TYPE datetime VALUE time::now() DEFAULT time::now() READONLY;
DEFINE FIELD canceladoEm					ON crmObservacoes TYPE datetime | null DEFAULT null;


DEFINE TABLE usuario SCHEMAFULL 

DEFINE FIELD email 								ON usuario TYPE string ASSERT string::is::email($value) || $value == NONE;
DEFINE FIELD empresa 							ON usuario TYPE record<empresa> ;
DEFINE FIELD funcionario 					ON usuario TYPE record<funcionario>;
DEFINE FIELD login								ON usuario TYPE string ASSERT string::len($value) > 2;
DEFINE FIELD senha 								ON usuario TYPE string ASSERT string::len($value) > 6;
DEFINE FIELD criadoEm 						ON usuario TYPE datetime VALUE $before OR time::now() DEFAULT time::now() READONLY;
DEFINE FIELD atualizadoEm 				ON usuario TYPE datetime VALUE time::now() DEFAULT time::now() READONLY;
DEFINE FIELD canceladoEm 					ON usuario TYPE datetime | null DEFAULT null;

DEFINE INDEX login_unico ON usuario FIELDS login UNIQUE;

DEFINE TABLE tela SCHEMAFULL
	PERMISSIONS
		FOR SELECT,CREATE,UPDATE,DELETE FULL
;
DEFINE FIELD menu									ON tela TYPE string ASSERT string::len($value) >= 2;
DEFINE FIELD submenu							ON tela TYPE string ASSERT string::len($value) >= 2;
DEFINE FIELD icone								ON tela TYPE string ASSERT string::len($value) > 2;
DEFINE FIELD url									ON tela TYPE string;
DEFINE FIELD criadoEm 						ON tela TYPE datetime VALUE $before OR time::now() DEFAULT time::now() READONLY;
DEFINE FIELD atualizadoEm 				ON tela TYPE datetime VALUE time::now() DEFAULT time::now() READONLY;
DEFINE FIELD canceladoEm 					ON tela TYPE datetime | null DEFAULT null;

DEFINE INDEX submenu_unico ON tela FIELDS submenu UNIQUE;

DEFINE TABLE permissaoTela SCHEMAFULL
	PERMISSIONS
		FOR SELECT,CREATE,UPDATE,DELETE FULL
;
DEFINE FIELD usuario							ON permissaoTela TYPE record<usuario> ;
DEFINE FIELD tela									ON permissaoTela TYPE record<tela> ;
DEFINE FIELD permissao						ON permissaoTela TYPE string ASSERT $value INSIDE ['visualizar','criar','editar','deletar','relatorio'];
DEFINE FIELD criadoEm 						ON permissaoTela TYPE datetime VALUE $before OR time::now() DEFAULT time::now() READONLY;
DEFINE FIELD atualizadoEm 				ON permissaoTela TYPE datetime VALUE time::now() DEFAULT time::now() READONLY;
DEFINE FIELD canceladoEm 					ON permissaoTela TYPE datetime | null DEFAULT null;

DEFINE INDEX usuario_tela_unico ON permissaoTela FIELDS usuario,tela,permissao UNIQUE;




