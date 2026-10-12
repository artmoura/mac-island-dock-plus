# Mac Island & Dock Plus

Um fork do mod do [Windhawk](https://windhawk.net)
**[Mac Island & Dock](https://windhawk.net/mods/mac-island-dock)**, de
[caliberda](https://github.com/cesarkali), com mudanças na barra superior, na
pílula e na dock para ficar mais perto do macOS.

O mod original já traz a ilha no topo (relógio, central de controle,
notificações, mídia, ícones da bandeja) e a dock no lugar da barra de tarefas.
Este fork acrescenta o que está abaixo; tudo o mais é do original.

## O que o fork acrescenta

### Barra superior (modo barra)
- **Itens nas duas pontas**, como no macOS: botão de desligar, nome do app e
  extras à esquerda; bandeja, status e relógio à direita (ou o relógio sozinho
  no meio).
- **Fundo só atrás dos itens**: o resto da barra fica transparente e o mouse
  passa para as janelas de baixo.
- **Em todos os monitores**, cada um com a faixa reservada; clicar ou passar
  o mouse na barra de outro monitor leva a ilha para lá.
- **Nome do app em foco** em negrito, com um menu (minimizar,
  maximizar/restaurar, fechar janela, encerrar app).

### Pílula
- **Compacta**: só os itens escolhidos (e o relógio) até o mouse chegar, e
  então mostra tudo.
- **Largura máxima** (% da tela): a lista de ícones da bandeja rola para caber.
- **Porcentagem da bateria** ao lado do ícone.

### Aparência
- **Ícones de Wi-Fi, volume e bateria no estilo do macOS**, desenhados.
- **Fonte configurável** (por exemplo, a [Inter](https://rsms.me/inter/)).
- **Cores que seguem o modo claro e escuro do Windows**, com um tema escolhido
  para cada um.

### Dock
- **Espaço nas pontas** e ajuste da **altura dos ícones**.
- A janela da barra de tarefas **recortada na dock**: o resto da borda de baixo
  fica clicável.
- **Só a dock do monitor com o mouse aparece**, e a ampliação vai junto.
- Os ícones ampliados respeitam a **foto do perfil do Chrome** (e outras
  sobreposições) dentro da barra.

### Correções
- **Clima** em redes com IPv6 que não alcança o servidor, e busca da cidade
  que entende "Cidade - UF".

As opções novas ficam nas configurações do mod no Windhawk e, quase todas,
também no painel da própria ilha (botão direito na ilha, depois a engrenagem).

## Instalar

1. No Windhawk, **Criar novo mod**.
2. No editor, apague tudo e cole o conteúdo de
   [`mac-island-dock-fork.wh.cpp`](mac-island-dock-fork.wh.cpp).
3. **Compilar** (Ctrl+B).
4. Desative o **Mac Island & Dock** original, se estiver instalado (os dois
   juntos mostram duas ilhas).

Para a dock ter espaço para os ícones crescerem, deixe a barra de tarefas mais
alta com o mod
[Taskbar height and icon size](https://windhawk.net/mods/taskbar-icon-size)
(por exemplo, 72 px).

## Desenvolvimento

- `check.sh` — procura erros de compilação com o compilador do próprio
  Windhawk, sem instalar.
- `deploy.ps1` — instala e compila o fork no Windhawk (como administrador).
- `update-upstream.sh` — traz uma versão nova do mod original para o branch
  `upstream` e a mescla com o fork.
- `tools/edgelog.cpp` — registra o que está na tela quando o mouse chega na
  borda de baixo (para depurar a dock que não aparece).

## Licença e créditos

GPL-3.0, como o original.

- **Mac Island & Dock**: [caliberda](https://github.com/cesarkali)
  ([caliberda.com.br](https://caliberda.com.br)).
- A parte que alcança a árvore XAML da barra de tarefas vem do mod **Taskbar
  tray auto-hide (show on hover)**, de [m417z](https://github.com/m417z).
