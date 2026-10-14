<div align="center">

# ⚡ dotfiles

**Meu setup Linux pessoal — Wayland · Hyprland · Quickshell**

[![Arch Linux](https://img.shields.io/badge/Arch_Linux-1793D1?style=for-the-badge&logo=arch-linux&logoColor=white)](https://archlinux.org)
[![Hyprland](https://img.shields.io/badge/Hyprland-0.56.2-58E1FF?style=for-the-badge&logo=wayland&logoColor=black)](https://hyprland.org)
[![Wayland](https://img.shields.io/badge/Wayland-FFBC00?style=for-the-badge&logo=wayland&logoColor=black)](https://wayland.freedesktop.org)
[![Quickshell](https://img.shields.io/badge/Quickshell-ii-8A2BE2?style=for-the-badge&logo=qt&logoColor=white)](https://quickshell.org)
[![Git](https://img.shields.io/badge/versionado_com-Git-F05032?style=for-the-badge&logo=git&logoColor=white)](https://git-scm.com)

<sub>📦 <b>1.064 arquivos</b> · 🕓 snapshot <b>2026-10-14</b> · 🖥️ host <code>weez</code> · 🏷️ <code>v2026.10.14</code></sub>

</div>

---

## 🚀 Sobre

Este repositório guarda as **dotfiles** do meu ambiente de trabalho no **Arch Linux**,
rodando **Hyprland** sobre **Wayland** com o shell **Quickshell** (base
[illogical-impulse / ii](https://github.com/end-4/dots-hyprland)).

O layout espelha o `$HOME`: tudo que é configuração fica sob [`.config/`](./.config),
mais os arquivos de shell na raiz. Assim o "restore" é só copiar de volta para casa.

> ⚠️ **Caches, dados de aplicativos e credenciais não são versionados** por segurança.

## 🧩 Stack

| Camada | Ferramenta |
| :--- | :--- |
| 🪟 **Compositor** | [Hyprland](https://hyprland.org) `0.56.2` (Wayland) |
| 🎛️ **Shell / UI** | [Quickshell](https://quickshell.org) · `` ii `` (illogical-impulse) |
| 🐚 **Shell (CLI)** | [fish](https://fishshell.com) + [starship](https://starship.rs) |
| 💻 **Terminais** | [foot](https://codeberg.org/dnkl/foot) · [kitty](https://sw.kovidgoyal.net/kitty) |
| 🔎 **Launcher** | [fuzzel](https://codeberg.org/dnkl/fuzzel) |
| 🎨 **Tema** | [matugen](https://github.com/InioX/matugen) · Kvantum · KDE Material You Colors · GTK/Qt |
| 🔒 **Lock / Idle** | hyprlock · hypridle |
| 🚪 **Logout** | wlogout |
| 📊 **Utilitários** | btop · cava · fastfetch · htop · mpv · eza · ydotool · cliphist |

## 📁 Estrutura

```text
.
├── .config/
│   ├── hypr/                 # Hyprland, hyprlock, hypridle (+ hyprland.lua)
│   ├── quickshell/ii/        # Shell do desktop (illogical-impulse)
│   ├── illogical-impulse/    # Estado/config do tema
│   ├── fish/  zshrc.d/       # Shells
│   ├── kitty/  foot/  fuzzel/  # Terminais e launcher
│   ├── btop/  cava/  htop/  fastfetch/  mpv/  # Utilitários
│   ├── matugen/  Kvantum/  kde-material-you-colors/  # Cores e tema
│   ├── fontconfig/  gtk-3.0/  gtk-4.0/  menus/  # Fontes, GTK, menus
│   ├── systemd/  xdg-desktop-portal/  session/     # Sessão/portal
│   ├── kdeglobals  dolphinrc  konsolerc  darklyrc  # KDE
│   ├── gtkrc  gtkrc-2.0  QtProject.conf  Trolltech.conf
│   ├── starship.toml         # Prompt
│   └── *-flags.conf          # Flags de navegadores/Electron
├── .bashrc
├── .bash_profile
├── .bash_logout
├── .gitignore
└── README.md
```

## ⌨️ Keybinds

Tecla modificadora principal: **`SUPER`**.

| Atalho | Ação |
| :--- | :--- |
| `SUPER` + `Return` | Abrir terminal |
| `SUPER` + `Q` | Fechar janela |
| `SUPER` + `A` | Sidebar esquerda |
| `SUPER` + `N` | Sidebar direita |
| `SUPER` + `Tab` | Visão geral (overview) |
| `SUPER` + `V` | Histórico da área de transferência |
| `SUPER` + `Slash` | Cheatsheet |
| `CTRL` + `SUPER` + `T` | Trocar wallpaper |
| `CTRL` + `SUPER` + `SHIFT` + `D` | Alternar tema claro/escuro |
| `SUPER` + `L` | Bloquear sessão |
| `CTRL` + `ALT` + `Delete` | Menu de sessão |

> A lista completa é gerada pelo próprio shell — pressione `SUPER` + `Slash`.

## 📥 Instalação

Faça um backup das suas configs e restaure este snapshot para o `$HOME`:

```bash
# 1. Clone
git clone git@github.com:httpweez/dotfiles.git ~/dotfiles

# 2. Backup do que já existe (opcional, mas recomendado)
mkdir -p ~/dotfiles-backup && cp -a ~/.config ~/dotfiles-backup/

# 3. Restaurar as configs para o $HOME
rsync -a ~/dotfiles/.config/ ~/.config/
cp -a ~/dotfiles/.bashrc ~/dotfiles/.bash_profile ~/dotfiles/.bash_logout ~/

# 4. Recarregar o shell
exec fish
```

<details>
<summary>Alternativa com <b>GNU Stow</b></summary>

O layout é compatível com o [GNU Stow](https://www.gnu.org/software/stow/). Como o
repositório espelha o `$HOME`, uma opção é stowar pacote por pacote (após reorganizar
cada app em seu próprio diretório na raiz do repo):

```bash
cd ~/dotfiles
stow -t ~ hypr quickshell fish kitty foot fuzzel
```
</details>

## 🗂️ Versionamento

Snapshots são marcados com a **data da captura** no formato `vYYYY.MM.DD`:

```bash
git tag          # lista as capturas
git tag -a "v$(date +%Y.%m.%d)" -m "Captura $(date +%F)"
```

Para atualizar:

```bash
cd ~/dotfiles
# recopie as configs desejadas do ~/.config
git add -A
git commit -m "Atualiza dotfiles em $(date +%F)"
git push origin main --tags
```

## 🙏 Créditos

- [end-4 / dots-hyprland](https://github.com/end-4/dots-hyprland) — base do shell **illogical-impulse (ii)**
- [Hyprland](https://hyprland.org) · [Quickshell](https://quickshell.org) — projetos open-source

## 📄 Licença

Uso pessoal. Componentes de terceiros mantêm suas licenças originais.

<div align="center"><sub>Feito com ☕ e 🌙 em Arch Linux.</sub></div>
