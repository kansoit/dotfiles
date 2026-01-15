# Dotfiles

Bienvenido a mi repositorio de archivos de configuración (dotfiles). Aquí encontrarás mis configuraciones personales para entornos Linux, centradas en mejorar la productividad y la experiencia en la terminal.

## Archivos Incluidos

### 🐚 .bashrc
Configuración para el shell **Bash**.
- **Historial sincronizado**: Configuración para mantener el historial actualizado en tiempo real entre sesiones.
- **Prompt**: Soporte para colores y git (si está disponible).
- **Aliases**: Atajos útiles para comandos comunes.

### 💤 .zshrc
Configuración para el shell **Zsh**, optimizado para el uso interactivo con plugins.
- **Plugins**: Carga plugins locales desde `~/.zsh/` (Autosuggestions, Syntax Highlighting, History Substring Search).
- **Prompt**: Configuración visual personalizada.
- **Keybindings**: Atajos de teclado mejorados (incluyendo soporte para teclado numérico).

## Características Comunes

Ambas configuraciones comparten un conjunto robusto de herramientas y aliases:

### 🛠 Herramientas y Utilidades
- **Starship**: Prompt moderno y rápido (si está instalado).
- **NVM**: Gestión de versiones de Node.js.
- **FZF & FD**: Búsqueda difusa de archivos y navegación en el historial.
- **Trash-cli**: Reemplazo seguro para `rm` (mueve a la papelera en lugar de borrar).
- **Micro**: Editor de texto amigable en terminal.
- **MicroK8s**: Alias para `kubectl`.

### ⚡ Aliases Destacados
| Alias | Comando Original | Descripción |
|-------|------------------|-------------|
| `ll` | `ls -halF` | Listado detallado |
| `la` | `ls -A` | Listado de casi todos los archivos |
| `grep` | `grep --color=auto` | Grep con colores |
| `mkdir` | `mkdir -pv` | Crea directorios padres y verbose |
| `hst` | `history \| fzf --tac` | Buscar en historial con FZF |
| `alert` | *script* | Notificación de escritorio al terminar comandos largos |

### 🌳 Git Aliases
Si `git` está instalado, se habilitan múltiples atajos:
- `gst`: `git status -sb`
- `gl`: `git log ...` (grafico y decorado)
- `ga`, `gaa`: `git add`
- `gc`, `gcm`: `git commit`
- `gp`, `gpl`: `git push`, `git pull`

## Requisitos previos

Para aprovechar al máximo estas configuraciones, se recomienda tener instaladas las siguientes herramientas:

- **Git**: Control de versiones.
- **FZF & FD**: Para búsquedas rápidas (`sudo apt install fzf fd-find`).
- **Trash-cli**: Para borrado seguro (`sudo apt install trash-cli`).
- **Starship**: Prompt cross-shell (`curl -sS https://starship.rs/install.sh | sh`).
- **NVM**: Node Version Manager.
- **Micro**: Editor de texto.

## Instalación

1.  Clona este repositorio:
    ```bash
    git clone https://github.com/tu-usuario/dotfiles.git ~/dotfiles
    ```
2.  Crea enlaces simbólicos (symlinks) a tu directorio home (haz backup de tus archivos actuales primero):
    ```bash
    ln -sf ~/dotfiles/.bashrc ~/.bashrc
    ln -sf ~/dotfiles/.zshrc ~/.zshrc
    ```
3.  Reinicia tu terminal o recarga la configuración:
    ```bash
    source ~/.bashrc  # O source ~/.zshrc
    ```
