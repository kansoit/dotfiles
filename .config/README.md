# Configuración de Usuario

En este directorio se encuentran las configuraciones para herramientas modernas de terminal.

## 👻 Ghostty
Configuración para el emulador de terminal **Ghostty**, optimizada para un aspecto limpio y moderno.

### Archivo: `ghostty/config`
- **Tema**: `Adwaita Dark` (Tema oscuro consistente y agradable).
- **Fuente**: `Inconsolata NFM` a tamaño 14.
- **Ventana**:
    - Decoración automática.
    - Padding balanceado (18px horizontal, 14px vertical).
    - Opacidad del fondo del 95% para un toque moderno.
- **Seguridad**:
    - Protección de pegado (clipboard paste protection) activada para evitar ejecución accidental de código malicioso.
    - Confirmación al cerrar desactivada para mayor fluidez.
- **Scroll**: Buffer grande (200,000 líneas).
- **Integración**: Detección automática del shell e integración SSH.

## 🚀 Starship
Configuración para el prompt cross-shell **Starship**.

### Archivo: `starship.toml`
Un prompt altamente visual y funcional configurado con el siguiente layout:
`[Usuario] [Hostname] [Directorio] [Git] [Python] [Shell] ... [Estado] [Sudo] [Duración] [Tiempo]`

#### Características Principales
- **Indicadores Visuales**:
    - **Éxito**: `√` (Verde negrita).
    - **Error**: `✗` (Rojo negrita).
    - **Sudo**: Muestra `S↑` en rojo si el usuario tiene privilegios elevados o está en una sesión sudo.
- **Git**: Muestra rama, estado (staged, modified, ahead, behind, diverged) y commits, todo en amarillo negrita.
- **Información de Contexto**:
    - **Python**: Muestra la versión activa si se está en un entorno virtual o directorio de proyecto.
    - **Duración**: Muestra cuánto tardó el último comando si excedió 1000ms.
    - **Tiempo**: Hora actual al final del prompt.
