# Dotfiles

Configurações pessoais versionadas com Git.

- **Captura:** 2026-10-14
- **Criado por:** weezard
- **Ambiente:** Arch Linux (Hyprland + quickshell/illogical-impulse)

## Conteúdo

Este repositório guarda os arquivos de configuração do desktop, shell e terminais.
O layout segue o padrão `dotfiles` (um diretório `.config/` na raiz), compatível com
ferramentas como o GNU Stow.

Principais itens em `.config/`:

| Config | Descrição |
| --- | --- |
| `hypr/` | Hyprland, hypridle, hyprlock |
| `quickshell/` | Shell do desktop (illogical-impulse / ii) |
| `illogical-impulse/`, `matugen/`, `kde-material-you-colors/` | Tema e cores dinâmicas |
| `fish/`, `zshrc.d/`, `starship.toml` | Shell |
| `kitty/`, `foot/`, `fuzzel/` | Terminais e launcher |
| `btop/`, `cava/`, `fastfetch/`, `htop/` | Utilitários de terminal |
| `wlogout/`, `mpv/`, `fontconfig/`, `Kvantum/` | Diversos |
| `kdeglobals`, `dolphinrc`, `gtkrc*`, `QtProject.conf` | KDE / GTK / Qt |

Também são versionados `.bashrc`, `.bash_profile` e `.bash_logout`.

## O que NÃO é versionado

Caches, dados de aplicativos e credenciais (navegadores, editores, chaves,
sessões, etc.) ficam de fora por segurança.

## Versionamento

A captura inicial recebe a tag da data, por exemplo `v2026.10.14`.
