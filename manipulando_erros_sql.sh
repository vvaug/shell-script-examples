#!/bin/bash

# Declaracao de Variaveis
DIR_LOG=/home/vaug/scripts/logs/
ARQ_LOG="manipulando_erros_sql.log"

#Parametros

STRING=$1

QTD_PARAMS=$#

# Declaracao de Funcoes locais
function log (){
  echo "$(date | awk '{print $4}'): $1" >> ${DIR_LOG}${ARQ_LOG}
}


# Validacoes

 if [ ! -e ${DIR_LOG} ]; then
	echo  "Criando diretorio de LOG: ${DIR_LOG}"
	mkdir ${DIR_LOG}
 fi
 
 if [ ${QTD_PARAMS} -lt 1 ]; then
	 log "Quantidade de parametros passados incorreto!"
	 log "Exemplo de chamada: ./manipulando_erros_sql.sh PARAMETRO"
         exit
 fi
 
#######################################
#Inicio do processamento              #
#######################################

log "Chamando programa PL/SQL"

sqlplus -s $HR_SERVICE_NAME >> ${DIR_LOG}${ARQ_LOG} <<EOF
set heading off
set serveroutput on
EXEC PR_TESTE_SUCESSO_ERRO('${STRING}');
EXIT;
EOF

TEM_ERRO=$(cat ${DIR_LOG}${ARQ_LOG} | grep -i "ORA-" | wc -l)

  if [ ${TEM_ERRO} -gt 0 ]; then
	  log "SHELL ABORTADA POR ERRO"
	  exit
  fi

log "SHELL EXECUTADA COM SUCESSO"
