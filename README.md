# Dotfiles & Configuración del Sistema (Omarchy / Arch Linux)

Repositorio de dotfiles y scripts de automatización para Omarchy / Arch Linux con Hyprland.

El instalador [`setup.sh`](file:///home/fran/repos/franelfers/dotfiles/setup.sh) cuenta con una interfaz de línea de comandos (CLI) interactiva y modular. Permite elegir exactamente qué componentes instalar o actualizar, evitando ejecuciones monolíticas no deseadas.

---

## 🚀 Instalación Rápida

Para clonar y ejecutar el instalador interactivo:

```bash
curl -LO https://raw.githubusercontent.com/FranElfers/dotfiles/master/setup.sh
chmod +x setup.sh
./setup.sh
```

---

## 🛠️ Herramienta CLI de Instalación (`setup.sh`)

El instalador detecta automáticamente el mejor entorno visual disponible en tu terminal:

1. **[gum](https://github.com/charmbracelet/gum) (Recomendado)**: TUI moderna y elegante basada en Bubble Tea con soporte de casillas de verificación, estilos y confirmaciones. (Instalable en Arch con `pacman -S gum`).
2. **`whiptail` (Fallback clásico)**: Interfaz ncurses estándar en sistemas Linux para terminales sin soporte de herramientas modernas.
3. **Selector Bash Nativo**: Menú interactivo por texto sin dependencias externas en caso de no tener ninguna de las anteriores instaladas.

---

### Modo Interactivo (TUI)

Al ejecutar `./setup.sh` sin argumentos, se abrirá el menú interactivo:

- **Flechas Arriba / Abajo** o `j` / `k`: Navegar entre los módulos.
- **Espacio**: Marcar o desmarcar el módulo seleccionado.
- **Enter**: Confirmar la selección e iniciar el proceso.

---

### Argumentos de Línea de Comandos (Automatización)

Si prefieres no usar el menú interactivo o estás automatizando la configuración, puedes utilizar los siguientes parámetros:

| Opción | Descripción |
| :--- | :--- |
| `-i, --interactive` | Abre el menú interactivo (comportamiento predeterminado). |
| `-a, --all` | Ejecuta todos los módulos estándar en serie sin preguntar. |
| `--all-with-extras` | Ejecuta todos los módulos estándar + los módulos opcionales (VM, MacBook, etc.). |
| `-o, --only <módulos>` | Ejecuta únicamente los módulos indicados, separados por comas. |
| `-s, --skip <módulos>` | Ejecuta la lista estándar omitiendo los módulos indicados. |
| `-l, --list` | Lista todos los módulos disponibles con su tipo y descripción. |
| `-d, --dry-run` | Modo simulación: imprime las acciones planificadas sin ejecutar ningún cambio. |
| `-y, --yes` | Omite la solicitud de confirmación previa a la ejecución. |
| `-h, --help` | Muestra la ayuda y ejemplos de uso. |

---

## 📦 Lista de Módulos Disponibles

### Módulos Estándar (Seleccionados por defecto)

| Módulo | Función | Descripción |
| :--- | :--- | :--- |
| `update_omarchy` | `omarchy update -y` | Actualiza la distribución y repositorios de Omarchy. |
| `install_packages_pacman` | `omarchy pkg add ...` | Instala paquetes principales: `nano`, `yazi`, `github-cli`, `zed`, `bun`, `go`, `fuse2`, `webkit2gtk-4.1`, `uv`, `syncthing`, `flatpak`, `gimp`. |
| `install_packages_aur` | `yay -S ...` | Instala paquetes AUR: `hyprmod`, `github-desktop-bin`, `omazed` y ejecuta su setup. |
| `install_plugins` | `omarchy plugin add ...` | Instala en paralelo y habilita los plugins de Omarchy (`hyprmoncfg`, `cliamp`, `lock-explorer`, `otoru`, etc.). |
| `download_configs` | Descarga de dotfiles | Descarga y aplica dotfiles en `~/.config/`, `.bashrc`, `.bash_profile`, scripts locales y layouts. |
| `download_external_apps` | Instalación de apps | Instala `Stremio` (Flatpak), `llama.app`, `nvm`, `bun`, `pnpm`, `Antigravity CLI` y `Antra AppImage`. |
| `end` | Cierre y reinicio | Habilita el servicio `sshd` y reinicia la shell de Omarchy. |

### Módulos Opcionales / Extras (Desmarcados por defecto)

| Módulo | Descripción |
| :--- | :--- |
| `setup_vm_network` | Habilita en el firewall `ufw` la interfaz de red `virbr0` (útil si instalas Omarchy dentro de una máquina virtual). |
| `setup_github_auth` | Inicia el flujo interactivo de autenticación de GitHub CLI (`gh auth login`). |
| `download_gpt_model` | Descarga local de modelo GPT OSS GGUF (`gpt-oss-20b-MXFP4.gguf`). |
| `macbook_swap_keys` | Configura el módulo `hid_apple` para intercambiar las teclas `Fn` y `Ctrl` en teclados Apple MacBook. |
| `macbook_audio_fix` | Instala el script y drivers de audio para altavoces en MacBooks con chip de seguridad Apple T2. |

---

## 💡 Ejemplos de Uso

```bash
# 1. Abrir menú interactivo para elegir qué instalar
./setup.sh

# 2. Descargar únicamente los archivos de configuración (dotfiles)
./setup.sh --only download_configs

# 3. Actualizar sistema y dotfiles sin tocar aplicaciones ni AUR
./setup.sh --only update_omarchy,download_configs

# 4. Instalación completa desatendida (sin confirmaciones)
./setup.sh --all --yes

# 5. Ejecutar la instalación completa pero omitiendo paquetes de AUR y el reinicio de shell
./setup.sh --skip install_packages_aur,end

# 6. Simular la ejecución de módulos para verificar qué se ejecutaría sin aplicar cambios
./setup.sh --dry-run --only download_configs,install_packages_pacman

# 7. Configuración específica en una máquina virtual (incluyendo red virbr0)
./setup.sh --only setup_vm_network,download_configs,update_omarchy

# 8. Listar todos los módulos registrados
./setup.sh --list
```

---

## 💾 Respaldo de Dotfiles

Para respaldar tu configuración actual del sistema de vuelta a este repositorio:

```bash
./backup_dotfiles.sh
```
