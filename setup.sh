#!/bin/bash
# ==============================================================================
# Dotfiles Setup CLI - Instalador Modular para Omarchy / Arch Linux
# Permite seleccionar de forma interactiva qué componentes instalar o configurar,
# o utilizar argumentos de línea de comandos para automatización.
# ==============================================================================


# Determinar HOME real si se ejecuta con sudo
USER_HOME="${HOME}"
if [ -n "$SUDO_USER" ]; then
    USER_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
fi

# Limpieza de terminal al salir o cancelar
cleanup() {
    tput cnorm 2>/dev/null || true
    tput sgr0 2>/dev/null || true
}
trap cleanup EXIT
trap 'echo -e "\n\033[1;31mInstalación interrumpida por el usuario.\033[0m"; cleanup; exit 130' INT TERM

# ==============================================================================
# Definición de Módulos y Funciones
# ==============================================================================

update_omarchy() {
    omarchy update -y
}

install_packages_pacman() {
    omarchy pkg add nano yazi github-cli zed bun go fuse2 webkit2gtk-4.1 uv syncthing flatpak gimp
    omarchy pkg drop obsidian herdr lazygit libreoffice-fresh
}

install_packages_aur() {
    yay -S github-desktop-bin omazed --noconfirm
    omazed setup
}

install_plugins() {
    omarchy plugin add https://github.com/crmne/omarchy-hyprmoncfg.git --enable -y &
    omarchy plugin add https://github.com/bscott/cliamp-oma-plugin.git --enable -y &
    omarchy plugin add https://github.com/SirJul1337/omarchy-lock-explorer.git --enable -y &
    omarchy plugin add https://github.com/brianblakely/omarchy-plugins.git --enable -y &
    omarchy plugin add https://github.com/ussego/otoru.git --enable -y &
    omarchy plugin add https://github.com/TheTrueFerret/omarchy-decent-workspaces.git --enable -y &
    omarchy plugin add https://github.com/ssupt/omarchy-bluetooth-audio.git --enable -y &
    omarchy plugin add https://github.com/edgarsilva/omarchy-hw-monitor.git --enable -y &
    omarchy plugin add https://github.com/ssupt/omarchy-audio-control.git --enable -y &
    wait
}

download_configs() {
    local REPO_RAW_URL="https://raw.githubusercontent.com/FranElfers/dotfiles/master"

    echo "Descargando .gitignore..."
    curl -fSL "$REPO_RAW_URL/gitignore" -o "$USER_HOME/.gitignore"
    [ -n "$SUDO_USER" ] && chown "$SUDO_USER:" "$USER_HOME/.gitignore"

    download_config() {
        local dest="$USER_HOME/$1"
        mkdir -p "$(dirname "$dest")"
        curl -fSL "$REPO_RAW_URL/$1" -o "$dest"
        [ -n "$SUDO_USER" ] && chown "$SUDO_USER:" "$dest"
    }

    download_config .bash_profile
    download_config .bashrc
    download_config .config/btop/btop.conf
    download_config .config/cliamp/config.toml
    download_config .config/cliamp/playlists/radio-stations.toml
    download_config .config/chromium/Default/Bookmarks
    download_config .config/fastfetch/config.jsonc
    download_config .config/foot/foot.ini
    download_config .config/gtk-3.0/bookmarks
    download_config .config/htop/htoprc
    download_config .config/hypr/.luarc.json
    download_config .config/hypr/bindings.lua
    download_config .config/hypr/hyprland.lua
    download_config .config/hypr/input.lua
    download_config .config/hypr/looknfeel.lua
    download_config .config/hypr/monitors.lua
    download_config .config/omarchy/audio-preferences.json
    download_config .config/omarchy/audio-rules.json
    download_config .config/omarchy/branding/about.txt
    download_config .config/omarchy/branding/screensaver.txt
    download_config .config/omarchy/shell.json
    download_config .config/omarchy/ussego.otoru.json
    download_config .config/opencode/opencode.json
    download_config .config/starship.toml
    download_config .config/yazi/yazi.toml
    download_config .config/zed/keymap.json
    download_config .config/zed/settings.json
    download_config .gemini/antigravity-cli/settings.json
    download_config .local/bin/quickshell
    download_config .local/state/omarchy/powerprofiles/battery
    download_config .local/state/omarchy/workspace-layouts/1.lua
    download_config .nanorc
}

download_external_apps() {
    flatpak install flathub com.stremio.Stremio -y
    curl -LsSf https://llama.app/install.sh | sh &
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.7/install.sh | bash &
    curl -fsSL https://bun.sh/install | bash &
    curl -fsSL https://get.pnpm.io/install.sh | sh - &
    curl -fsSL https://antigravity.google/cli/install.sh | bash
    curl -Lo "$USER_HOME/Antra.AppImage" https://github.com/anandprtp/Antra/releases/latest/download/Antra-Linux.AppImage &
    wait
    chmod +x "$USER_HOME/Antra.AppImage"
    [ -n "$SUDO_USER" ] && chown "$SUDO_USER:" "$USER_HOME/Antra.AppImage"
}

end() {
    sudo systemctl enable sshd
    omarchy restart shell
}

# Funciones opcionales / extras
setup_vm_network() {
    sudo ufw allow in on virbr0
    sudo ufw route allow in on virbr0
}

setup_github_auth() {
    gh auth login -p https -h github.com -w
}

download_gpt_model() {
    curl -LO https://huggingface.co/ggml-org/gpt-oss-20b-GGUF/resolve/main/gpt-oss-20b-MXFP4.gguf
}

virtualization() {
    omarchy pkg add qemu-desktop virt-manager dnsmasq iptables-nft edk2-ovmf
    sudo systemctl enable --now libvirtd
    sudo usermod -aG libvirt $USER
    sudo virsh net-start default
    sudo virsh net-autostart default
}

delete_webapps() {
    # deja Discord, Google Maps y Whatsapp
    omarchy webapp remove Basecamp
    omarchy webapp remove Zoom
    omarchy webapp remove Google Contacts
    omarchy webapp remove Google Messages
    omarchy webapp remove Google Photos
    omarchy webapp remove HEY
    omarchy webapp remove Zoom
    omarchy webapp remove YouTube
    omarchy webapp remove X
}

remove_docker() {
    omarchy pkg drop docker docker-compose docker-buildx ufw-docker lazydocker
    omarchy tui remove Docker
}

macbook_fixes() {
    echo "options hid_apple swap_fn_leftctrl=1" | sudo tee /etc/modprobe.d/hid_apple.conf
    sudo mkinitcpio -P
    curl -sSL https://raw.githubusercontent.com/ngodn/linux-t2-mbp16_1-arch-audio-setup/main/install.sh | bash
}

# ==============================================================================
# Registro y Metadatos de Módulos
# ==============================================================================

# Orden de ejecución predeterminado
MODULE_ORDER=(
    "update_omarchy"
    "install_packages_pacman"
    "install_packages_aur"
    "install_plugins"
    "download_configs"
    "download_external_apps"
    "delete_webapps"
    "end"
    "setup_vm_network"
    "setup_github_auth"
    "download_gpt_model"
    "remove_docker"
    "virtualization"
    "macbook_fixes"
)

# Descripciones legibles para el menú y logs
declare -A MODULE_DESCS=(
    ["update_omarchy"]="Actualizar Omarchy y paquetes del sistema"
    ["install_packages_pacman"]="Instalar paquetes oficiales con Pacman (nano, yazi, zed, bun, etc.)"
    ["install_packages_aur"]="Instalar paquetes desde AUR con yay (hyprmod, omazed, etc.)"
    ["install_plugins"]="Instalar y habilitar plugins de Omarchy"
    ["download_configs"]="Descargar dotfiles y configuraciones (~/.config, etc.)"
    ["download_external_apps"]="Instalar aplicaciones externas (Stremio, Llama, NVM, Bun, etc.)"
    ["delete_webapps"]="Eliminar Webapps"
    ["end"]="Finalizar configuración (Habilitar SSHD y reiniciar shell)"
    ["setup_vm_network"]="[Extra] Permitir tráfico virbr0 en UFW para máquinas virtuales"
    ["setup_github_auth"]="[Extra] Iniciar sesión en GitHub CLI (gh auth login)"
    ["download_gpt_model"]="[Extra] Descargar pesos de modelo GPT OSS GGUF"
    ["remove_docker"]="[Extra] Eliminar Docker"
    ["virtualization"]="[Extra] Descargar paquetes de virtualizacion"
    ["macbook_fixes"]="[Extra] MacBook: Correcciones"
)

# Estado por defecto en el selector interactivo (1 = marcado, 0 = desmarcado)
declare -A MODULE_DEFAULTS=(
    ["update_omarchy"]=0
    ["install_packages_pacman"]=1
    ["install_packages_aur"]=1
    ["install_plugins"]=1
    ["download_configs"]=1
    ["download_external_apps"]=1
    ["delete_webapps"]=0
    ["end"]=1
    ["setup_vm_network"]=0
    ["setup_github_auth"]=0
    ["download_gpt_model"]=0
    ["remove_docker"]=0
    ["virtualization"]=0
    ["macbook_fixes"]=0
)

# ==============================================================================
# Menús Interactivos (Gum, Whiptail y Fallback Bash)
# ==============================================================================

select_with_gum() {
    local all_items=()
    local selected_items=()

    for mod in "${MODULE_ORDER[@]}"; do
        local entry="${mod}: ${MODULE_DESCS[$mod]}"
        all_items+=("$entry")
        if [[ "${MODULE_DEFAULTS[$mod]}" -eq 1 ]]; then
            selected_items+=("$entry")
        fi
    done

    local old_ifs="$IFS"
    IFS=","
    local default_csv="${selected_items[*]}"
    IFS="$old_ifs"

    gum style --border rounded --border-foreground 212 --padding "0 2" --margin "1 0" \
        --bold "Instalador de Dotfiles" \
        "Navega con las flechas, marca/desmarca con [Espacio] y pulsa [Enter] para continuar."

    local result
    result=$(gum choose --no-limit \
        --height=16 \
        --cursor="> " \
        --header="Selecciona los módulos a ejecutar:" \
        --cursor-prefix="[ ] " \
        --selected-prefix="[✓] " \
        --unselected-prefix="[ ] " \
        --selected="$default_csv" \
        "${all_items[@]}") || return 1

    if [ -z "$result" ]; then
        return 1
    fi

    echo "$result" | while read -r line; do
        local key="${line%%:*}"
        echo "$key" | xargs
    done
}

select_with_whiptail() {
    local whiptail_args=()
    for mod in "${MODULE_ORDER[@]}"; do
        local status="OFF"
        [[ "${MODULE_DEFAULTS[$mod]}" -eq 1 ]] && status="ON"
        whiptail_args+=("$mod" "${MODULE_DESCS[$mod]}" "$status")
    done

    whiptail --title "Instalador de Dotfiles" \
        --checklist "Selecciona los módulos a ejecutar ([Espacio] alternar, [Enter] confirmar):" \
        22 80 12 \
        "${whiptail_args[@]}" \
        --separate-output 3>&1 1>&2 2>&3
}

select_with_bash() {
    local -A selected_map
    for mod in "${MODULE_ORDER[@]}"; do
        selected_map["$mod"]="${MODULE_DEFAULTS[$mod]}"
    done

    while true; do
        clear 2>/dev/null || true
        echo "================================================================="
        echo "              Instalador de Dotfiles - Selección                 "
        echo "================================================================="
        echo "Selecciona los módulos que deseas ejecutar:"
        echo ""
        local idx=1
        for mod in "${MODULE_ORDER[@]}"; do
            local mark=" "
            [[ "${selected_map[$mod]}" -eq 1 ]] && mark="✓"
            printf "  %2d) [%s] %-24s : %s\n" "$idx" "$mark" "$mod" "${MODULE_DESCS[$mod]}"
            ((idx++))
        done
        echo ""
        echo "Comandos:"
        echo "  [1-${#MODULE_ORDER[@]}] Alternar selección"
        echo "  'a'      Marcar todos"
        echo "  'n'      Desmarcar todos"
        echo "  'c'      Continuar con los seleccionados"
        echo "  'q'      Salir y cancelar"
        echo "-----------------------------------------------------------------"
        read -r -p "Opción: " input
        case "$input" in
            [0-9]*)
                local num=$((input - 1))
                if (( num >= 0 && num < ${#MODULE_ORDER[@]} )); then
                    local target="${MODULE_ORDER[$num]}"
                    if [[ "${selected_map[$target]}" -eq 1 ]]; then
                        selected_map["$target"]=0
                    else
                        selected_map["$target"]=1
                    fi
                fi
                ;;
            a|A)
                for mod in "${MODULE_ORDER[@]}"; do selected_map["$mod"]=1; done
                ;;
            n|N)
                for mod in "${MODULE_ORDER[@]}"; do selected_map["$mod"]=0; done
                ;;
            c|C)
                break
                ;;
            q|Q)
                echo "Instalación cancelada."
                exit 0
                ;;
        esac
    done

    for mod in "${MODULE_ORDER[@]}"; do
        if [[ "${selected_map[$mod]}" -eq 1 ]]; then
            echo "$mod"
        fi
    done
}

confirm_action() {
    local prompt="$1"
    if command -v gum &>/dev/null; then
        gum confirm --affirmative="Ejecutar" --negative="Cancelar" "$prompt"
        return $?
    elif command -v whiptail &>/dev/null; then
        whiptail --title "Confirmación" --yesno "$prompt" 10 60
        return $?
    else
        read -r -p "$prompt [S/n]: " ans
        if [[ "$ans" =~ ^[Nn] ]]; then
            return 1
        fi
        return 0
    fi
}

# ==============================================================================
# Ayuda y Utilidades CLI
# ==============================================================================

show_help() {
    cat << EOF
Instalador Modular de Dotfiles para Omarchy / Arch Linux

USO:
    ./setup.sh [OPCIONES]

OPCIONES:
    -i, --interactive       Abre el menú interactivo de selección (por defecto)
    -a, --all               Ejecuta los módulos estándar sin confirmación
        --all-with-extras   Ejecuta todos los módulos (incluidos extras de VM y MacBook)
    -o, --only <m1,m2...>   Ejecuta únicamente los módulos especificados (separados por coma)
    -s, --skip <m1,m2...>   Ejecuta los módulos estándar omitiendo los indicados
    -l, --list              Muestra la lista de todos los módulos disponibles
    -d, --dry-run           Modo simulación: muestra las acciones sin ejecutarlas
    -y, --yes               Omite la confirmación previa a la ejecución
    -h, --help              Muestra esta pantalla de ayuda

HERRAMIENTAS CLI COMPATIBLES:
    • gum (Charmbracelet)   TUI moderna con Bubble Tea (recomendada, detectada automáticamente)
    • whiptail              Interfaz clásica ncurses basada en diálogos (fallback)
    • Fallback nativo       Menú interactivo en Bash puro sin dependencias

EJEMPLOS:
    ./setup.sh                                          # Menú interactivo TUI
    ./setup.sh --only download_configs                  # Descarga solo dotfiles
    ./setup.sh --only update_omarchy,download_configs   # Solo update y configs
    ./setup.sh --skip install_packages_aur,end          # Estándar sin AUR ni reinicio
    ./setup.sh --all --yes                              # Instalación estándar desatendida
    ./setup.sh --dry-run --only download_configs        # Simula la ejecución

EOF
}

list_modules() {
    echo "Módulos disponibles en setup.sh:"
    echo ""
    printf "  %-24s %-10s %s\n" "NOMBRE" "TIPO" "DESCRIPCIÓN"
    printf "  %-24s %-10s %s\n" "------" "----" "-----------"
    for mod in "${MODULE_ORDER[@]}"; do
        local tipo="Opcional"
        [[ "${MODULE_DEFAULTS[$mod]}" -eq 1 ]] && tipo="Estándar"
        printf "  %-24s %-10s %s\n" "$mod" "$tipo" "${MODULE_DESCS[$mod]}"
    done
    echo ""
}

# ==============================================================================
# Procesamiento de Argumentos de Línea de Comandos
# ==============================================================================

MODE="interactive"
DRY_RUN=false
ASSUME_YES=false
ONLY_LIST=""
SKIP_LIST=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            show_help
            exit 0
            ;;
        -l|--list)
            list_modules
            exit 0
            ;;
        -a|--all)
            MODE="all"
            shift
            ;;
        --all-with-extras)
            MODE="all_extras"
            shift
            ;;
        -o|--only)
            MODE="only"
            ONLY_LIST="$2"
            shift 2
            ;;
        --only=*)
            MODE="only"
            ONLY_LIST="${1#*=}"
            shift
            ;;
        -s|--skip)
            MODE="skip"
            SKIP_LIST="$2"
            shift 2
            ;;
        --skip=*)
            MODE="skip"
            SKIP_LIST="${1#*=}"
            shift
            ;;
        -d|--dry-run)
            DRY_RUN=true
            shift
            ;;
        -y|--yes)
            ASSUME_YES=true
            shift
            ;;
        -i|--interactive)
            MODE="interactive"
            shift
            ;;
        *)
            echo -e "\033[1;31mError: Opción no reconocida '$1'\033[0m" >&2
            echo "Consulta './setup.sh --help' para más detalles." >&2
            exit 1
            ;;
    esac
done

# ==============================================================================
# Resolución de Módulos a Ejecutar
# ==============================================================================

declare -A SELECTED_SET
RAW_SELECTED=()

case "$MODE" in
    all)
        for mod in "${MODULE_ORDER[@]}"; do
            [[ "${MODULE_DEFAULTS[$mod]}" -eq 1 ]] && RAW_SELECTED+=("$mod")
        done
        ;;
    all_extras)
        for mod in "${MODULE_ORDER[@]}"; do
            RAW_SELECTED+=("$mod")
        done
        ;;
    only)
        if [ -z "$ONLY_LIST" ]; then
            echo -e "\033[1;31mError: Debes especificar al menos un módulo con --only.\033[0m" >&2
            exit 1
        fi
        IFS="," read -ra REQUESTED <<< "$ONLY_LIST"
        for req in "${REQUESTED[@]}"; do
            req=$(echo "$req" | xargs)
            if [[ -z "${MODULE_DESCS[$req]}" ]]; then
                echo -e "\033[1;31mError: Módulo '$req' no reconocido.\033[0m" >&2
                echo "Ejecuta './setup.sh --list' para ver los módulos disponibles." >&2
                exit 1
            fi
            RAW_SELECTED+=("$req")
        done
        ;;
    skip)
        IFS="," read -ra TO_SKIP <<< "$SKIP_LIST"
        declare -A SKIP_MAP
        for s in "${TO_SKIP[@]}"; do
            s=$(echo "$s" | xargs)
            SKIP_MAP["$s"]=1
        done
        for mod in "${MODULE_ORDER[@]}"; do
            if [[ "${MODULE_DEFAULTS[$mod]}" -eq 1 ]] && [[ -z "${SKIP_MAP[$mod]}" ]]; then
                RAW_SELECTED+=("$mod")
            fi
        done
        ;;
    interactive)
        # Verificar si la terminal es interactiva
        if [ ! -t 0 ]; then
            echo "Advertencia: Stdin no es una terminal interactiva. Ejecutando módulos estándar..."
            for mod in "${MODULE_ORDER[@]}"; do
                [[ "${MODULE_DEFAULTS[$mod]}" -eq 1 ]] && RAW_SELECTED+=("$mod")
            done
        else
            if command -v gum &>/dev/null; then
                mapfile -t RAW_SELECTED < <(select_with_gum)
            elif command -v whiptail &>/dev/null; then
                mapfile -t RAW_SELECTED < <(select_with_whiptail)
            else
                mapfile -t RAW_SELECTED < <(select_with_bash)
            fi
        fi
        ;;
esac

# Llenar set de seleccionados
for item in "${RAW_SELECTED[@]}"; do
    [ -n "$item" ] && SELECTED_SET["$item"]=1
done

# Ordenar según la secuencia lógica definida en MODULE_ORDER
FINAL_MODULES=()
for mod in "${MODULE_ORDER[@]}"; do
    if [[ "${SELECTED_SET[$mod]}" -eq 1 ]]; then
        FINAL_MODULES+=("$mod")
    fi
done

if [ ${#FINAL_MODULES[@]} -eq 0 ]; then
    echo "No se ha seleccionado ningún módulo para ejecutar. Saliendo."
    exit 0
fi

# ==============================================================================
# Confirmación y Ejecución
# ==============================================================================

echo ""
echo -e "\033[1;36mMódulos seleccionados para ejecutar:\033[0m"
for mod in "${FINAL_MODULES[@]}"; do
    printf "  • \033[1m%-24s\033[0m : %s\n" "$mod" "${MODULE_DESCS[$mod]}"
done
echo ""

if [ "$DRY_RUN" = true ]; then
    echo -e "\033[1;33m[DRY-RUN] Modo simulación activado. No se aplicará ningún cambio.\033[0m"
    for mod in "${FINAL_MODULES[@]}"; do
        echo "  [DRY-RUN] Se ejecutaría: $mod"
    done
    exit 0
fi

if [ "$ASSUME_YES" = false ] && [ "$MODE" = "interactive" ]; then
    if ! confirm_action "¿Deseas iniciar la ejecución de los módulos seleccionados?"; then
        echo "Instalación cancelada por el usuario."
        exit 0
    fi
fi

# Ejecución secuencial de los módulos seleccionados
total=${#FINAL_MODULES[@]}
idx=1

for mod in "${FINAL_MODULES[@]}"; do
    echo ""
    if command -v gum &>/dev/null; then
        gum style \
            --foreground 212 --border-foreground 99 --border rounded \
            --align center --width 70 --margin "0 0" --bold \
            "[$idx/$total] ${MODULE_DESCS[$mod]}"
    else
        echo -e "\033[1;35m<===================[ [$idx/$total] ${MODULE_DESCS[$mod]} ]===================>\033[0m"
    fi
    echo ""

    # Llamar a la función del módulo
    "$mod"

    ((idx++))
done

# Mensaje final de éxito
echo ""
if command -v gum &>/dev/null; then
    gum style \
        --foreground 48 --border-foreground 48 --border double \
        --align center --width 70 --margin "1 0" --bold \
        "¡Instalación completada con éxito!"
else
    echo -e "\033[1;32m======================================================================\033[0m"
    echo -e "\033[1;32m                   ¡Instalación completada con éxito!                 \033[0m"
    echo -e "\033[1;32m======================================================================\033[0m"
fi
