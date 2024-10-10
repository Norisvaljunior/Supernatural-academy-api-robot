*** Settings ***
Resource    ../resources/supernatural.resource

*** Variables ***

*** Test Cases ***
Validar Login
    Criar Sessao
    Realizar Login
    
Criar empresa
    Criar Sessao
    Realizar Login
    Realizar cadastro de empresa
    Consultar se o cadastro foi realizado com sucesso

Validando campos do cadastro conforme regra de negócio
    Criar Sessao
    Realizar Login
    Validação dos campos conforme regra de negócio
    Consultar se o cadastro foi realizado com sucesso

Não Funcional - Nome da empresa
    Criar Sessao
    Realizar Login
    Nome da empresa em branco
    Nome da empresa com mais de 100 caracteres
    Nome da empresa com caracteres especiais
    Nome da empresa duplicado

Não Funcional - CNPJ da empresa
    Criar Sessao
    Realizar Login
    CNPJ em branco
    CNPJ com mais de 14 digitos
    CNPJ duplicado

Não Funcional - Email
    Criar Sessao
    Realizar Login
    Email em branco
    Email sem @
    Email sem dados antes do @
    Email sem dados do dominio

Não Funcional - Razão Social
    Criar Sessao
    Realizar Login
    Razao social em branco
    Razao social duplicado
    Razao social com caracteres especiais
    Razao social com mais de 100 caracteres

Não Funcional - Contato responsável
    Criar Sessao
    Realizar Login
    Contato em branco
    Contato com mais de 100 caracteres
    Contato com numeros
    Contato sem duas palavras compostas

Não Funcional - Telefone
    Criar Sessao
    Realizar Login
    Telefone em branco
    Telefone com mais de 21 caracteres
    Telefone com letras

Não Funcional - Ramo de atividade  
    Criar Sessao
    Realizar Login
    Descrição de negócio em branco
    Descrição de negócio com caracteres especiais

Não Funcional - Logradouro
    Criar Sessao
    Realizar Login
    Logradouro em branco
    Logradouro com mais de 50 caracteres
    Logradouro com caracteres especiais exceto regra

Não Funcional - Numero Logradouro
    Criar Sessao
    Realizar Login
    Numero em branco
    Numero com mais de 10 caracteres
    Numero com caracteres especiais

Não funcional - Complemento Logradouro
    Criar Sessao
    Realizar Login
    Complemento com mais de 80 caracteres

Não Funcional - Bairro
    Criar Sessao
    Realizar Login
    Bairro em branco
    Bairro com mais de 50 caracteres
    Bairro com caracteres especiais exceto regra

Não Funcional - CEP
    Criar Sessao
    Realizar Login
    CEP em branco
    CEP com mais de 8 caracteres
    CEP com letras

Não Funcional - Cidade
    Criar Sessao
    Realizar Login
    Cidade em branco
    Cidade com mais de 50 caracteres
    Cidade com numeros
    Cidade com caracteres especiais exceto regra

Não Funcional - Estado
    Criar Sessao
    Realizar Login
    Estado em branco
    Estado mais de duas letras
    Estado com caracteres especiais
    Estado com numeros

Não Funcional - Pais
    Criar Sessao
    Realizar Login
    Pais em branco
    Pais com mais de 50 caracteres
    Pais com numeros