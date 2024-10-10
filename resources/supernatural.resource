*** Settings ***
Documentation      Cadastro empresa
Resource           variables.robot
Library            RequestsLibrary
Library            String
Library            Collections
Library            OperatingSystem
*** Variables ***
${baseUrl}        https://chips.qacoders.dev.br/api

*** Keywords ***
Criar Sessao
    ${headers}        Create Dictionary     accept=application/json    Content-Type=application/json
    Create Session    alias=supernatural    url=${baseUrl}             headers=${headers}    verify=${True}

Realizar Login
    ${body}        Create Dictionary    mail=sysadmin@qacoders.com    password=1234@Test
    Log            ${body}
    Criar Sessao
    ${resposta}         POST On Session      alias=supernatural       url=/login    json=${body}
    Status Should Be    200                  ${resposta}
    Set Test Variable   ${TOKEN}             ${resposta.json()["token"]}
    Log                 ${resposta}

Realizar cadastro de empresa
    Gerar variáveis Faker
    ${address}=          Create List
    ${endereco}=         Create Dictionary      zipCode=${CEP}    city=${CIDADE}    state=${ESTADO}    district=${BAIRRO}    street=${ENDERECO}    number=${NUMERO}    complement=${COMPLEMENTO}    country=${PAIS}
    Append To List       ${address}             ${endereco}
    ${body}=             Create Dictionary      corporateName=${NOMECORPORACAO}    registerCompany=${CNPJ}    mail=${MAIL}    matriz=${MATRIZ}    responsibleContact=${RESPONSAVEL}    telephone=${FONE}    serviceDescription=${RAMOATIVIDADE}    address=${address}
    ${headers}=          Create Dictionary      Authorization=${TOKEN}
    ${response}=         POST On Session        alias=supernatural    url=/company    headers=${headers}    json=${body}   
    Log        ${response.status_code}
    Log        ${response.content}
    Set Test Variable    ${RESPONSE}            ${response}
    Set Test Variable    ${ID_COMPANY}          ${response.json()["newCompany"]["_id"]}

Consultar se o cadastro foi realizado com sucesso
    Status Should Be     201        ${RESPONSE}

Validação dos campos conforme regra de negócio               # Neste teste foi usado os limites e caracteres sugeridos conforme regra de negócio
    ${CEP}=              Generate Random String    8         [NUMBERS]
    # EXEMPLO ABAIXO PARA VALIDAÇÃO DO CAMPO COM LETRAS, CARACTERES DA REGRA e LIMITE DE 50 CARACTERES
    ${CIDADE}=           Generate Random String    length=46  chars=[LETTERS]    # Gera 46 caractres com a função GENERATE (Limite do campo menos os 4)
    ${CIDADE}=           Set Variable              ${CIDADE}ªº'-                 # Depois usa a mesma variável para concatenar e chegar ao limite do campo
                                                                                 # Usandoa mesma lógica nos depois campos citados na regra de negócio
    ${ESTADO}=           Generate Random String    length=2  chars=[LETTERS]
    ${ESTADO}=           Convert To Upper Case     ${ESTADO}
    ${ENDERECO}=         Generate Random String    length=46  chars=\[LETTERS\]\[NUMBERS\]
    ${ENDERECO}=         Set Variable              ${ENDERECO}ªº'-
    ${BAIRRO}=           Generate Random String    length=46  chars=\[LETTERS\]\[NUMBERS\]
    ${BAIRRO}=           Set Variable              ${BAIRRO}ªº'- 
    ${NUMERO}=           Generate Random String    10         [NUMBERS]
    ${COMPLEMENTO}=      Generate Random String    length=76  chars=\[LETTERS\]\[NUMBERS\]    
    ${COMPLEMENTO}=      Set Variable              ${COMPLEMENTO}ªº'-
    ${PAIS}=             Generate Random String    length=50  chars=[LETTERS]
    
    
    ${NOMECORPORACAO}=   Generate Random String    length=100   chars=\[LETTERS\]\[NUMBERS\]
    ${CNPJ}=             Generate Random String    14           [NUMBERS]
    ${MAIL}=             FakerLibrary.Email
    ${MATRIZ}=           Generate Random String    length=100    chars=\[LETTERS\]\[NUMBERS\]
    ${RESPONSAVEL}=      Generate Random String    length=100     chars=\[LETTERS\]\[NUMBERS\]
    ${RESPONSAVEL}=      Set Variable              ${RESPONSAVEL}
    ${FONE}=             Generate Random String    15            [NUMBERS]
    ${RAMOATIVIDADE}=    Generate Random String    length=50     chars=\[LETTERS\]\[NUMBERS\]

    ${address}=          Create List
    ${endereco}=         Create Dictionary      zipCode=${CEP}    city=${CIDADE}    state=${ESTADO}    district=${BAIRRO}    street=${ENDERECO}    number=${NUMERO}    complement=${COMPLEMENTO}    country=${PAIS}
    Append To List       ${address}             ${endereco}
    ${body}=             Create Dictionary      corporateName=${NOMECORPORACAO}    registerCompany=${CNPJ}    mail=${MAIL}    matriz=${MATRIZ}    responsibleContact=${RESPONSAVEL}    telephone=${FONE}    serviceDescription=${RAMOATIVIDADE}    address=${address}
    ${headers}=          Create Dictionary      Authorization=${TOKEN}
    ${response}=         POST On Session        alias=supernatural    url=/company    headers=${headers}    json=${body}   
    Set Test Variable    ${RESPONSE}            ${response}

Nome da empresa em branco
    Gerar variáveis Faker
    ${NOMECORPORACAO}    Set Variable    
 
    ${address}=          Create List
    ${endereco}=         Create Dictionary      zipCode=${CEP}    city=${CIDADE}    state=${ESTADO}    district=${BAIRRO}    street=${ENDERECO}    number=${NUMERO}    complement=${COMPLEMENTO}    country=${PAIS}
    Append To List       ${address}             ${endereco}
    ${body}=             Create Dictionary      corporateName=${NOMECORPORACAO}    registerCompany=${CNPJ}    mail=${MAIL}    matriz=${MATRIZ}    responsibleContact=${RESPONSAVEL}    telephone=${FONE}    serviceDescription=${RAMOATIVIDADE}    address=${address}
    ${headers}=          Create Dictionary      Authorization=${TOKEN}
    ${response}=         POST On Session        alias=supernatural    url=/company    headers=${headers}    json=${body}    expected_status=400 

Nome da empresa com mais de 100 caracteres
    Gerar variáveis Faker
    ${NOMECORPORACAO}=   Generate Random String    length=101  chars=[LETTERS]    

    ${address}=          Create List
    ${endereco}=         Create Dictionary      zipCode=${CEP}    city=${CIDADE}    state=${ESTADO}    district=${BAIRRO}    street=${ENDERECO}    number=${NUMERO}    complement=${COMPLEMENTO}    country=${PAIS}
    Append To List       ${address}             ${endereco}
    ${body}=             Create Dictionary      corporateName=${NOMECORPORACAO}    registerCompany=${CNPJ}    mail=${MAIL}    matriz=${MATRIZ}    responsibleContact=${RESPONSAVEL}    telephone=${FONE}    serviceDescription=${RAMOATIVIDADE}    address=${address}
    ${headers}=          Create Dictionary      Authorization=${TOKEN}
    ${response}=         POST On Session        alias=supernatural    url=/company    headers=${headers}    json=${body}    expected_status=400 

Nome da empresa com caracteres especiais     #Abrir card melhoria
    Gerar variáveis Faker
    ${NOMECORPORACAO}=   Set Variable    Nome Empresa caracter especial !@#$%¨&* 

    ${address}=          Create List
    ${endereco}=         Create Dictionary      zipCode=${CEP}    city=${CIDADE}    state=${ESTADO}    district=${BAIRRO}    street=${ENDERECO}    number=${NUMERO}    complement=${COMPLEMENTO}    country=${PAIS}
    Append To List       ${address}             ${endereco}
    ${body}=             Create Dictionary      corporateName=${NOMECORPORACAO}    registerCompany=${CNPJ}    mail=${MAIL}    matriz=${MATRIZ}    responsibleContact=${RESPONSAVEL}    telephone=${FONE}    serviceDescription=${RAMOATIVIDADE}    address=${address}
    ${headers}=          Create Dictionary      Authorization=${TOKEN}
    ${response}=         POST On Session        alias=supernatural    url=/company    headers=${headers}    json=${body}    expected_status=201

Nome da empresa duplicado                    #Abrir card melhoria
    Gerar variáveis Faker
    ${NOMECORPORACAO}=   Set Variable    Supernatural Empresa com nome DUPLICADO 

    ${address}=          Create List
    ${endereco}=         Create Dictionary      zipCode=${CEP}    city=${CIDADE}    state=${ESTADO}    district=${BAIRRO}    street=${ENDERECO}    number=${NUMERO}    complement=${COMPLEMENTO}    country=${PAIS}
    Append To List       ${address}             ${endereco}
    ${body}=             Create Dictionary      corporateName=${NOMECORPORACAO}    registerCompany=${CNPJ}    mail=${MAIL}    matriz=${MATRIZ}    responsibleContact=${RESPONSAVEL}    telephone=${FONE}    serviceDescription=${RAMOATIVIDADE}    address=${address}
    ${headers}=          Create Dictionary      Authorization=${TOKEN}
    ${response}=         POST On Session        alias=supernatural    url=/company    headers=${headers}    json=${body}    expected_status=201 

CNPJ em branco
    Gerar variáveis Faker   
    ${CNPJ}=             Set Variable    

    ${address}=          Create List
    ${endereco}=         Create Dictionary      zipCode=${CEP}    city=${CIDADE}    state=${ESTADO}    district=${BAIRRO}    street=${ENDERECO}    number=${NUMERO}    complement=${COMPLEMENTO}    country=${PAIS}
    Append To List       ${address}             ${endereco}
    ${body}=             Create Dictionary      corporateName=${NOMECORPORACAO}    registerCompany=${CNPJ}    mail=${MAIL}    matriz=${MATRIZ}    responsibleContact=${RESPONSAVEL}    telephone=${FONE}    serviceDescription=${RAMOATIVIDADE}    address=${address}
    ${headers}=          Create Dictionary      Authorization=${TOKEN}
    ${response}=         POST On Session        alias=supernatural    url=/company    headers=${headers}    json=${body}    expected_status=400

CNPJ com mais de 14 digitos
    Gerar variáveis Faker
    ${CNPJ}=             Generate Random String    15           [NUMBERS]

    ${address}=          Create List
    ${endereco}=         Create Dictionary      zipCode=${CEP}    city=${CIDADE}    state=${ESTADO}    district=${BAIRRO}    street=${ENDERECO}    number=${NUMERO}    complement=${COMPLEMENTO}    country=${PAIS}
    Append To List       ${address}             ${endereco}
    ${body}=             Create Dictionary      corporateName=${NOMECORPORACAO}    registerCompany=${CNPJ}    mail=${MAIL}    matriz=${MATRIZ}    responsibleContact=${RESPONSAVEL}    telephone=${FONE}    serviceDescription=${RAMOATIVIDADE}    address=${address}
    ${headers}=          Create Dictionary      Authorization=${TOKEN}
    ${response}=         POST On Session        alias=supernatural   url=/company    headers=${headers}    json=${body}    expected_status=400

CNPJ duplicado
    Gerar variáveis Faker
    ${CNPJ}=             Set Variable    89290543000180
 
    ${address}=          Create List
    ${endereco}=         Create Dictionary      zipCode=${CEP}    city=${CIDADE}    state=${ESTADO}    district=${BAIRRO}    street=${ENDERECO}    number=${NUMERO}    complement=${COMPLEMENTO}    country=${PAIS}
    Append To List       ${address}             ${endereco}
    ${body}=             Create Dictionary      corporateName=${NOMECORPORACAO}    registerCompany=${CNPJ}    mail=${MAIL}    matriz=${MATRIZ}    responsibleContact=${RESPONSAVEL}    telephone=${FONE}    serviceDescription=${RAMOATIVIDADE}    address=${address}
    ${headers}=          Create Dictionary      Authorization=${TOKEN}
    ${response}=         POST On Session        alias=supernatural    url=/company    headers=${headers}    json=${body}    expected_status=400

Email em branco
    Gerar variáveis Faker 
    ${MAIL}=             Set Variable
 
    ${address}=          Create List
    ${endereco}=         Create Dictionary      zipCode=${CEP}    city=${CIDADE}    state=${ESTADO}    district=${BAIRRO}    street=${ENDERECO}    number=${NUMERO}    complement=${COMPLEMENTO}    country=${PAIS}
    Append To List       ${address}             ${endereco}
    ${body}=             Create Dictionary      corporateName=${NOMECORPORACAO}    registerCompany=${CNPJ}    mail=${MAIL}    matriz=${MATRIZ}    responsibleContact=${RESPONSAVEL}    telephone=${FONE}    serviceDescription=${RAMOATIVIDADE}    address=${address}
    ${headers}=          Create Dictionary      Authorization=${TOKEN}
    ${response}=         POST On Session        alias=supernatural    url=/company    headers=${headers}    json=${body}    expected_status=400
Email sem @
    Gerar variáveis Faker
    ${MAIL}=             Set Variable    supernaturalsemarroba.com.br
 
    ${address}=          Create List
    ${endereco}=         Create Dictionary      zipCode=${CEP}    city=${CIDADE}    state=${ESTADO}    district=${BAIRRO}    street=${ENDERECO}    number=${NUMERO}    complement=${COMPLEMENTO}    country=${PAIS}
    Append To List       ${address}             ${endereco}
    ${body}=             Create Dictionary      corporateName=${NOMECORPORACAO}    registerCompany=${CNPJ}    mail=${MAIL}    matriz=${MATRIZ}    responsibleContact=${RESPONSAVEL}    telephone=${FONE}    serviceDescription=${RAMOATIVIDADE}    address=${address}
    ${headers}=          Create Dictionary      Authorization=${TOKEN}
    ${response}=         POST On Session        alias=supernatural    url=/company    headers=${headers}    json=${body}    expected_status=400
Email sem dados antes do @
    Gerar variáveis Faker
    ${MAIL}=             Set Variable    @qacoders.com.br
 
    ${address}=          Create List
    ${endereco}=         Create Dictionary      zipCode=${CEP}    city=${CIDADE}    state=${ESTADO}    district=${BAIRRO}    street=${ENDERECO}    number=${NUMERO}    complement=${COMPLEMENTO}    country=${PAIS}
    Append To List       ${address}             ${endereco}
    ${body}=             Create Dictionary      corporateName=${NOMECORPORACAO}    registerCompany=${CNPJ}    mail=${MAIL}    matriz=${MATRIZ}    responsibleContact=${RESPONSAVEL}    telephone=${FONE}    serviceDescription=${RAMOATIVIDADE}    address=${address}
    ${headers}=          Create Dictionary      Authorization=${TOKEN}
    ${response}=         POST On Session        alias=supernatural    url=/company    headers=${headers}    json=${body}    expected_status=400

Email sem dados do dominio
    Gerar variáveis Faker 
    ${MAIL}=             Set Variable    supernatural@
 
    ${address}=          Create List
    ${endereco}=         Create Dictionary      zipCode=${CEP}    city=${CIDADE}    state=${ESTADO}    district=${BAIRRO}    street=${ENDERECO}    number=${NUMERO}    complement=${COMPLEMENTO}    country=${PAIS}
    Append To List       ${address}             ${endereco}
    ${body}=             Create Dictionary      corporateName=${NOMECORPORACAO}    registerCompany=${CNPJ}    mail=${MAIL}    matriz=${MATRIZ}    responsibleContact=${RESPONSAVEL}    telephone=${FONE}    serviceDescription=${RAMOATIVIDADE}    address=${address}
    ${headers}=          Create Dictionary      Authorization=${TOKEN}
    ${response}=         POST On Session        alias=supernatural    url=/company    headers=${headers}    json=${body}    expected_status=400

Razao social em branco
    Gerar variáveis Faker
    ${MATRIZ}=           Set Variable
 
    ${address}=          Create List
    ${endereco}=         Create Dictionary      zipCode=${CEP}    city=${CIDADE}    state=${ESTADO}    district=${BAIRRO}    street=${ENDERECO}    number=${NUMERO}    complement=${COMPLEMENTO}    country=${PAIS}
    Append To List       ${address}             ${endereco}
    ${body}=             Create Dictionary      corporateName=${NOMECORPORACAO}    registerCompany=${CNPJ}    mail=${MAIL}    matriz=${MATRIZ}    responsibleContact=${RESPONSAVEL}    telephone=${FONE}    serviceDescription=${RAMOATIVIDADE}    address=${address}
    ${headers}=          Create Dictionary      Authorization=${TOKEN}
    ${response}=         POST On Session        alias=supernatural    url=/company    headers=${headers}    json=${body}    expected_status=400
Razao social duplicado                       # Aberto card de melhoria - 16160 Razão Social informado com Duplicidade
    Gerar variáveis Faker
    ${MATRIZ}=           Set Variable        Razao Supernatural DUPLICADO
 
    ${address}=          Create List
    ${endereco}=         Create Dictionary      zipCode=${CEP}    city=${CIDADE}    state=${ESTADO}    district=${BAIRRO}    street=${ENDERECO}    number=${NUMERO}    complement=${COMPLEMENTO}    country=${PAIS}
    Append To List       ${address}             ${endereco}
    ${body}=             Create Dictionary      corporateName=${NOMECORPORACAO}    registerCompany=${CNPJ}    mail=${MAIL}    matriz=${MATRIZ}    responsibleContact=${RESPONSAVEL}    telephone=${FONE}    serviceDescription=${RAMOATIVIDADE}    address=${address}
    ${headers}=          Create Dictionary      Authorization=${TOKEN}
    ${response}=         POST On Session        alias=supernatural    url=/company    headers=${headers}    json=${body}    expected_status=201
Razao social com caracteres especiais        # Aberto card de melhoria - IMPROVEMENT 16161
    Gerar variáveis Faker
    ${MATRIZ}=           Set Variable        Supernatural !@#$%¨&*
 
    ${address}=          Create List
    ${endereco}=         Create Dictionary      zipCode=${CEP}    city=${CIDADE}    state=${ESTADO}    district=${BAIRRO}    street=${ENDERECO}    number=${NUMERO}    complement=${COMPLEMENTO}    country=${PAIS}
    Append To List       ${address}             ${endereco}
    ${body}=             Create Dictionary      corporateName=${NOMECORPORACAO}    registerCompany=${CNPJ}    mail=${MAIL}    matriz=${MATRIZ}    responsibleContact=${RESPONSAVEL}    telephone=${FONE}    serviceDescription=${RAMOATIVIDADE}    address=${address}
    ${headers}=          Create Dictionary      Authorization=${TOKEN}
    ${response}=         POST On Session        alias=supernatural    url=/company    headers=${headers}    json=${body}    expected_status=201
Razao social com mais de 100 caracteres
    Gerar variáveis Faker
    ${MATRIZ}=           Generate Random String    length=101    chars=\[LETTERS\]\[NUMBERS\]
 
    ${address}=          Create List
    ${endereco}=         Create Dictionary      zipCode=${CEP}    city=${CIDADE}    state=${ESTADO}    district=${BAIRRO}    street=${ENDERECO}    number=${NUMERO}    complement=${COMPLEMENTO}    country=${PAIS}
    Append To List       ${address}             ${endereco}
    ${body}=             Create Dictionary      corporateName=${NOMECORPORACAO}    registerCompany=${CNPJ}    mail=${MAIL}    matriz=${MATRIZ}    responsibleContact=${RESPONSAVEL}    telephone=${FONE}    serviceDescription=${RAMOATIVIDADE}    address=${address}
    ${headers}=          Create Dictionary      Authorization=${TOKEN}
    ${response}=         POST On Session        alias=supernatural    url=/company    headers=${headers}    json=${body}    expected_status=400
Contato em branco
    Gerar variáveis Faker
    ${RESPONSAVEL}=      Set Variable

    ${address}=          Create List
    ${endereco}=         Create Dictionary      zipCode=${CEP}    city=${CIDADE}    state=${ESTADO}    district=${BAIRRO}    street=${ENDERECO}    number=${NUMERO}    complement=${COMPLEMENTO}    country=${PAIS}
    Append To List       ${address}             ${endereco}
    ${body}=             Create Dictionary      corporateName=${NOMECORPORACAO}    registerCompany=${CNPJ}    mail=${MAIL}    matriz=${MATRIZ}    responsibleContact=${RESPONSAVEL}    telephone=${FONE}    serviceDescription=${RAMOATIVIDADE}    address=${address}
    ${headers}=          Create Dictionary      Authorization=${TOKEN}
    ${response}=         POST On Session        alias=supernatural    url=/company    headers=${headers}    json=${body}    expected_status=400
Contato com mais de 100 CARACTERES
    Gerar variáveis Faker
    ${RESPONSAVEL}=      Generate Random String    length=101    chars=[LETTERS]
 
    ${address}=          Create List
    ${endereco}=         Create Dictionary      zipCode=${CEP}    city=${CIDADE}    state=${ESTADO}    district=${BAIRRO}    street=${ENDERECO}    number=${NUMERO}    complement=${COMPLEMENTO}    country=${PAIS}
    Append To List       ${address}             ${endereco}
    ${body}=             Create Dictionary      corporateName=${NOMECORPORACAO}    registerCompany=${CNPJ}    mail=${MAIL}    matriz=${MATRIZ}    responsibleContact=${RESPONSAVEL}    telephone=${FONE}    serviceDescription=${RAMOATIVIDADE}    address=${address}
    ${headers}=          Create Dictionary      Authorization=${TOKEN}
    ${response}=         POST On Session        alias=supernatural    url=/company    headers=${headers}    json=${body}    expected_status=400
Contato com numeros                                # Aberto card de melhoria -  IMPROVEMENT 16164
    Gerar variáveis Faker
    ${RESPONSAVEL}=      Generate Random String    length=100    chars=\[LETTERS\]\[NUMBERS\]
 
    ${address}=          Create List
    ${endereco}=         Create Dictionary      zipCode=${CEP}    city=${CIDADE}    state=${ESTADO}    district=${BAIRRO}    street=${ENDERECO}    number=${NUMERO}    complement=${COMPLEMENTO}    country=${PAIS}
    Append To List       ${address}             ${endereco}
    ${body}=             Create Dictionary      corporateName=${NOMECORPORACAO}    registerCompany=${CNPJ}    mail=${MAIL}    matriz=${MATRIZ}    responsibleContact=${RESPONSAVEL}    telephone=${FONE}    serviceDescription=${RAMOATIVIDADE}    address=${address}
    ${headers}=          Create Dictionary      Authorization=${TOKEN}
    ${response}=         POST On Session        alias=supernatural    url=/company    headers=${headers}    json=${body}    expected_status=201
Contato sem duas palavras compostas                # Gerado card de melhoria - IMPROVEMENT 16165
    Gerar variáveis Faker
    ${RESPONSAVEL}=      Set Variable    Supernatural
 
    ${address}=          Create List
    ${endereco}=         Create Dictionary      zipCode=${CEP}    city=${CIDADE}    state=${ESTADO}    district=${BAIRRO}    street=${ENDERECO}    number=${NUMERO}    complement=${COMPLEMENTO}    country=${PAIS}
    Append To List       ${address}             ${endereco}
    ${body}=             Create Dictionary      corporateName=${NOMECORPORACAO}    registerCompany=${CNPJ}    mail=${MAIL}    matriz=${MATRIZ}    responsibleContact=${RESPONSAVEL}    telephone=${FONE}    serviceDescription=${RAMOATIVIDADE}    address=${address}
    ${headers}=          Create Dictionary      Authorization=${TOKEN}
    ${response}=         POST On Session        alias=supernatural    url=/company    headers=${headers}    json=${body}    expected_status=201
Telefone em branco
    Gerar variáveis Faker
    ${FONE}=             Set Variable
 
    ${address}=          Create List
    ${endereco}=         Create Dictionary      zipCode=${CEP}    city=${CIDADE}    state=${ESTADO}    district=${BAIRRO}    street=${ENDERECO}    number=${NUMERO}    complement=${COMPLEMENTO}    country=${PAIS}
    Append To List       ${address}             ${endereco}
    ${body}=             Create Dictionary      corporateName=${NOMECORPORACAO}    registerCompany=${CNPJ}    mail=${MAIL}    matriz=${MATRIZ}    responsibleContact=${RESPONSAVEL}    telephone=${FONE}    serviceDescription=${RAMOATIVIDADE}    address=${address}
    ${headers}=          Create Dictionary      Authorization=${TOKEN}
    ${response}=         POST On Session        alias=supernatural    url=/company    headers=${headers}    json=${body}    expected_status=400
Telefone com mais de 21 caracteres
    Gerar variáveis Faker
    ${FONE}=             Generate Random String    21           [NUMBERS]
 
    ${address}=          Create List
    ${endereco}=         Create Dictionary      zipCode=${CEP}    city=${CIDADE}    state=${ESTADO}    district=${BAIRRO}    street=${ENDERECO}    number=${NUMERO}    complement=${COMPLEMENTO}    country=${PAIS}
    Append To List       ${address}             ${endereco}
    ${body}=             Create Dictionary      corporateName=${NOMECORPORACAO}    registerCompany=${CNPJ}    mail=${MAIL}    matriz=${MATRIZ}    responsibleContact=${RESPONSAVEL}    telephone=${FONE}    serviceDescription=${RAMOATIVIDADE}    address=${address}
    ${headers}=          Create Dictionary      Authorization=${TOKEN}
    ${response}=         POST On Session        alias=supernatural    url=/company    headers=${headers}    json=${body}    expected_status=400
Telefone com letras
    Gerar variáveis Faker
    ${FONE}=             Generate Random String    length=14    chars=[LETTERS]

    ${address}=          Create List
    ${endereco}=         Create Dictionary      zipCode=${CEP}    city=${CIDADE}    state=${ESTADO}    district=${BAIRRO}    street=${ENDERECO}    number=${NUMERO}    complement=${COMPLEMENTO}    country=${PAIS}
    Append To List       ${address}             ${endereco}
    ${body}=             Create Dictionary      corporateName=${NOMECORPORACAO}    registerCompany=${CNPJ}    mail=${MAIL}    matriz=${MATRIZ}    responsibleContact=${RESPONSAVEL}    telephone=${FONE}    serviceDescription=${RAMOATIVIDADE}    address=${address}
    ${headers}=          Create Dictionary      Authorization=${TOKEN}
    ${response}=         POST On Session        alias=supernatural    url=/company    headers=${headers}    json=${body}    expected_status=400
Descrição de negócio em branco
    Gerar variáveis Faker
    ${RAMOATIVIDADE}=    Set Variable
 
    ${address}=          Create List
    ${endereco}=         Create Dictionary      zipCode=${CEP}    city=${CIDADE}    state=${ESTADO}    district=${BAIRRO}    street=${ENDERECO}    number=${NUMERO}    complement=${COMPLEMENTO}    country=${PAIS}
    Append To List       ${address}             ${endereco}
    ${body}=             Create Dictionary      corporateName=${NOMECORPORACAO}    registerCompany=${CNPJ}    mail=${MAIL}    matriz=${MATRIZ}    responsibleContact=${RESPONSAVEL}    telephone=${FONE}    serviceDescription=${RAMOATIVIDADE}    address=${address}
    ${headers}=          Create Dictionary      Authorization=${TOKEN}
    ${response}=         POST On Session        alias=supernatural    url=/company    headers=${headers}    json=${body}    expected_status=400
Descrição de negócio com caracteres especiais
    Gerar variáveis Faker
    ${RAMOATIVIDADE}=    Set Variable    Caracteres especiais !@#$%¨&*-+
 
    ${address}=          Create List
    ${endereco}=         Create Dictionary      zipCode=${CEP}    city=${CIDADE}    state=${ESTADO}    district=${BAIRRO}    street=${ENDERECO}    number=${NUMERO}    complement=${COMPLEMENTO}    country=${PAIS}
    Append To List       ${address}             ${endereco}
    ${body}=             Create Dictionary      corporateName=${NOMECORPORACAO}    registerCompany=${CNPJ}    mail=${MAIL}    matriz=${MATRIZ}    responsibleContact=${RESPONSAVEL}    telephone=${FONE}    serviceDescription=${RAMOATIVIDADE}    address=${address}
    ${headers}=          Create Dictionary      Authorization=${TOKEN}
    ${response}=         POST On Session        alias=supernatural    url=/company    headers=${headers}    json=${body}    expected_status=201
Logradouro em branco
    Gerar variáveis Faker
    ${ENDERECO}=         Set Variable
 
    ${address}=          Create List
    ${endereco}=         Create Dictionary      zipCode=${CEP}    city=${CIDADE}    state=${ESTADO}    district=${BAIRRO}    street=${ENDERECO}    number=${NUMERO}    complement=${COMPLEMENTO}    country=${PAIS}
    Append To List       ${address}             ${endereco}
    ${body}=             Create Dictionary      corporateName=${NOMECORPORACAO}    registerCompany=${CNPJ}    mail=${MAIL}    matriz=${MATRIZ}    responsibleContact=${RESPONSAVEL}    telephone=${FONE}    serviceDescription=${RAMOATIVIDADE}    address=${address}
    ${headers}=          Create Dictionary      Authorization=${TOKEN}
    ${response}=         POST On Session        alias=supernatural    url=/company    headers=${headers}    json=${body}    expected_status=400
Logradouro com mais de 50 caracteres
    Gerar variáveis Faker
    ${ENDERECO}=         Generate Random String    length=51    chars=\[LETTERS\]\[NUMBERS\]
 
    ${address}=          Create List
    ${endereco}=         Create Dictionary      zipCode=${CEP}    city=${CIDADE}    state=${ESTADO}    district=${BAIRRO}    street=${ENDERECO}    number=${NUMERO}    complement=${COMPLEMENTO}    country=${PAIS}
    Append To List       ${address}             ${endereco}
    ${body}=             Create Dictionary      corporateName=${NOMECORPORACAO}    registerCompany=${CNPJ}    mail=${MAIL}    matriz=${MATRIZ}    responsibleContact=${RESPONSAVEL}    telephone=${FONE}    serviceDescription=${RAMOATIVIDADE}    address=${address}
    ${headers}=          Create Dictionary      Authorization=${TOKEN}
    ${response}=         POST On Session        alias=supernatural    url=/company    headers=${headers}    json=${body}    expected_status=201
Logradouro com caracteres especiais exceto regra
    Gerar variáveis Faker
    ${ENDERECO}=         Set Variable    Caracteres especiais !@#$%¨&*-+
 
    ${address}=          Create List
    ${endereco}=         Create Dictionary      zipCode=${CEP}    city=${CIDADE}    state=${ESTADO}    district=${BAIRRO}    street=${ENDERECO}    number=${NUMERO}    complement=${COMPLEMENTO}    country=${PAIS}
    Append To List       ${address}             ${endereco}
    ${body}=             Create Dictionary      corporateName=${NOMECORPORACAO}    registerCompany=${CNPJ}    mail=${MAIL}    matriz=${MATRIZ}    responsibleContact=${RESPONSAVEL}    telephone=${FONE}    serviceDescription=${RAMOATIVIDADE}    address=${address}
    ${headers}=          Create Dictionary      Authorization=${TOKEN}
    ${response}=         POST On Session        alias=supernatural    url=/company    headers=${headers}    json=${body}    expected_status=400
Numero em branco
    Gerar variáveis Faker
    ${NUMERO}=           Set Variable

    ${address}=          Create List
    ${endereco}=         Create Dictionary      zipCode=${CEP}    city=${CIDADE}    state=${ESTADO}    district=${BAIRRO}    street=${ENDERECO}    number=${NUMERO}    complement=${COMPLEMENTO}    country=${PAIS}
    Append To List       ${address}             ${endereco}
    ${body}=             Create Dictionary      corporateName=${NOMECORPORACAO}    registerCompany=${CNPJ}    mail=${MAIL}    matriz=${MATRIZ}    responsibleContact=${RESPONSAVEL}    telephone=${FONE}    serviceDescription=${RAMOATIVIDADE}    address=${address}
    ${headers}=          Create Dictionary      Authorization=${TOKEN}
    ${response}=         POST On Session        alias=supernatural    url=/company    headers=${headers}    json=${body}    expected_status=400
Numero com mais de 10 caracteres
    Gerar variáveis Faker
    ${NUMERO}=           Generate Random String    length=11    chars=[NUMBERS]
 
    ${address}=          Create List
    ${endereco}=         Create Dictionary      zipCode=${CEP}    city=${CIDADE}    state=${ESTADO}    district=${BAIRRO}    street=${ENDERECO}    number=${NUMERO}    complement=${COMPLEMENTO}    country=${PAIS}
    Append To List       ${address}             ${endereco}
    ${body}=             Create Dictionary      corporateName=${NOMECORPORACAO}    registerCompany=${CNPJ}    mail=${MAIL}    matriz=${MATRIZ}    responsibleContact=${RESPONSAVEL}    telephone=${FONE}    serviceDescription=${RAMOATIVIDADE}    address=${address}
    ${headers}=          Create Dictionary      Authorization=${TOKEN}
    ${response}=         POST On Session        alias=supernatural    url=/company    headers=${headers}    json=${body}    expected_status=400
Numero com caracteres especiais
    Gerar variáveis Faker
    ${NUMERO}=           Set Variable    !@#$%¨&*
 
    ${address}=          Create List
    ${endereco}=         Create Dictionary      zipCode=${CEP}    city=${CIDADE}    state=${ESTADO}    district=${BAIRRO}    street=${ENDERECO}    number=${NUMERO}    complement=${COMPLEMENTO}    country=${PAIS}
    Append To List       ${address}             ${endereco}
    ${body}=             Create Dictionary      corporateName=${NOMECORPORACAO}    registerCompany=${CNPJ}    mail=${MAIL}    matriz=${MATRIZ}    responsibleContact=${RESPONSAVEL}    telephone=${FONE}    serviceDescription=${RAMOATIVIDADE}    address=${address}
    ${headers}=          Create Dictionary      Authorization=${TOKEN}
    ${response}=         POST On Session        alias=supernatural    url=/company    headers=${headers}    json=${body}    expected_status=400
Complemento com mais de 80 caracteres
    Gerar variáveis Faker
    ${COMPLEMENTO}       Generate Random String    length=81    chars=\[LETTERS\]\[NUMBERS\]
 
    ${address}=          Create List
    ${endereco}=         Create Dictionary      zipCode=${CEP}    city=${CIDADE}    state=${ESTADO}    district=${BAIRRO}    street=${ENDERECO}    number=${NUMERO}    complement=${COMPLEMENTO}    country=${PAIS}
    Append To List       ${address}             ${endereco}
    ${body}=             Create Dictionary      corporateName=${NOMECORPORACAO}    registerCompany=${CNPJ}    mail=${MAIL}    matriz=${MATRIZ}    responsibleContact=${RESPONSAVEL}    telephone=${FONE}    serviceDescription=${RAMOATIVIDADE}    address=${address}
    ${headers}=          Create Dictionary      Authorization=${TOKEN}
    ${response}=         POST On Session        alias=supernatural    url=/company    headers=${headers}    json=${body}    expected_status=400
Bairro em branco
    Gerar variáveis Faker
    ${BAIRRO}=           Set Variable
 
    ${address}=          Create List
    ${endereco}=         Create Dictionary      zipCode=${CEP}    city=${CIDADE}    state=${ESTADO}    district=${BAIRRO}    street=${ENDERECO}    number=${NUMERO}    complement=${COMPLEMENTO}    country=${PAIS}
    Append To List       ${address}             ${endereco}
    ${body}=             Create Dictionary      corporateName=${NOMECORPORACAO}    registerCompany=${CNPJ}    mail=${MAIL}    matriz=${MATRIZ}    responsibleContact=${RESPONSAVEL}    telephone=${FONE}    serviceDescription=${RAMOATIVIDADE}    address=${address}
    ${headers}=          Create Dictionary      Authorization=${TOKEN}
    ${response}=         POST On Session        alias=supernatural    url=/company    headers=${headers}    json=${body}    expected_status=400
Bairro com mais de 50 caracteres
    Gerar variáveis Faker
    ${BAIRRO}=           Generate Random String    length=81    chars=\[LETTERS\]\[NUMBERS\]
 
    ${address}=          Create List
    ${endereco}=         Create Dictionary      zipCode=${CEP}    city=${CIDADE}    state=${ESTADO}    district=${BAIRRO}    street=${ENDERECO}    number=${NUMERO}    complement=${COMPLEMENTO}    country=${PAIS}
    Append To List       ${address}             ${endereco}
    ${body}=             Create Dictionary      corporateName=${NOMECORPORACAO}    registerCompany=${CNPJ}    mail=${MAIL}    matriz=${MATRIZ}    responsibleContact=${RESPONSAVEL}    telephone=${FONE}    serviceDescription=${RAMOATIVIDADE}    address=${address}
    ${headers}=          Create Dictionary      Authorization=${TOKEN}
    ${response}=         POST On Session        alias=supernatural    url=/company    headers=${headers}    json=${body}    expected_status=400
Bairro com caracteres especiais exceto regra
    Gerar variáveis Faker
    ${BAIRRO}=           Set Variable    !@#$%¨&*
 
    ${address}=          Create List
    ${endereco}=         Create Dictionary      zipCode=${CEP}    city=${CIDADE}    state=${ESTADO}    district=${BAIRRO}    street=${ENDERECO}    number=${NUMERO}    complement=${COMPLEMENTO}    country=${PAIS}
    Append To List       ${address}             ${endereco}
    ${body}=             Create Dictionary      corporateName=${NOMECORPORACAO}    registerCompany=${CNPJ}    mail=${MAIL}    matriz=${MATRIZ}    responsibleContact=${RESPONSAVEL}    telephone=${FONE}    serviceDescription=${RAMOATIVIDADE}    address=${address}
    ${headers}=          Create Dictionary      Authorization=${TOKEN}
    ${response}=         POST On Session        alias=supernatural    url=/company    headers=${headers}    json=${body}    expected_status=400
CEP em branco
    Gerar variáveis Faker
    ${CEP}=              Set Variable
 
    ${address}=          Create List
    ${endereco}=         Create Dictionary      zipCode=${CEP}    city=${CIDADE}    state=${ESTADO}    district=${BAIRRO}    street=${ENDERECO}    number=${NUMERO}    complement=${COMPLEMENTO}    country=${PAIS}
    Append To List       ${address}             ${endereco}
    ${body}=             Create Dictionary      corporateName=${NOMECORPORACAO}    registerCompany=${CNPJ}    mail=${MAIL}    matriz=${MATRIZ}    responsibleContact=${RESPONSAVEL}    telephone=${FONE}    serviceDescription=${RAMOATIVIDADE}    address=${address}
    ${headers}=          Create Dictionary      Authorization=${TOKEN}
    ${response}=         POST On Session        alias=supernatural    url=/company    headers=${headers}    json=${body}    expected_status=400
CEP com mais de 8 caracteres
    Gerar variáveis Faker
    ${CEP}=              Generate Random String    length=9    chars=[NUMBERS]
 
    ${address}=          Create List
    ${endereco}=         Create Dictionary      zipCode=${CEP}    city=${CIDADE}    state=${ESTADO}    district=${BAIRRO}    street=${ENDERECO}    number=${NUMERO}    complement=${COMPLEMENTO}    country=${PAIS}
    Append To List       ${address}             ${endereco}
    ${body}=             Create Dictionary      corporateName=${NOMECORPORACAO}    registerCompany=${CNPJ}    mail=${MAIL}    matriz=${MATRIZ}    responsibleContact=${RESPONSAVEL}    telephone=${FONE}    serviceDescription=${RAMOATIVIDADE}    address=${address}
    ${headers}=          Create Dictionary      Authorization=${TOKEN}
    ${response}=         POST On Session        alias=supernatural    url=/company    headers=${headers}    json=${body}    expected_status=400
CEP com letras
    Gerar variáveis Faker
    ${CEP}=              Generate Random String    length=8    chars=[LETTERS]
 
    ${address}=          Create List
    ${endereco}=         Create Dictionary      zipCode=${CEP}    city=${CIDADE}    state=${ESTADO}    district=${BAIRRO}    street=${ENDERECO}    number=${NUMERO}    complement=${COMPLEMENTO}    country=${PAIS}
    Append To List       ${address}             ${endereco}
    ${body}=             Create Dictionary      corporateName=${NOMECORPORACAO}    registerCompany=${CNPJ}    mail=${MAIL}    matriz=${MATRIZ}    responsibleContact=${RESPONSAVEL}    telephone=${FONE}    serviceDescription=${RAMOATIVIDADE}    address=${address}
    ${headers}=          Create Dictionary      Authorization=${TOKEN}
    ${response}=         POST On Session        alias=supernatural    url=/company    headers=${headers}    json=${body}    expected_status=400

Cidade em branco
    Gerar variáveis Faker
    ${CIDADE}=           Set Variable
 
    ${address}=          Create List
    ${endereco}=         Create Dictionary      zipCode=${CEP}    city=${CIDADE}    state=${ESTADO}    district=${BAIRRO}    street=${ENDERECO}    number=${NUMERO}    complement=${COMPLEMENTO}    country=${PAIS}
    Append To List       ${address}             ${endereco}
    ${body}=             Create Dictionary      corporateName=${NOMECORPORACAO}    registerCompany=${CNPJ}    mail=${MAIL}    matriz=${MATRIZ}    responsibleContact=${RESPONSAVEL}    telephone=${FONE}    serviceDescription=${RAMOATIVIDADE}    address=${address}
    ${headers}=          Create Dictionary      Authorization=${TOKEN}
    ${response}=         POST On Session        alias=supernatural    url=/company    headers=${headers}    json=${body}    expected_status=400
Cidade com mais de 50 caracteres
    Gerar variáveis Faker
    ${CIDADE}=           Generate Random String    length=51    chars=[LETTERS]
 
    ${address}=          Create List
    ${endereco}=         Create Dictionary      zipCode=${CEP}    city=${CIDADE}    state=${ESTADO}    district=${BAIRRO}    street=${ENDERECO}    number=${NUMERO}    complement=${COMPLEMENTO}    country=${PAIS}
    Append To List       ${address}             ${endereco}
    ${body}=             Create Dictionary      corporateName=${NOMECORPORACAO}    registerCompany=${CNPJ}    mail=${MAIL}    matriz=${MATRIZ}    responsibleContact=${RESPONSAVEL}    telephone=${FONE}    serviceDescription=${RAMOATIVIDADE}    address=${address}
    ${headers}=          Create Dictionary      Authorization=${TOKEN}
    ${response}=         POST On Session        alias=supernatural    url=/company    headers=${headers}    json=${body}    expected_status=400
Cidade com numeros
    Gerar variáveis Faker
    ${CIDADE}=           Generate Random String    length=50    chars=[NUMBERS]
 
    ${address}=          Create List
    ${endereco}=         Create Dictionary      zipCode=${CEP}    city=${CIDADE}    state=${ESTADO}    district=${BAIRRO}    street=${ENDERECO}    number=${NUMERO}    complement=${COMPLEMENTO}    country=${PAIS}
    Append To List       ${address}             ${endereco}
    ${body}=             Create Dictionary      corporateName=${NOMECORPORACAO}    registerCompany=${CNPJ}    mail=${MAIL}    matriz=${MATRIZ}    responsibleContact=${RESPONSAVEL}    telephone=${FONE}    serviceDescription=${RAMOATIVIDADE}    address=${address}
    ${headers}=          Create Dictionary      Authorization=${TOKEN}
    ${response}=         POST On Session        alias=supernatural    url=/company    headers=${headers}    json=${body}    expected_status=400
Cidade com caracteres especiais exceto regra
    Gerar variáveis Faker
    ${CIDADE}=           Set Variable    !@#$%¨&*
 
    ${address}=          Create List
    ${endereco}=         Create Dictionary      zipCode=${CEP}    city=${CIDADE}    state=${ESTADO}    district=${BAIRRO}    street=${ENDERECO}    number=${NUMERO}    complement=${COMPLEMENTO}    country=${PAIS}
    Append To List       ${address}             ${endereco}
    ${body}=             Create Dictionary      corporateName=${NOMECORPORACAO}    registerCompany=${CNPJ}    mail=${MAIL}    matriz=${MATRIZ}    responsibleContact=${RESPONSAVEL}    telephone=${FONE}    serviceDescription=${RAMOATIVIDADE}    address=${address}
    ${headers}=          Create Dictionary      Authorization=${TOKEN}
    ${response}=         POST On Session        alias=supernatural    url=/company    headers=${headers}    json=${body}    expected_status=400

Estado em branco
    Gerar variáveis Faker
    ${ESTADO}=           Set Variable
 
    ${address}=          Create List
    ${endereco}=         Create Dictionary      zipCode=${CEP}    city=${CIDADE}    state=${ESTADO}    district=${BAIRRO}    street=${ENDERECO}    number=${NUMERO}    complement=${COMPLEMENTO}    country=${PAIS}
    Append To List       ${address}             ${endereco}
    ${body}=             Create Dictionary      corporateName=${NOMECORPORACAO}    registerCompany=${CNPJ}    mail=${MAIL}    matriz=${MATRIZ}    responsibleContact=${RESPONSAVEL}    telephone=${FONE}    serviceDescription=${RAMOATIVIDADE}    address=${address}
    ${headers}=          Create Dictionary      Authorization=${TOKEN}
    ${response}=         POST On Session        alias=supernatural    url=/company    headers=${headers}    json=${body}    expected_status=400
Estado mais de duas letras
    Gerar variáveis Faker
    ${ESTADO}=           Generate Random String    length=3    chars=[LETTERS]
 
    ${address}=          Create List
    ${endereco}=         Create Dictionary      zipCode=${CEP}    city=${CIDADE}    state=${ESTADO}    district=${BAIRRO}    street=${ENDERECO}    number=${NUMERO}    complement=${COMPLEMENTO}    country=${PAIS}
    Append To List       ${address}             ${endereco}
    ${body}=             Create Dictionary      corporateName=${NOMECORPORACAO}    registerCompany=${CNPJ}    mail=${MAIL}    matriz=${MATRIZ}    responsibleContact=${RESPONSAVEL}    telephone=${FONE}    serviceDescription=${RAMOATIVIDADE}    address=${address}
    ${headers}=          Create Dictionary      Authorization=${TOKEN}
    ${response}=         POST On Session        alias=supernatural    url=/company    headers=${headers}    json=${body}    expected_status=400
Estado com caracteres especiais
    Gerar variáveis Faker
    ${ESTADO}=           Set Variable    !@
 
    ${address}=          Create List
    ${endereco}=         Create Dictionary      zipCode=${CEP}    city=${CIDADE}    state=${ESTADO}    district=${BAIRRO}    street=${ENDERECO}    number=${NUMERO}    complement=${COMPLEMENTO}    country=${PAIS}
    Append To List       ${address}             ${endereco}
    ${body}=             Create Dictionary      corporateName=${NOMECORPORACAO}    registerCompany=${CNPJ}    mail=${MAIL}    matriz=${MATRIZ}    responsibleContact=${RESPONSAVEL}    telephone=${FONE}    serviceDescription=${RAMOATIVIDADE}    address=${address}
    ${headers}=          Create Dictionary      Authorization=${TOKEN}
    ${response}=         POST On Session        alias=supernatural    url=/company    headers=${headers}    json=${body}    expected_status=400
Estado com numeros
    Gerar variáveis Faker
    ${ESTADO}=           Generate Random String    length=2    chars=[NUMBERS]
 
    ${address}=          Create List
    ${endereco}=         Create Dictionary      zipCode=${CEP}    city=${CIDADE}    state=${ESTADO}    district=${BAIRRO}    street=${ENDERECO}    number=${NUMERO}    complement=${COMPLEMENTO}    country=${PAIS}
    Append To List       ${address}             ${endereco}
    ${body}=             Create Dictionary      corporateName=${NOMECORPORACAO}    registerCompany=${CNPJ}    mail=${MAIL}    matriz=${MATRIZ}    responsibleContact=${RESPONSAVEL}    telephone=${FONE}    serviceDescription=${RAMOATIVIDADE}    address=${address}
    ${headers}=          Create Dictionary      Authorization=${TOKEN}
    ${response}=         POST On Session        alias=supernatural    url=/company    headers=${headers}    json=${body}    expected_status=400

Pais em branco
    Gerar variáveis Faker
    ${PAIS}=             Set Variable
 
    ${address}=          Create List
    ${endereco}=         Create Dictionary      zipCode=${CEP}    city=${CIDADE}    state=${ESTADO}    district=${BAIRRO}    street=${ENDERECO}    number=${NUMERO}    complement=${COMPLEMENTO}    country=${PAIS}
    Append To List       ${address}             ${endereco}
    ${body}=             Create Dictionary      corporateName=${NOMECORPORACAO}    registerCompany=${CNPJ}    mail=${MAIL}    matriz=${MATRIZ}    responsibleContact=${RESPONSAVEL}    telephone=${FONE}    serviceDescription=${RAMOATIVIDADE}    address=${address}
    ${headers}=          Create Dictionary      Authorization=${TOKEN}
    ${response}=         POST On Session        alias=supernatural    url=/company    headers=${headers}    json=${body}    expected_status=400
Pais com mais de 50 caracteres
    Gerar variáveis Faker
    ${PAIS}=             Generate Random String    length=51    chars=[LETTERS]
 
    ${address}=          Create List
    ${endereco}=         Create Dictionary      zipCode=${CEP}    city=${CIDADE}    state=${ESTADO}    district=${BAIRRO}    street=${ENDERECO}    number=${NUMERO}    complement=${COMPLEMENTO}    country=${PAIS}
    Append To List       ${address}             ${endereco}
    ${body}=             Create Dictionary      corporateName=${NOMECORPORACAO}    registerCompany=${CNPJ}    mail=${MAIL}    matriz=${MATRIZ}    responsibleContact=${RESPONSAVEL}    telephone=${FONE}    serviceDescription=${RAMOATIVIDADE}    address=${address}
    ${headers}=          Create Dictionary      Authorization=${TOKEN}
    ${response}=         POST On Session        alias=supernatural    url=/company    headers=${headers}    json=${body}    expected_status=400
Pais com numeros                # Gerado card de melhoria 16170 Nome de País com números
    Gerar variáveis Faker
    ${PAIS}=             Generate Random String    length=50    chars=[NUMBERS]
 
    ${address}=          Create List
    ${endereco}=         Create Dictionary      zipCode=${CEP}    city=${CIDADE}    state=${ESTADO}    district=${BAIRRO}    street=${ENDERECO}    number=${NUMERO}    complement=${COMPLEMENTO}    country=${PAIS}
    Append To List       ${address}             ${endereco}
    ${body}=             Create Dictionary      corporateName=${NOMECORPORACAO}    registerCompany=${CNPJ}    mail=${MAIL}    matriz=${MATRIZ}    responsibleContact=${RESPONSAVEL}    telephone=${FONE}    serviceDescription=${RAMOATIVIDADE}    address=${address}
    ${headers}=          Create Dictionary      Authorization=${TOKEN}
    ${response}=         POST On Session        alias=supernatural    url=/company    headers=${headers}    json=${body}    expected_status=201
