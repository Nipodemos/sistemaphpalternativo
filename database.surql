define table fornecedor schemafull;

DEFINE FIELD nome                ON fornecedor TYPE string ASSERT $value != NONE && string::len($value) < 256;
DEFINE FIELD fantasia            ON fornecedor TYPE string ASSERT $value != NONE && string::len($value) < 256;
DEFINE FIELD codigo              ON fornecedor TYPE int READONLY DEFAULT {
    LET $max_codigo = ((select value codigo from fornecedor order by codigo desc limit 1)[0] || 0);
    RETURN $max_codigo+1;
};
DEFINE FIELD cpfcnpj             ON fornecedor TYPE string ASSERT $value != NONE && string::len($value) < 20;
DEFINE FIELD pessoa              ON fornecedor TYPE string ASSERT string::contains($value, "F") || string::contains($value, "J");
DEFINE FILED INSCRICAOESTADUAL   ON fornecedor TYPE string ASSERT $value != NONE && string::len($value) < 20;
DEFINE FIELD ENDERECO            ON fornecedor TYPE string ASSERT $value != NONE && string::len($value) > 1;
DEFINE FIELD NUMERO              ON fornecedor TYPE string ASSERT $value != NONE && string::len($value) > 1;
DEFINE FIELD BAIRRO              ON fornecedor TYPE string ASSERT $value != NONE && string::len($value) > 1;
DEFINE FIELD CIDADE              ON fornecedor TYPE string ASSERT $value != NONE && string::len($value) > 1;
DEFINE FIELD CODIGOMUNICIPIO     ON fornecedor TYPE string ASSERT $value != NONE && string::len($value) == 7;
DEFINE FIELD UF                  ON fornecedor TYPE string ASSERT $value != NONE && string::len($value) == 2;
DEFINE FIELD CEP                 ON fornecedor TYPE string ASSERT $value != NONE && string::len($value) == 8;
DEFINE FIELD TELEFONE1           ON fornecedor TYPE string ASSERT $value != NONE && string::len($value) > 1;
DEFINE FIELD TELEFONE2           ON fornecedor TYPE string;
DEFINE FIELD EMAIL               ON fornecedor TYPE string ASSERT $value != NONE && string::len($value) > 1;
DEFINE FIELD CANCELA             ON fornecedor TYPE datetime;
DEFINE FIELD OBSERVACAO          ON fornecedor TYPE string;
DEFINE FIELD RESPONSAVELNOME     ON fornecedor TYPE string;
DEFINE FIELD RESPONSAVELEMAIL    ON fornecedor TYPE string;
DEFINE FIELD RESPONSAVELTELEFONE ON fornecedor TYPE string;
DEFINE FIELD PARCEIRO            ON fornecedor TYPE bool DEFAULT false;
DEFINE FIELD SITE                ON fornecedor TYPE string;
DEFINE FIELD CRIADOEM            ON fornecedor TYPE datetime DEFAULT now();
DEFINE FIELD ATUALIZADOEM        ON fornecedor TYPE datetime DEFAULT now();

DEFINE TABLE produto SCHEMAFULL;
DEFINE FIELD fornecedor          ON produto TYPE record<fornecedor> ASSERT $value != NONE;
DEFINE FIELD codigo ON produto TYPE number READONLY DEFAULT {
    LET $max_codigo = ((select value codigo from produto where $this.fornecedor = fornecedor order by codigo desc limit 1)[0] || 0);
    RETURN $max_codigo+1;
};
