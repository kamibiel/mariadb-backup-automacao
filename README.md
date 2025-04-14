# mariadb-backup-automacao

Script Bash para automatizar o backup de bancos de dados MariaDB, gerando arquivos compactados `.tar.gz` por banco e armazenando em uma pasta local ou sincronizada (ex.: Google Drive via `rclone`).  
Backup organizado com rotação automática de cópias.

---

## 📚 Funcionalidades

- Dump de todos os bancos (um `.tar.gz` por banco).
- Mantém apenas as 5 últimas cópias de cada banco.
- Script compatível com **Arch Linux** e **Ubuntu**.
- Pode ser agendado com `cron` para execução automática (ex.: todos os dias às 23:30).
- Pode ser usado tanto em servidores (VPS/Cloud) quanto em máquinas locais.

---

## ⚙️ Requisitos

### Para Arch Linux:

```bash
sudo pacman -S mariadb-clients zip unzip tar rclone cronie
```

### Para Ubuntu:

```bash
sudo apt update
sudo apt install mariadb-client zip unzip tar rclone cron
```

---

## 📋 Instalações obrigatórias

| Pacote | Função |
|:-------|:-------|
| `mariadb-client` | Comando `mariadb-dump` para exportar bancos |
| `zip`, `unzip`, `tar` | Compactação e manipulação de arquivos |
| `rclone` | (opcional) Sincronizar com Google Drive ou outras clouds |
| `cronie` ou `cron` | Agendador de tarefas para backups automáticos |

---

## 👩‍💻 Como configurar

1. Clone este repositório:

```bash
git clone https://github.com/kamibiel/mariadb-backup-automacao.git
cd backup-mariadb-automatico
```

2. Edite o arquivo `backup_mariadb.sh`:

Atualize as variáveis:

```bash
USUARIO_BACKUP="seu_usuario_mariadb"
SENHA_BACKUP="sua_senha"
PASTA_DESTINO="/caminho/onde/armazenar/backups"
```

3. Dê permissão de execução:

```bash
chmod +x backup_mariadb.sh
```

4. Agende no `cron`:

```bash
crontab -e
```

Adicione no final:

```bash
30 23 * * * /caminho/absoluto/backup_mariadb.sh >> /caminho/absoluto/backup_mariadb.log 2>&1
```

---

## 🛠️ Rodando manualmente

Você pode testar o script rodando diretamente:

```bash
./backup_mariadb.sh
```

O resultado será um conjunto de arquivos `.tar.gz` no diretório especificado.

---

## ☁️ Backup local ou em cloud

- **Local**: Use uma pasta comum no seu sistema.
- **Cloud**: Monte a pasta usando `rclone` e aponte `PASTA_DESTINO` para lá.

Exemplo de montagem com Google Drive:

```bash
rclone config
rclone mount gdrive_backup: /mnt/gdrive_backup
```

---

## 📦 Estrutura esperada dos arquivos gerados

```
bkp_banco_teste_20250414_233001.tar.gz
bkp_banco_teste_1_20250414_233002.tar.gz
bkp_banco_teste_2_20250414_233003.tar.gz
bkp_banco_teste_3_20250414_233004.tar.gz
```

Um `.tar.gz` por banco, contendo o `.sql` do backup.

---

## ⚡ Observações

- Mantém apenas as 5 últimas cópias de cada banco.
- Usa `--single-transaction` para garantir consistência sem travar o banco.
- Recomenda-se usar um usuário de backup apenas com permissões `SELECT`, `SHOW VIEW`, `LOCK TABLES` e `CREATE TEMPORARY TABLES`.

---

## 🌟 Melhorias futuras (sugestões)

- Backup completo de usuários, triggers e procedures em arquivos separados.
- Backup mensal especial.
- Notificações de erro por e-mail.

---

# 🚀 Vamos colocar seu backup em produção!

> Desenvolvido para facilitar a vida de quem precisa de backups automáticos e seguros no MariaDB.  
> Feito com ❤️ para uso pessoal e servidores de produção.

