*** Settings ***
Library    FakerLibrary    locale=pt_BR
Library    String

*** Keywords ***
Gerar variáveis Faker
    ${NOMECORPORACAO}=   Company
    ${CNPJ}=             Generate Random String    14     [NUMBERS]
    ${MAIL}=             Email
    ${MATRIZ}=           Company
    ${RESPONSAVEL}=      Name
    ${FONE}=             random_number    digits=14       fix_len=True
    ${RAMOATIVIDADE}=    Job
    ${CEP}=              Generate Random String    8      [NUMBERS]
    ${CIDADE}=           City
    ${ESTADO}=           State Abbr
    ${ENDERECO}=         Street Suffix
    ${BAIRRO}=           City
    ${NUMERO}=           Generate Random String    10     [NUMBERS]
    ${COMPLEMENTO}       First Name
    ${PAIS}=             Country

    Set Suite Variable    ${NOMECORPORACAO}      ${NOMECORPORACAO}
    Set Suite Variable    ${CNPJ}                ${CNPJ}            
    Set Suite Variable    ${MAIL}                ${MAIL}
    Set Suite Variable    ${MATRIZ}              ${MATRIZ}
    Set Suite Variable    ${RESPONSAVEL}         ${RESPONSAVEL}
    Set Suite Variable    ${FONE}                ${FONE}
    Set Suite Variable    ${RAMOATIVIDADE}       ${RAMOATIVIDADE}
    Set Suite Variable    ${CEP}                 ${CEP}
    Set Suite Variable    ${CIDADE}              ${CIDADE}
    Set Suite Variable    ${ESTADO}              ${ESTADO}
    Set Suite Variable    ${ENDERECO}            ${ENDERECO}
    Set Suite Variable    ${BAIRRO}              ${BAIRRO}
    Set Suite Variable    ${NUMERO}              ${NUMERO}
    Set Suite Variable    ${COMPLEMENTO}         ${COMPLEMENTO}  
    Set Suite Variable    ${PAIS}                ${PAIS}
