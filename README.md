# 🐚 Multi-Distro Dotfiles Repository

Repositorio centralizado de configuraciones de shell (Bash, Zsh), prompts (Starship) y utilidades CLI organizadas por distribución.

---

## 📁 Estructura del Repositorio

```text
dotfiles/
├── arch/                  # Configuraciones para Arch Linux / Omarchy
│   ├── .bash_profile
│   ├── .bashrc
│   ├── .bash_logout
│   ├── .zshrc
│   └── .config/
│       ├── starship.toml
│       └── shell/
│           ├── aliases.sh
│           ├── env.sh
│           └── functions.sh (incluye fp, hts, md2pdf)
├── debian/                # Configuraciones para Debian / Ubuntu / Proxmox
└── rhel/                  # Configuraciones para RHEL / Rocky / Fedora
```

---

## 🚀 Componentes Destacados
- **Bash & Zsh Modulares:** Ambos shells cargan `~/.config/shell/*.sh` para compartir alias, variables y funciones.
- **Explorador Interactivo `fp`:** Navegación ultra-rápida con `eza` + `fzf` + `bat`, con soporte para archivos con espacios, git y symlinks.
- **Historial Interactivo `hts`:** Búsqueda difusa de comandos en tiempo real.
- **Starship Prompt:** Prompt moderno, rápido e informativo.
