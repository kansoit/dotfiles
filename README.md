# 🐚 Multi-Distro Dotfiles Repository

Repositorio centralizado de configuraciones de shell (Bash, Zsh), prompts (Starship) y utilidades CLI organizadas por distribución.

---

## 📁 Estructura del Repositorio

```text
dotfiles/
├── arch/                  # Configuraciones para Arch Linux / Omarchy (Notebook de trabajo)
│   ├── .bash_profile
│   ├── .bashrc
│   ├── .bash_logout
│   ├── .zshrc
│   └── .config/
│       ├── starship.toml
│       ├── ghostty/
│       │   └── config
│       ├── omarchy/
│       │   └── themed/
│       │       └── ghostty.conf.tpl
│       └── shell/
│           ├── aliases.sh
│           ├── env.sh
│           └── functions.sh
├── debian/                # Configuraciones para Debian 12/13, Ubuntu y Proxmox (Laboratorio)
│   ├── .bash_profile
│   ├── .bashrc
│   ├── .bash_logout
│   ├── .zshrc
│   └── .config/
│       ├── starship.toml
│       ├── ghostty/
│       │   └── config
│       └── shell/
│           ├── aliases.sh
│           ├── env.sh
│           └── functions.sh
└── rhel/                  # Configuraciones para RHEL, Rocky Linux 9 y Fedora 44
    ├── .bash_profile
    ├── .bashrc
    ├── .bash_logout
    ├── .zshrc
    └── .config/
        ├── starship.toml
        ├── ghostty/
        │   └── config
        └── shell/
            ├── aliases.sh
            ├── env.sh
            └── functions.sh
```

---

## 🚀 Componentes Destacados
- **Terminal Ghostty:** Configuración unificada con splits semitransparentes (`unfocused-split-opacity = 0.88`), cursor en bloque sólido relleno y atajos de teclado CSI-u.
- **Integración con Temas Omarchy (Arch):** Plantilla dinámica (`ghostty.conf.tpl`) sincronizada con el selector de temas, contraste optimizado de selección invertida (`selection-background = {{ accent }}`, `selection-foreground = {{ background }}`) y divisor de splits acentuado.
- **Bash & Zsh Modulares:** Ambos shells cargan de forma limpia e independiente `~/.config/shell/*.sh` para compartir alias, variables y funciones.
- **Explorador Interactivo `fp`:** Navegación ultra-rápida con `eza` + `fzf` + `bat`/`batcat`, con soporte para nombres de archivo con espacios, estado git y enlaces simbólicos.
- **Historial Interactivo `hts`:** Búsqueda difusa (`fzf`) de comandos en tiempo real.
- **Starship Prompt:** Prompt unificado, ultrarrápido y coherente en todas las distribuciones.
- **Adaptaciones por Familia de Distribución:**
  - `arch/`: Integrado con el ecosistema Omarchy de la notebook de trabajo.
  - `debian/`: Soporte nativo para nombres de binarios en Debian (`batcat`, `fdfind`), plugins en `~/.zsh/` o `/usr/share/zsh-*`, y herramientas de laboratorio (`docker`, `podman`, `microk8s`, `pre-commit`, etc.).
  - `rhel/`: Binarios estándar `bat` y `fd`, alias dedicados para `dnf`, y compatibilidad completa con Rocky 9, Oracle Linux y Fedora 44.

---

## 🛠️ Despliegue con Ansible

La distribución de estos dotfiles hacia la flota se realiza de forma automatizada e idempotente a través del repositorio de automatización:

```bash
# Sincronizar dotfiles en hosts Debian (ej: docker, pve, npm, etc.)
bin/run_playbook.sh dotfiles_sync linux_debian

# Sincronizar dotfiles en hosts RHEL / Rocky / Fedora
bin/run_playbook.sh dotfiles_sync linux_rhel
```
