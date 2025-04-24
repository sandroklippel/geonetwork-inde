UNIDADE = geonetwork-inde.service
CAMINHO_UNIDADE_SISTEMA = /etc/systemd/system/
CAMINHO_UNIDADE_LOCAL = .
COMPOSE_FILE = docker-compose.yaml
USUARIO_SERVICO = geonetwork
HOME_USUARIO = /home/$(USUARIO_SERVICO)

.PHONY: all install create-user copy-compose start stop restart status enable disable reload logs

all: status

create-user:
	@echo "Criando o usuário $(USUARIO_SERVICO)..."
	@sudo id -u "$(USUARIO_SERVICO)" > /dev/null 2>&1 || sudo useradd -m "$(USUARIO_SERVICO)"
	@echo "Defina a senha para o usuário $(USUARIO_SERVICO):"
	@read -s SENHA_USUARIO
	@echo "" # Adiciona uma nova linha após a entrada da senha (por segurança)
	@echo "Definindo a senha para o usuário $(USUARIO_SERVICO)..."
	@sudo bash -c "echo '$(USUARIO_SERVICO):$$SENHA_USUARIO' | chpasswd"
	@echo "Usuário $(USUARIO_SERVICO) criado e senha definida."

copy-compose: create-user
	@echo "Copiando o arquivo $(COMPOSE_FILE) para $(HOME_USUARIO)..."
	@sudo cp $(COMPOSE_FILE) "$(HOME_USUARIO)/"
	@sudo chown "$(USUARIO_SERVICO)":"$(USUARIO_SERVICO)" "$(HOME_USUARIO)/$(COMPOSE_FILE)"
	@echo "Arquivo $(COMPOSE_FILE) copiado para $(HOME_USUARIO) e com a propriedade de $(USUARIO_SERVICO)."

install:
	@echo "Copiando o arquivo de unidade $(UNIDADE) para $(CAMINHO_UNIDADE_SISTEMA)..."
	@sudo cp $(CAMINHO_UNIDADE_LOCAL)/$(UNIDADE) $(CAMINHO_UNIDADE_SISTEMA)
	@echo "Ajustando as permissões do arquivo de unidade..."
	@sudo chmod 644 $(CAMINHO_UNIDADE_SISTEMA)/$(UNIDADE)
	@echo "Recarregando a configuração do systemd..."
	@sudo systemctl daemon-reload

start:
	@echo "Iniciando o serviço $(UNIDADE)..."
	@sudo systemctl start $(UNIDADE)

stop:
	@echo "Parando o serviço $(UNIDADE)..."
	@sudo systemctl stop $(UNIDADE)

restart: stop start
	@echo "Reiniciando o serviço $(UNIDADE)..."

status:
	@echo "Verificando o status do serviço $(UNIDADE)..."
	@sudo systemctl status $(UNIDADE) --full --lines=20

enable:
	@echo "Habilitando o serviço $(UNIDADE) para iniciar na inicialização..."
	@sudo systemctl enable $(UNIDADE)

disable:
	@echo "Desabilitando o serviço $(UNIDADE) para não iniciar na inicialização..."
	@sudo systemctl disable $(UNIDADE)

reload:
	@echo "Recarregando a configuração do systemd..."
	@sudo systemctl daemon-reload

logs:
	@echo "Visualizando os logs do serviço $(UNIDADE)..."
	@sudo journalctl -u $(UNIDADE) -f -n 50