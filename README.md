# Dotfiles & Configuración del Sistema (Omarchy / Arch Linux)

Repositorio de dotfiles y scripts de automatización para Omarchy / Arch Linux con Hyprland.

## Dependencias

**Todos** los paquetes preinstalados por **Omarchy**.

## Instalación

```bash
curl -LO https://raw.githubusercontent.com/FranElfers/dotfiles/master/setup.sh
chmod +x setup.sh
./setup.sh
```

El instalador detecta automáticamente el mejor entorno visual disponible en tu terminal:

1. **[gum](https://github.com/charmbracelet/gum) (Default)**
2. **`whiptail` (Fallback clásico)**
3. **Selector Bash Nativo**

### Argumentos de Línea de Comandos (Automatización)

| Opción                 | Descripción                                                                      |
| :--------------------- | :------------------------------------------------------------------------------- |
| `-i, --interactive`    | Abre el menú interactivo (comportamiento predeterminado).                        |
| `-a, --all`            | Ejecuta todos los módulos estándar en serie sin preguntar.                       |
| `--all-with-extras`    | Ejecuta todos los módulos estándar + los módulos opcionales (VM, MacBook, etc.). |
| `-o, --only <módulos>` | Ejecuta únicamente los módulos indicados, separados por comas.                   |
| `-s, --skip <módulos>` | Ejecuta la lista estándar omitiendo los módulos indicados.                       |
| `-l, --list`           | Lista todos los módulos disponibles con su tipo y descripción.                   |
| `-d, --dry-run`        | Modo simulación: imprime las acciones planificadas sin ejecutar ningún cambio.   |
| `-y, --yes`            | Omite la solicitud de confirmación previa a la ejecución.                        |
| `-h, --help`           | Muestra la ayuda y ejemplos de uso.                                              |

## Backup de Dotfiles

Para respaldar tu configuración actual del sistema de vuelta a este repositorio:

```bash
./backup_dotfiles.sh
```
