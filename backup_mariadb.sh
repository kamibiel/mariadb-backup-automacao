#!/bin/bash

# ---------------------------------
# Configurações
# ---------------------------------
DATA=$(date +"%Y%m%d_%H%M%S")             # Inclui data e hora
PASTA_TEMP="/tmp/bkp_bancos"
PASTA_DESTINO="/mnt/gdrive_backup/bkp_bd"
USUARIO_BACKUP="[NOME DO USUÁRIO]"         # Seu usuário
SENHA_BACKUP="[SENHA]"           # Sua senha

# ---------------------------------
# Criação da pasta temporária
# ---------------------------------
mkdir -p "$PASTA_TEMP"

# ---------------------------------
# Listar bancos de dados (ignorando os padrões do sistema)
# ---------------------------------
bancos=$(mysql -u "$USUARIO_BACKUP" -p"$SENHA_BACKUP" --batch --skip-column-names -e "SHOW DATABASES;" | grep -Ev "(information_schema|performance_schema|mysql|sys)")

# ---------------------------------
# Fazer dump e compactar cada banco separadamente
# ---------------------------------
for banco in $bancos; do
    if [[ ! -z "$banco" ]]; then
        echo "Realizando backup do banco: $banco"
        
        # Dump do banco
        mariadb-dump -u "$USUARIO_BACKUP" -p"$SENHA_BACKUP" "$banco" > "$PASTA_TEMP/bkp_${banco}_${DATA}.sql"
        
        # Compactar o dump individualmente em .tar.gz
        cd "$PASTA_TEMP"
        tar -czvf "bkp_${banco}_${DATA}.tar.gz" "bkp_${banco}_${DATA}.sql"
        
        # Mover o arquivo tar.gz para o Google Drive
        mv "bkp_${banco}_${DATA}.tar.gz" "$PASTA_DESTINO/"
        
        # Remover o .sql depois de compactar
        rm "bkp_${banco}_${DATA}.sql"
        
        # Manter apenas as 2 últimas cópias para este banco
        cd "$PASTA_DESTINO"
        ls -1tr bkp_${banco}_*.tar.gz | head -n -2 | xargs -d '\n' rm -f --
    fi
done

# ---------------------------------
# Limpar pasta temporária
# ---------------------------------
rm -rf "$PASTA_TEMP"

# ---------------------------------
# Fim
# ---------------------------------
echo "Backup concluído com sucesso em $DATA"
