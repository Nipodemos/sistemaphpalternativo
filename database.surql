define table fornecedor schemafull;

DEFINE FIELD nome									ON fornecedor TYPE string ASSERT string::len($value) > 1 && string::len($value) < 256;
DEFINE FIELD fantasia							ON fornecedor TYPE string ASSERT string::len($value) > 1 && string::len($value) < 256;
DEFINE FIELD codigo								ON fornecedor TYPE int READONLY DEFAULT {
		LET $max_codigo = ((select value codigo from fornecedor order by codigo desc limit 1)[0] || 0);
		RETURN $max_codigo+1;
};
DEFINE FIELD cpfcnpj							ON fornecedor TYPE string ASSERT	string::len($value) == 14 || string::len($value) == 18;
DEFINE FIELD pessoa								ON fornecedor TYPE string ASSERT string::contains($value, "F") || string::contains($value, "J");
DEFINE FIELD INSCRICAOESTADUAL		ON fornecedor TYPE string ASSERT $value != NONE && string::len($value) < 20;
DEFINE FIELD ENDERECO							ON fornecedor TYPE string ASSERT $value != NONE && string::len($value) > 1;
DEFINE FIELD NUMERO								ON fornecedor TYPE string ASSERT $value != NONE && string::len($value) > 1;
DEFINE FIELD BAIRRO								ON fornecedor TYPE string ASSERT $value != NONE && string::len($value) > 1;
DEFINE FIELD CIDADE								ON fornecedor TYPE string ASSERT string::len($value) > 1;
DEFINE FIELD CODIGOMUNICIPIO			ON fornecedor TYPE string ASSERT string::len($value) == 7;
DEFINE FIELD UF										ON fornecedor TYPE string ASSERT string::len($value) == 2;
DEFINE FIELD CEP									ON fornecedor TYPE string ASSERT string::len($value) == 8;
DEFINE FIELD TELEFONE1						ON fornecedor TYPE string ASSERT string::len($value) > 1;
DEFINE FIELD TELEFONE2						ON fornecedor TYPE string;
DEFINE FIELD EMAIL								ON fornecedor TYPE string ASSERT string::len($value) > 1;
DEFINE FIELD CANCELA							ON fornecedor TYPE datetime;
DEFINE FIELD OBSERVACAO						ON fornecedor TYPE string;
DEFINE FIELD RESPONSAVELNOME			ON fornecedor TYPE string;
DEFINE FIELD RESPONSAVELEMAIL			ON fornecedor TYPE string;
DEFINE FIELD RESPONSAVELTELEFONE	ON fornecedor TYPE string;
DEFINE FIELD PARCEIRO							ON fornecedor TYPE bool DEFAULT false;
DEFINE FIELD SITE									ON fornecedor TYPE string;
DEFINE FIELD criadoEm							ON fornecedor TYPE datetime VALUE $before OR time::now() DEFAULT time::now() READONLY;
DEFINE FIELD atualizadoEm					ON fornecedor TYPE datetime VALUE time::now() DEFAULT time::now() READONLY;

DEFINE TABLE tabela SCHEMAFULL;
DEFINE FIELD descricao						ON tabela TYPE string ASSERT string::len($value) > 2;
DEFINE FIELD criadoEm							ON tabela TYPE datetime VALUE $before OR time::now() DEFAULT time::now() READONLY;
DEFINE FIELD atualizadoEm					ON tabela TYPE datetime VALUE time::now() DEFAULT time::now() READONLY;

DEFINE TABLE grupo SCHEMAFULL;
DEFINE FIELD descricao						ON grupo TYPE string ASSERT string::len($value) > 2;
DEFINE FIELD tabela								ON grupo TYPE record<tabela> ASSERT $value != NONE;
DEFINE FIELD criadoEm							ON grupo TYPE datetime VALUE $before OR time::now() DEFAULT time::now() READONLY;
DEFINE FIELD atualizadoEm					ON grupo TYPE datetime VALUE time::now() DEFAULT time::now() READONLY;

DEFINE TABLE subgrupo SCHEMAFULL;
DEFINE FIELD descricao						ON subgrupo TYPE string ASSERT string::len($value) > 2;
DEFINE FIELD criadoEm							ON subgrupo TYPE datetime VALUE $before OR time::now() DEFAULT time::now() READONLY;
DEFINE FIELD atualizadoEm					ON subgrupo TYPE datetime VALUE time::now() DEFAULT time::now() READONLY;
DEFINE FIELD grupo								ON subgrupo TYPE record<grupo> ASSERT $value != NONE;
DEFINE FIELD comissao							ON subgrupo TYPE number ASSERT $value >= 0 && $value <= 100;

DEFINE TABLE produto SCHEMAFULL;
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
DEFINE FIELD descontoMaximo				ON produto TYPE number ASSERT $value >= 0 && $value <= 100;
DEFINE FIELD comissao							ON produto TYPE number ASSERT $value >= 0 && $value <= 100;
DEFINE FIELD comissaoGerente			ON produto TYPE number ASSERT $value >= 0 && $value <= 100;
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

DEFINE TABLE acabamento SCHEMAFULL;
DEFINE FIELD descricao						ON acabamento TYPE string ASSERT string::len($value) > 2;
DEFINE FIELD criadoEm							ON acabamento TYPE datetime VALUE $before OR time::now() DEFAULT time::now() READONLY;
DEFINE FIELD atualizadoEm					ON acabamento TYPE datetime VALUE time::now() DEFAULT time::now() READONLY;
DEFINE FIELD codigo								ON acabamento TYPE number READONLY DEFAULT {
	LET $max_codigo = (select value codigo from acabamento order by codigo desc limit 1)[0] || 0;
	RETURN $max_codigo+1;
};

DEFINE TABLE cor SCHEMAFULL;
DEFINE FIELD descricao						ON cor TYPE string ASSERT string::len($value) > 2;
DEFINE FIELD criadoEm							ON cor TYPE datetime VALUE $before OR time::now() DEFAULT time::now() READONLY;
DEFINE FIELD atualizadoEm					ON cor TYPE datetime VALUE time::now() DEFAULT time::now() READONLY;
DEFINE FIELD codigo								ON cor TYPE number READONLY DEFAULT {
	LET $max_codigo = (select value codigo from cor order by codigo desc limit 1)[0] || 0;
	RETURN $max_codigo+1;
};

DEFINE TABLE produtoGrade SCHEMAFULL;
DEFINE FIELD produto							ON produtoGrade TYPE record<produto> ASSERT $value != NONE;
DEFINE FIELD ativo								ON produtoGrade TYPE bool DEFAULT true;
DEFINE FIELD cor									ON produtoGrade TYPE record<cor> ASSERT $value != NONE;
DEFINE FIELD acabamento						ON produtoGrade TYPE record<acabamento>;
DEFINE FIELD criadoEm							ON produtoGrade TYPE datetime VALUE $before OR time::now() DEFAULT time::now() READONLY;
DEFINE FIELD atualizadoEm					ON produtoGrade TYPE datetime VALUE time::now() DEFAULT time::now() READONLY;


teste
