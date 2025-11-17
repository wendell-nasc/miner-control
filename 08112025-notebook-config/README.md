🧩 1️⃣ Editar o arquivo logind.conf

Abra o arquivo de configuração:

sudo nano /etc/systemd/logind.conf


Procure (ou adicione) as linhas abaixo — comente as antigas (colocando # na frente) e use estas:

HandleLidSwitch=ignore
HandleLidSwitchDocked=ignore
HandleLidSwitchExternalPower=ignore


💡 Essas opções significam:

ignore: o sistema não faz nada quando a tampa é fechada

docked: ignora também quando o notebook está conectado a um monitor externo

ExternalPower: ignora mesmo conectado à tomada

🧩 2️⃣ Reiniciar o serviço logind

Após salvar (Ctrl + O, depois Enter, e Ctrl + X para sair do nano), rode:

sudo systemctl restart systemd-logind

🧩 3️⃣ Desativar hibernação e suspensão totalmente (opcional)

Se quiser garantir que o sistema nunca suspenda ou hiberne:

sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target


Isso impede que qualquer aplicativo ou evento acione hibernação/suspensão.

Se quiser reverter:

sudo systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target

🧩 4️⃣ (Opcional) Apagar a tela ao fechar a tampa

Se você quer que a tela apenas desligue, pode criar uma pequena regra no xset (caso use ambiente gráfico):

xset dpms force off


Você pode adicionar esse comando em um script que detecta o fechamento da tampa — mas em notebooks modernos o próprio driver de vídeo apaga o display automaticamente quando HandleLidSwitch=ignore.

✅ Resumo final
Função	Configuração
Não suspender ao fechar tampa	HandleLidSwitch=ignore
Não hibernar	mask hibernate.target
Não desligar/suspender manualmente	mask sleep.target
Apenas apagar tela	Automático ou via xset dpms force off



# ✅ — para desligar monitor automaticamente o monitor após 3 minutos de inatividade no Ubuntu 20.04 (via terminal), você pode usar o xset, que controla o servidor gráfico (X11).

💡 Comando direto (válido apenas para sessão atual)

Abra o terminal e execute:

xset dpms 0 0 180
xset s off


🔍 Explicando:

xset dpms <standby> <suspend> <off> — define os tempos (em segundos).

Aqui usamos 180 segundos = 3 minutos para o monitor desligar.

xset s off — desativa o screensaver para evitar conflito.

📌 Isso funciona apenas até o reboot ou logout.

🔁 Para deixar permanente (toda inicialização)
Opção 1: via .profile (usuário atual)

Adicione as linhas abaixo ao final do arquivo:

nano ~/.profile


E cole:

# Desligar monitor após 3 minutos de inatividade
xset dpms 0 0 180
xset s off


Salve com CTRL+O, saia com CTRL+X, e reinicie a sessão.