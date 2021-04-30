#!/bin/bash
#Validador de CEP
#Utilizando curl para requisições HTTP

DIAMESANO=$(date +%Y%m%d)
HORAMINSEG=$(date +%H%M%S)

CEP=$1
CEP_SIZE=$(echo ${CEP} | wc -m)
CEP_DEFAULT_SIZE=9
BASE_URL="https://viacep.com.br/ws/{cep}/json/"

QTD_PARAMS=$#

DIR_LOG=/home/vaug/scripts/logs/
ARQ_LOG="validador_cep_${DIAMESANO}_${HORAMINSEG}.log"

function logger(){

    echo "${DIAMESANO} | ${HORAMINSEG}: $1"

}

function doGet(){

URL=$(echo "https://viacep.com.br/ws/{cep}/json/" | sed 's/{cep}/'${CEP}'/')

HTTP_STATUS_CODE=$(curl -LI  ${URL} -o /dev/null -w '%{http_code}\n' -s)

return ${HTTP_STATUS_CODE}

}

 if [ ${CEP_SIZE} -ne ${CEP_DEFAULT_SIZE} ]; then
    
    logger "CEP deve ter 8 caracteres!"
    exit

 fi

logger "Consultando CEP: ${CEP}"

doGet

    if [ $? -ne 200 ]; then
      logger "Erro na requisição, verifique o CEP informado."
      exit
    fi
    
logger "CEP Válido!"