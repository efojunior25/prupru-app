#!/usr/bin/env bash
# PruPru para Linux — diagnóstico e otimização, um arquivo só, sem instalação.
# Fase 1: infraestrutura comum + Diagnóstico + Saúde do Disco (somente leitura).
# Espelha a arquitetura do PruPru_Launcher_Standalone.ps1 (Windows): idioma
# persistente, log de execuções, relatório HTML com o mesmo CSS de marca,
# auto-elevação quando necessário. Ver /home/edson-oliveira/.claude/plans/pure-dancing-grove.md
set -u

PRUPRU_HOME="${XDG_CONFIG_HOME:-$HOME/.config}/prupru"
PRUPRU_LANG_FILE="$PRUPRU_HOME/lang.txt"
PRUPRU_LOG_FILE="$PRUPRU_HOME/PruPru_Log.txt"
mkdir -p "$PRUPRU_HOME"

# ---------------------------------------------------------------------------
# Idioma (pt/en/es), mesmo padrão persistente do Windows
# ---------------------------------------------------------------------------
detect_lang() {
  if [ -f "$PRUPRU_LANG_FILE" ]; then
    cat "$PRUPRU_LANG_FILE"
    return
  fi
  local sys_lang="${LANG:-en_US}"
  case "$sys_lang" in
    pt*) echo "pt" ;;
    es*) echo "es" ;;
    *) echo "en" ;;
  esac
}

PRUPRU_LANG="$(detect_lang)"

set_lang() {
  PRUPRU_LANG="$1"
  echo "$1" > "$PRUPRU_LANG_FILE"
}

# t <key> — retorna o texto traduzido pra PRUPRU_LANG (fallback: en)
t() {
  local key="$1"
  case "$PRUPRU_LANG" in
    pt) local -n dict="TXT_PT_$key" ;;
    es) local -n dict="TXT_ES_$key" ;;
    *)  local -n dict="TXT_EN_$key" ;;
  esac
  echo "${dict}"
}

TXT_PT_menu_title="PruPru — Diagnóstico e Otimização para Linux"
TXT_EN_menu_title="PruPru — Diagnostics and Optimization for Linux"
TXT_ES_menu_title="PruPru — Diagnóstico y Optimización para Linux"

TXT_PT_menu_diagnostico="Diagnóstico completo"
TXT_EN_menu_diagnostico="Full diagnostics"
TXT_ES_menu_diagnostico="Diagnóstico completo"

TXT_PT_menu_saude_disco="Saúde do disco (SMART)"
TXT_EN_menu_saude_disco="Disk health (SMART)"
TXT_ES_menu_saude_disco="Salud del disco (SMART)"

TXT_PT_menu_sair="Sair"
TXT_EN_menu_sair="Exit"
TXT_ES_menu_sair="Salir"

TXT_PT_report_saved="Relatório salvo em:"
TXT_EN_report_saved="Report saved to:"
TXT_ES_report_saved="Informe guardado en:"

TXT_PT_smartctl_missing="smartctl não encontrado. Instale o pacote 'smartmontools' (ex: sudo apt install smartmontools) para ver a saúde SMART dos discos. Mostrando o que der pra saber sem ele."
TXT_EN_smartctl_missing="smartctl not found. Install the 'smartmontools' package (e.g. sudo apt install smartmontools) to see disk SMART health. Showing what's available without it."
TXT_ES_smartctl_missing="smartctl no encontrado. Instale el paquete 'smartmontools' (ej: sudo apt install smartmontools) para ver la salud SMART de los discos. Mostrando lo que se puede saber sin él."

TXT_PT_menu_scanner="Scanner de segurança"
TXT_EN_menu_scanner="Security scanner"
TXT_ES_menu_scanner="Escáner de seguridad"

TXT_PT_menu_teste_integridade="Teste de integridade rápido"
TXT_EN_menu_teste_integridade="Quick integrity test"
TXT_ES_menu_teste_integridade="Prueba de integridad rápida"

TXT_PT_menu_backup_config="Backup de configurações"
TXT_EN_menu_backup_config="Configuration backup"
TXT_ES_menu_backup_config="Copia de configuración"

TXT_PT_menu_otimizador="Otimizador de sistema"
TXT_EN_menu_otimizador="System optimizer"
TXT_ES_menu_otimizador="Optimizador de sistema"

TXT_PT_menu_reverter="Reverter otimização"
TXT_EN_menu_reverter="Revert optimization"
TXT_ES_menu_reverter="Revertir optimización"

TXT_PT_menu_limpar_espaco="Limpar espaço em disco"
TXT_EN_menu_limpar_espaco="Free up disk space"
TXT_ES_menu_limpar_espaco="Liberar espacio en disco"

TXT_PT_menu_gerenciador_init="Gerenciador de inicialização"
TXT_EN_menu_gerenciador_init="Startup manager"
TXT_ES_menu_gerenciador_init="Gestor de inicio"

TXT_PT_menu_desinstalador="Desinstalador guiado"
TXT_EN_menu_desinstalador="Guided uninstaller"
TXT_ES_menu_desinstalador="Desinstalador guiado"

TXT_PT_menu_foco_jogo_on="Foco no jogo: ativar"
TXT_EN_menu_foco_jogo_on="Game focus: turn on"
TXT_ES_menu_foco_jogo_on="Enfoque de juego: activar"

TXT_PT_menu_foco_jogo_off="Foco no jogo: desativar"
TXT_EN_menu_foco_jogo_off="Game focus: turn off"
TXT_ES_menu_foco_jogo_off="Enfoque de juego: desactivar"

TXT_PT_menu_turbo_rede_on="Turbo de rede: ativar"
TXT_EN_menu_turbo_rede_on="Network turbo: turn on"
TXT_ES_menu_turbo_rede_on="Turbo de red: activar"

TXT_PT_menu_turbo_rede_off="Turbo de rede: desativar"
TXT_EN_menu_turbo_rede_off="Network turbo: turn off"
TXT_ES_menu_turbo_rede_off="Turbo de red: desactivar"

TXT_PT_menu_streaming_on="Modo streaming: ativar"
TXT_EN_menu_streaming_on="Streaming mode: turn on"
TXT_ES_menu_streaming_on="Modo streaming: activar"

TXT_PT_menu_streaming_off="Modo streaming: desativar"
TXT_EN_menu_streaming_off="Streaming mode: turn off"
TXT_ES_menu_streaming_off="Modo streaming: desactivar"

TXT_PT_menu_tweaks="Tweaks de privacidade"
TXT_EN_menu_tweaks="Privacy tweaks"
TXT_ES_menu_tweaks="Ajustes de privacidad"

TXT_PT_menu_instalador_apps="Instalador de apps"
TXT_EN_menu_instalador_apps="App installer"
TXT_ES_menu_instalador_apps="Instalador de apps"

TXT_PT_menu_verificador_drivers="Verificador de drivers"
TXT_EN_menu_verificador_drivers="Driver checker"
TXT_ES_menu_verificador_drivers="Verificador de controladores"

# ---------------------------------------------------------------------------
# Log de execuções — mesmo formato do Windows (timestamp + chave estável),
# usado depois para lembrete de manutenção no menu principal.
# ---------------------------------------------------------------------------
write_log() {
  local tool_key="$1"
  printf '%s\t%s\n' "$(date -Iseconds)" "$tool_key" >> "$PRUPRU_LOG_FILE"
}

# ---------------------------------------------------------------------------
# Relatório HTML — mesmo CSS de marca do ConvertTo-PruPruHtml (Windows).
# Convenção de entrada: linhas "-- Seção --", "[ALERTA] ..." e linhas em branco.
# ---------------------------------------------------------------------------
render_html_report() {
  local title="$1"
  shift
  local lines=("$@")
  local out
  out="$(mktemp --suffix=.html)"

  {
    cat <<'HTMLHEAD'
<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8">
<style>
  body { background:#0F172A; color:#E2E8F0; font-family:-apple-system,"Segoe UI",Arial,sans-serif; padding:32px; }
  .page { max-width:760px; margin:0 auto; }
  h1 { color:#F8FAFC; font-size:26px; margin-bottom:4px; }
  .meta { color:#94A3B8; font-size:13px; margin-bottom:24px; }
  h2 { color:#38BDF8; font-size:16px; margin:24px 0 8px; text-transform:uppercase; letter-spacing:0.04em; }
  p.line { margin:0 0 4px; font-size:14px; line-height:1.6; white-space:pre-wrap; }
  .alert { color:#F87171; font-weight:700; }
  .footer { margin-top:32px; color:#64748B; font-size:12px; border-top:1px solid #334155; padding-top:12px; }
</style>
</head>
<body>
<div class="page">
HTMLHEAD
    printf '<h1>%s</h1>\n' "$title"
    printf '<p class="meta">PruPru para Linux &middot; %s</p>\n' "$(date '+%d/%m/%Y %H:%M')"

    for line in "${lines[@]}"; do
      if [[ "$line" == --\ *\ -- ]]; then
        printf '<h2>%s</h2>\n' "${line//--/}"
      elif [[ "$line" == \[ALERTA\]* || "$line" == \[ALERT\]* ]]; then
        printf '<p class="line alert">%s</p>\n' "$line"
      elif [[ -z "$line" ]]; then
        printf '<br>\n'
      else
        printf '<p class="line">%s</p>\n' "$line"
      fi
    done

    cat <<'HTMLFOOT'
<div class="footer">PruPru Digital Services &middot; prupru.org</div>
</div>
</body>
</html>
HTMLFOOT
  } > "$out"

  echo "$out"
}

# Descobre a Desktop do usuário "de verdade" mesmo quando rodando elevado.
# sudo/pkexec trocam $HOME pro do root, o que faria o relatório ir parar
# em /root/Desktop e o usuário nunca veria — resolvemos via SUDO_USER
# (sudo) ou PKEXEC_UID (pkexec) antes de cair de volta em $HOME.
real_user_home() {
  local target_user=""
  if [ -n "${SUDO_USER:-}" ]; then
    target_user="$SUDO_USER"
  elif [ -n "${PKEXEC_UID:-}" ]; then
    target_user="$(getent passwd "$PKEXEC_UID" 2>/dev/null | cut -d: -f1)"
  fi
  if [ -n "$target_user" ]; then
    getent passwd "$target_user" 2>/dev/null | cut -d: -f6
  else
    echo "$HOME"
  fi
}

open_report() {
  local path="$1"
  local home_dir
  home_dir="$(real_user_home)"
  local dest="$home_dir/Desktop/$(basename "$path" .html)-$(date +%Y%m%d-%H%M%S).html"
  mkdir -p "$home_dir/Desktop" 2>/dev/null
  cp "$path" "$dest" 2>/dev/null || dest="$path"
  if [ -n "${SUDO_USER:-}" ]; then
    chown "$SUDO_USER":"$SUDO_USER" "$dest" 2>/dev/null
  fi
  echo "$(t report_saved) $dest"
  ( xdg-open "$dest" >/dev/null 2>&1 & ) || true
}

# ---------------------------------------------------------------------------
# Auto-elevação — pronta pra fases futuras (Otimizador, Turbo de Rede etc.)
# que precisam de root. As ferramentas da Fase 1 são todas somente-leitura
# e não chamam isto.
# ---------------------------------------------------------------------------
# require_root <nome-da-função-da-ferramenta>
# Se já formos root, apenas retorna. Caso contrário, relança o script
# inteiro pedindo elevação e instruindo-o a rodar só essa ferramenta
# diretamente (--run-tool), sem passar pelo menu interativo de novo.
require_root() {
  local tool_fn="$1"
  if [ "$(id -u)" -eq 0 ]; then
    return 0
  fi
  if command -v pkexec >/dev/null 2>&1; then
    exec pkexec "$0" --run-tool "$tool_fn"
  elif command -v sudo >/dev/null 2>&1; then
    exec sudo "$0" --run-tool "$tool_fn"
  else
    echo "Este recurso precisa de privilégios de administrador (pkexec/sudo não encontrados)." >&2
    exit 1
  fi
}

# ---------------------------------------------------------------------------
# Ferramenta: Diagnóstico completo
# ---------------------------------------------------------------------------
tool_diagnostico() {
  local lines=()
  lines+=("-- Sistema --")
  lines+=("SO: $(source /etc/os-release 2>/dev/null; echo "${PRETTY_NAME:-desconhecido}")")
  lines+=("Kernel: $(uname -r)")
  lines+=("Uptime: $(uptime -p 2>/dev/null || uptime)")
  lines+=("")

  lines+=("-- CPU e memória --")
  if command -v lscpu >/dev/null 2>&1; then
    lines+=("CPU: $(lscpu | awk -F: '/Model name/{gsub(/^ +/,"",$2); print $2; exit}')")
  fi
  if command -v free >/dev/null 2>&1; then
    local mem_line
    mem_line="$(free -h | awk '/^Mem:/{print "Usada " $3 " de " $2 " (" $3/$2*100 "%)"}' 2>/dev/null)"
    read -r mem_total mem_used mem_pct < <(free -m | awk '/^Mem:/{printf "%s %s %.0f", $2, $3, ($3/$2)*100}')
    lines+=("Memória: ${mem_used}MB usados de ${mem_total}MB (${mem_pct}%)")
    if [ "${mem_pct:-0}" -ge 90 ]; then
      lines+=("[ALERTA] Uso de memória acima de 90% — considere fechar aplicativos ou aumentar RAM/swap.")
    fi
  fi
  lines+=("")

  lines+=("-- Disco --")
  while IFS= read -r disk_line; do
    lines+=("$disk_line")
  done < <(df -h --output=target,size,used,avail,pcent -x tmpfs -x devtmpfs -x squashfs 2>/dev/null | tail -n +2)
  local root_pct
  root_pct="$(df --output=pcent / 2>/dev/null | tail -1 | tr -dc '0-9')"
  if [ -n "${root_pct:-}" ] && [ "$root_pct" -ge 90 ]; then
    lines+=("[ALERTA] Partição raiz (/) com ${root_pct}% de uso — espaço em disco crítico.")
  fi
  lines+=("")

  lines+=("-- Itens de inicialização --")
  local autostart_dir="$HOME/.config/autostart"
  if [ -d "$autostart_dir" ]; then
    local count
    count="$(find "$autostart_dir" -name '*.desktop' 2>/dev/null | wc -l)"
    lines+=("$count item(ns) de inicialização automática em $autostart_dir")
    while IFS= read -r f; do
      lines+=("  - $(basename "$f" .desktop)")
    done < <(find "$autostart_dir" -name '*.desktop' 2>/dev/null)
  else
    lines+=("Nenhuma pasta de autostart encontrada para este usuário.")
  fi
  lines+=("")

  lines+=("-- Atualizações pendentes --")
  if command -v apt >/dev/null 2>&1; then
    local upd
    upd="$(apt list --upgradable 2>/dev/null | grep -c upgradable)"
    lines+=("APT: $upd pacote(s) com atualização disponível.")
  elif command -v dnf >/dev/null 2>&1; then
    local upd
    upd="$(dnf check-update 2>/dev/null | grep -c '^[a-zA-Z0-9]')"
    lines+=("DNF: $upd pacote(s) com atualização disponível.")
  else
    lines+=("Gerenciador de pacotes não reconhecido (suporte a apt/dnf por enquanto).")
  fi
  lines+=("")

  lines+=("-- Eventos críticos recentes (7 dias) --")
  if command -v journalctl >/dev/null 2>&1; then
    local crit_count
    crit_count="$(journalctl -p err --since '-7 days' --no-pager 2>/dev/null | wc -l)"
    lines+=("$crit_count linha(s) de erro no journal nos últimos 7 dias.")
    if [ "$crit_count" -gt 0 ]; then
      lines+=("[ALERTA] Há erros recentes no journal — rode 'journalctl -p err --since \"-7 days\"' para detalhes.")
    fi
  else
    lines+=("journalctl não disponível neste sistema.")
  fi

  local html
  html="$(render_html_report "PruPru — Diagnóstico Completo" "${lines[@]}")"
  write_log "diagnostico"
  open_report "$html"
}

# ---------------------------------------------------------------------------
# Ferramenta: Saúde do disco (SMART)
# ---------------------------------------------------------------------------
tool_saude_disco() {
  local lines=()
  lines+=("-- Discos detectados --")

  local disks
  disks="$(lsblk -dno NAME,SIZE,TYPE 2>/dev/null | awk '$3=="disk"{print $1, $2}')"

  if [ -z "$disks" ]; then
    lines+=("Nenhum disco físico detectado via lsblk.")
  fi

  local has_smartctl=1
  if ! command -v smartctl >/dev/null 2>&1; then
    has_smartctl=0
    lines+=("[ALERTA] $(t smartctl_missing)")
    lines+=("")
  fi

  while IFS=' ' read -r name size; do
    [ -z "$name" ] && continue
    lines+=("Disco /dev/$name — $size")
    if [ "$has_smartctl" -eq 1 ]; then
      local health
      health="$(smartctl -H "/dev/$name" 2>/dev/null | grep -i 'overall-health\|test result' | head -1)"
      if [ -n "$health" ]; then
        lines+=("  SMART: $health")
        if echo "$health" | grep -qi 'FAILED\|FAIL'; then
          lines+=("[ALERTA] Disco /dev/$name reporta falha SMART iminente — faça backup imediatamente.")
        fi
      else
        lines+=("  SMART: não foi possível ler (pode exigir sudo, ou disco USB sem suporte SMART).")
      fi
    fi
    lines+=("")
  done <<< "$disks"

  local html
  html="$(render_html_report "PruPru — Saúde do Disco" "${lines[@]}")"
  write_log "saude_disco"
  open_report "$html"
}

# ---------------------------------------------------------------------------
# Ferramenta: Scanner de segurança (somente leitura)
# ---------------------------------------------------------------------------
tool_scanner_seguranca() {
  local lines=()
  local -a miners=(xmrig minerd cpuminer ccminer cgminer minergate nheqminer)

  lines+=("-- Processos suspeitos --")
  local found=0
  for m in "${miners[@]}"; do
    if pgrep -fi "$m" >/dev/null 2>&1; then
      lines+=("[ALERTA] Processo compatível com minerador de criptomoeda em execução: $m")
      found=1
    fi
  done
  [ "$found" -eq 0 ] && lines+=("Nenhum processo de mineração conhecido encontrado.")
  lines+=("")

  lines+=("-- Tarefas agendadas (crontab do usuário) --")
  local cron_out
  cron_out="$(crontab -l 2>/dev/null)"
  if [ -n "$cron_out" ]; then
    while IFS= read -r l; do lines+=("  $l"); done <<< "$cron_out"
  else
    lines+=("Nenhuma tarefa agendada para este usuário.")
  fi
  lines+=("")

  lines+=("-- Timers do systemd (usuário) --")
  if command -v systemctl >/dev/null 2>&1; then
    while IFS= read -r l; do lines+=("  $l"); done < <(systemctl --user list-timers --no-pager 2>/dev/null | head -20)
  else
    lines+=("systemd não disponível.")
  fi
  lines+=("")

  lines+=("-- Itens de inicialização automática --")
  local autostart_dir="$HOME/.config/autostart"
  if [ -d "$autostart_dir" ]; then
    while IFS= read -r f; do
      lines+=("  - $(basename "$f" .desktop)")
    done < <(find "$autostart_dir" -name '*.desktop' 2>/dev/null)
    lines+=("Revise os itens acima que você não reconhece.")
  else
    lines+=("Nenhuma pasta de autostart encontrada.")
  fi

  local html
  html="$(render_html_report "PruPru — Scanner de Segurança" "${lines[@]}")"
  write_log "scanner_seguranca"
  open_report "$html"
}

# ---------------------------------------------------------------------------
# Ferramenta: Teste de integridade rápido (reaproveita critérios do
# Diagnóstico/Saúde do Disco, mostrado num popup rápido)
# ---------------------------------------------------------------------------
tool_teste_integridade() {
  local msgs=()
  local mem_total mem_used mem_pct
  read -r mem_total mem_used mem_pct < <(free -m | awk '/^Mem:/{printf "%s %s %.0f", $2, $3, ($3/$2)*100}')
  if [ "${mem_pct:-0}" -ge 90 ]; then
    msgs+=("[ALERTA] Memória em ${mem_pct}% de uso.")
  fi

  local root_pct
  root_pct="$(df --output=pcent / 2>/dev/null | tail -1 | tr -dc '0-9')"
  if [ -n "${root_pct:-}" ] && [ "$root_pct" -ge 90 ]; then
    msgs+=("[ALERTA] Disco raiz (/) em ${root_pct}% de uso.")
  fi

  if command -v smartctl >/dev/null 2>&1; then
    while IFS=' ' read -r name _; do
      [ -z "$name" ] && continue
      # Filtra primeiro pra linha real de resultado do SMART — sem isso,
      # um erro de permissão ("... open device ... failed: Permission
      # denied") também contém a palavra FAILED e gera falso positivo.
      local health
      health="$(smartctl -H "/dev/$name" 2>/dev/null | grep -i 'overall-health\|test result')"
      if echo "$health" | grep -qi 'FAILED'; then
        msgs+=("[ALERTA] Disco /dev/$name reporta falha SMART.")
      fi
    done < <(lsblk -dno NAME,TYPE 2>/dev/null | awk '$2=="disk"{print $1}')
  fi

  local summary
  if [ "${#msgs[@]}" -eq 0 ]; then
    summary="Tudo certo: memória, disco e SMART dentro do esperado."
  else
    summary="$(printf '%s\n' "${msgs[@]}")"
  fi

  write_log "teste_integridade"
  if command -v zenity >/dev/null 2>&1; then
    if [ "${#msgs[@]}" -eq 0 ]; then
      zenity --info --title="PruPru — Teste de Integridade" --text="$summary" 2>/dev/null
    else
      zenity --warning --title="PruPru — Teste de Integridade" --text="$summary" 2>/dev/null
    fi
  else
    echo "== PruPru — Teste de Integridade =="
    echo "$summary"
  fi
}

# ---------------------------------------------------------------------------
# Ferramenta: Backup de configurações (somente leitura — "foto" do estado atual)
# ---------------------------------------------------------------------------
tool_backup_config() {
  local lines=()

  lines+=("-- DNS por interface --")
  if command -v resolvectl >/dev/null 2>&1; then
    while IFS= read -r l; do lines+=("  $l"); done < <(resolvectl status 2>/dev/null | grep -A2 'Link\|DNS Servers' | head -40)
  elif command -v nmcli >/dev/null 2>&1; then
    while IFS= read -r l; do lines+=("  $l"); done < <(nmcli dev show 2>/dev/null | grep 'IP4.DNS')
  else
    lines+=("$(cat /etc/resolv.conf 2>/dev/null | grep nameserver)")
  fi
  lines+=("")

  lines+=("-- Perfil de energia --")
  if command -v powerprofilesctl >/dev/null 2>&1; then
    lines+=("Perfil atual: $(powerprofilesctl get 2>/dev/null)")
  else
    lines+=("powerprofilesctl não disponível (comum em desktops sem power-profiles-daemon).")
  fi
  lines+=("")

  lines+=("-- Serviços relevantes --")
  for svc in NetworkManager systemd-oomd tracker-miner-fs-3 bluetooth; do
    if command -v systemctl >/dev/null 2>&1; then
      local state
      state="$(systemctl is-active "$svc" 2>/dev/null || systemctl --user is-active "$svc" 2>/dev/null)"
      lines+=("$svc: ${state:-não encontrado}")
    fi
  done
  lines+=("")

  lines+=("-- Configuração de rede (TCP) --")
  lines+=("Congestion control: $(sysctl -n net.ipv4.tcp_congestion_control 2>/dev/null)")
  lines+=("rmem_max: $(sysctl -n net.core.rmem_max 2>/dev/null)")
  lines+=("wmem_max: $(sysctl -n net.core.wmem_max 2>/dev/null)")

  local html
  html="$(render_html_report "PruPru — Backup de Configurações" "${lines[@]}")"
  write_log "backup_config"
  open_report "$html"
}

# ---------------------------------------------------------------------------
# Ferramenta: Otimizador de sistema (+ Reverter) — precisa de root
# ---------------------------------------------------------------------------
PRUPRU_OTIMIZADOR_STATE="$PRUPRU_HOME/otimizador_state.txt"

tool_otimizador() {
  require_root "tool_otimizador"
  local lines=()
  : > "$PRUPRU_OTIMIZADOR_STATE"

  lines+=("-- Limpeza --")
  if command -v apt-get >/dev/null 2>&1; then
    apt-get clean -y >/dev/null 2>&1
    lines+=("Cache do APT limpo (apt-get clean).")
  elif command -v dnf >/dev/null 2>&1; then
    dnf clean all >/dev/null 2>&1
    lines+=("Cache do DNF limpo (dnf clean all).")
  fi

  if command -v fstrim >/dev/null 2>&1; then
    fstrim -av >/dev/null 2>&1
    lines+=("TRIM executado em todas as partições SSD suportadas (fstrim -av).")
  fi
  lines+=("")

  lines+=("-- Serviço de indexação de arquivos --")
  if systemctl --user list-unit-files 2>/dev/null | grep -q tracker-miner-fs-3; then
    if systemctl --user is-active tracker-miner-fs-3 >/dev/null 2>&1; then
      systemctl --user stop tracker-miner-fs-3 2>/dev/null
      echo "tracker-miner-fs-3" >> "$PRUPRU_OTIMIZADOR_STATE"
      lines+=("Indexador de arquivos (tracker) pausado — ajuda em discos mais lentos.")
    else
      lines+=("Indexador de arquivos já estava parado.")
    fi
  else
    lines+=("Indexador de arquivos (tracker) não encontrado neste sistema.")
  fi

  local html
  html="$(render_html_report "PruPru — Otimização Concluída" "${lines[@]}")"
  write_log "otimizador"
  open_report "$html"
}

tool_reverter() {
  require_root "tool_reverter"
  local lines=()
  lines+=("-- Revertendo alterações do Otimizador --")

  if [ -s "$PRUPRU_OTIMIZADOR_STATE" ]; then
    while IFS= read -r svc; do
      [ -z "$svc" ] && continue
      systemctl --user start "$svc" 2>/dev/null
      lines+=("Serviço $svc reativado.")
    done < "$PRUPRU_OTIMIZADOR_STATE"
    : > "$PRUPRU_OTIMIZADOR_STATE"
  else
    lines+=("Nada para reverter — o Otimizador ainda não rodou, ou já foi revertido.")
  fi

  local html
  html="$(render_html_report "PruPru — Reversão Concluída" "${lines[@]}")"
  write_log "reverter"
  open_report "$html"
}

# ---------------------------------------------------------------------------
# Ferramenta: Limpar espaço em disco — precisa de root pra cache de pacotes
# ---------------------------------------------------------------------------
tool_limpar_espaco() {
  require_root "tool_limpar_espaco"
  local lines=()
  local before after freed_mb
  before="$(df --output=avail -m / 2>/dev/null | tail -1 | tr -d ' ')"

  lines+=("-- O que foi limpo --")

  if [ -n "${SUDO_USER:-}" ]; then
    local user_home
    user_home="$(getent passwd "$SUDO_USER" | cut -d: -f6)"
    rm -rf "${user_home:?}/.cache/thumbnails"/* 2>/dev/null
    lines+=("Cache de miniaturas do usuário $SUDO_USER limpo.")
    if command -v trash-empty >/dev/null 2>&1; then
      sudo -u "$SUDO_USER" trash-empty -f 2>/dev/null
      lines+=("Lixeira esvaziada (trash-cli).")
    else
      rm -rf "${user_home:?}/.local/share/Trash/files"/* "${user_home:?}/.local/share/Trash/info"/* 2>/dev/null
      lines+=("Lixeira esvaziada (remoção direta).")
    fi
  fi

  if command -v apt-get >/dev/null 2>&1; then
    apt-get autoremove -y >/dev/null 2>&1
    lines+=("Pacotes órfãos removidos (apt-get autoremove).")
  elif command -v dnf >/dev/null 2>&1; then
    dnf autoremove -y >/dev/null 2>&1
    lines+=("Pacotes órfãos removidos (dnf autoremove).")
  fi

  if command -v journalctl >/dev/null 2>&1; then
    journalctl --vacuum-size=200M >/dev/null 2>&1
    lines+=("Log do systemd reduzido pra no máximo 200MB.")
  fi

  after="$(df --output=avail -m / 2>/dev/null | tail -1 | tr -d ' ')"
  freed_mb=$(( after - before ))
  [ "$freed_mb" -lt 0 ] && freed_mb=0
  lines+=("")
  lines+=("Espaço livre aproximadamente ${freed_mb}MB maior que antes (partição raiz).")

  local html
  html="$(render_html_report "PruPru — Limpeza de Disco" "${lines[@]}")"
  write_log "limpar_espaco"
  open_report "$html"
}

# ---------------------------------------------------------------------------
# Ferramenta: Gerenciador de inicialização — ativa/desativa itens de
# autostart do usuário, com "cofre" de itens desativados (sem root)
# ---------------------------------------------------------------------------
PRUPRU_STARTUP_VAULT="$PRUPRU_HOME/disabled-startup"

tool_gerenciador_inicializacao() {
  mkdir -p "$PRUPRU_STARTUP_VAULT" "$HOME/.config/autostart"

  local -a active=()
  local -a disabled=()
  while IFS= read -r f; do active+=("$(basename "$f")"); done \
    < <(find "$HOME/.config/autostart" -name '*.desktop' 2>/dev/null)
  while IFS= read -r f; do disabled+=("$(basename "$f")"); done \
    < <(find "$PRUPRU_STARTUP_VAULT" -name '*.desktop' 2>/dev/null)

  echo "== Gerenciador de Inicialização =="
  echo "-- Ativos --"
  local i=1
  local -a idx_map=()
  for f in "${active[@]}"; do
    echo "  $i) [ATIVO]    $f"
    idx_map+=("active:$f")
    i=$((i+1))
  done
  for f in "${disabled[@]}"; do
    echo "  $i) [DESATIVADO] $f"
    idx_map+=("disabled:$f")
    i=$((i+1))
  done

  if [ "${#idx_map[@]}" -eq 0 ]; then
    echo "Nenhum item de inicialização encontrado."
    write_log "gerenciador_inicializacao"
    return
  fi

  read -rp "Número do item pra alternar (Enter pra sair): " sel
  [ -z "$sel" ] && { write_log "gerenciador_inicializacao"; return; }

  local entry="${idx_map[$((sel-1))]:-}"
  if [ -z "$entry" ]; then
    echo "Opção inválida."
  else
    local state="${entry%%:*}"
    local fname="${entry#*:}"
    if [ "$state" = "active" ]; then
      mv "$HOME/.config/autostart/$fname" "$PRUPRU_STARTUP_VAULT/$fname"
      echo "$fname desativado (movido pro cofre)."
    else
      mv "$PRUPRU_STARTUP_VAULT/$fname" "$HOME/.config/autostart/$fname"
      echo "$fname reativado."
    fi
  fi
  write_log "gerenciador_inicializacao"
}

# ---------------------------------------------------------------------------
# Ferramenta: Desinstalador guiado — lista pacotes instalados por gerenciador
# disponível e aciona a remoção oficial (root necessário pra remover)
# ---------------------------------------------------------------------------
tool_desinstalador_guiado() {
  echo "== Desinstalador Guiado =="
  local -a names=()
  local -a cmds=()

  if command -v dpkg-query >/dev/null 2>&1; then
    while IFS=$'\t' read -r name size; do
      names+=("$name (${size}KB)")
      cmds+=("apt-get remove -y $name")
    done < <(dpkg-query -Wf '${Package}\t${Installed-Size}\n' 2>/dev/null | sort -k2 -n -r | head -30)
  elif command -v rpm >/dev/null 2>&1; then
    while IFS= read -r name; do
      names+=("$name")
      cmds+=("dnf remove -y $name")
    done < <(rpm -qa --qf '%{NAME}\n' 2>/dev/null | sort | head -30)
  fi

  if command -v flatpak >/dev/null 2>&1; then
    while IFS= read -r name; do
      names+=("$name (flatpak)")
      cmds+=("flatpak uninstall -y $name")
    done < <(flatpak list --app --columns=application 2>/dev/null)
  fi

  if [ "${#names[@]}" -eq 0 ]; then
    echo "Nenhum gerenciador de pacotes suportado encontrado (apt/dnf/flatpak)."
    write_log "desinstalador_guiado"
    return
  fi

  local i=1
  for n in "${names[@]}"; do
    echo "  $i) $n"
    i=$((i+1))
  done

  read -rp "Número do programa a desinstalar (Enter pra cancelar): " sel
  if [ -n "$sel" ] && [ -n "${cmds[$((sel-1))]:-}" ]; then
    require_root "tool_desinstalador_guiado"
    echo "Executando: ${cmds[$((sel-1))]}"
    eval "${cmds[$((sel-1))]}"
  fi
  write_log "desinstalador_guiado"
}

# ---------------------------------------------------------------------------
# Ferramenta: Foco no Jogo ON/OFF — precisa de root pro firewall
# Diferença consciente do Windows: em vez de bloquear 100% o acesso à
# internet do navegador (não há como mirar por processo de forma
# confiável e portável entre distros), reduzimos a prioridade dos
# navegadores conhecidos e priorizamos o processo do jogo/Steam.
# ---------------------------------------------------------------------------
tool_foco_jogo_on() {
  require_root "tool_foco_jogo_on"
  local lines=()

  for p in steam lutris heroic; do
    if pgrep -x "$p" >/dev/null 2>&1; then
      renice -n -5 -p "$(pgrep -x "$p" | head -1)" >/dev/null 2>&1
      lines+=("Prioridade de $p elevada.")
    fi
  done

  for b in chrome firefox chromium brave; do
    if pgrep -x "$b" >/dev/null 2>&1; then
      renice -n 10 -p $(pgrep -x "$b") >/dev/null 2>&1
      lines+=("Prioridade de $b reduzida (mais CPU sobra pro jogo).")
    fi
  done

  echo "on" > "$PRUPRU_HOME/foco_jogo_state.txt"
  local html
  html="$(render_html_report "PruPru — Foco no Jogo Ativado" "${lines[@]}")"
  write_log "foco_jogo_on"
  open_report "$html"
}

tool_foco_jogo_off() {
  require_root "tool_foco_jogo_off"
  local lines=()
  for b in chrome firefox chromium brave steam lutris heroic; do
    if pgrep -x "$b" >/dev/null 2>&1; then
      renice -n 0 -p $(pgrep -x "$b") >/dev/null 2>&1
    fi
  done
  lines+=("Prioridades de processos restauradas ao normal.")
  rm -f "$PRUPRU_HOME/foco_jogo_state.txt"
  local html
  html="$(render_html_report "PruPru — Foco no Jogo Desativado" "${lines[@]}")"
  write_log "foco_jogo_off"
  open_report "$html"
}

# ---------------------------------------------------------------------------
# Ferramenta: Turbo de Rede ON/OFF — precisa de root
# ---------------------------------------------------------------------------
tool_turbo_rede_on() {
  require_root "tool_turbo_rede_on"
  local lines=()

  local iface
  iface="$(ip route show default 2>/dev/null | awk '{print $5; exit}')"
  if [ -n "$iface" ] && command -v resolvectl >/dev/null 2>&1; then
    resolvectl dns "$iface" 1.1.1.1 1.0.0.1 >/dev/null 2>&1
    lines+=("DNS da interface $iface definido pra 1.1.1.1 / 1.0.0.1 (Cloudflare).")
  fi

  if sysctl net.ipv4.tcp_available_congestion_control 2>/dev/null | grep -qi bbr; then
    sysctl -w net.ipv4.tcp_congestion_control=bbr >/dev/null 2>&1
    lines+=("Controle de congestionamento TCP definido pra BBR.")
  fi
  sysctl -w net.core.rmem_max=16777216 >/dev/null 2>&1
  sysctl -w net.core.wmem_max=16777216 >/dev/null 2>&1
  lines+=("Buffers de rede (rmem_max/wmem_max) aumentados pra 16MB.")

  local html
  html="$(render_html_report "PruPru — Turbo de Rede Ativado" "${lines[@]}")"
  write_log "turbo_rede_on"
  open_report "$html"
}

tool_turbo_rede_off() {
  require_root "tool_turbo_rede_off"
  local lines=()

  local iface
  iface="$(ip route show default 2>/dev/null | awk '{print $5; exit}')"
  if [ -n "$iface" ] && command -v resolvectl >/dev/null 2>&1; then
    resolvectl revert "$iface" >/dev/null 2>&1
    lines+=("DNS da interface $iface revertido pro padrão do DHCP.")
  fi

  sysctl -w net.ipv4.tcp_congestion_control=cubic >/dev/null 2>&1
  sysctl -w net.core.rmem_max=212992 >/dev/null 2>&1
  sysctl -w net.core.wmem_max=212992 >/dev/null 2>&1
  lines+=("Configurações de TCP restauradas aos valores padrão do kernel.")

  local html
  html="$(render_html_report "PruPru — Turbo de Rede Desativado" "${lines[@]}")"
  write_log "turbo_rede_off"
  open_report "$html"
}

# ---------------------------------------------------------------------------
# Ferramenta: Modo Streaming ON/OFF
# Diferença consciente do Windows: não existe "Game Bar" no Linux;
# alternamos "Não Perturbe" (GNOME) e priorizamos OBS/Streamlabs.
# ---------------------------------------------------------------------------
tool_modo_streaming_on() {
  local lines=()
  for p in obs obs-studio streamlabs-desktop; do
    if pgrep -x "$p" >/dev/null 2>&1; then
      renice -n -5 -p "$(pgrep -x "$p" | head -1)" >/dev/null 2>&1
      lines+=("Prioridade de $p elevada.")
    fi
  done
  if command -v gsettings >/dev/null 2>&1; then
    gsettings set org.gnome.desktop.notifications show-banners false 2>/dev/null
    lines+=("Notificações do GNOME silenciadas (se o ambiente for GNOME).")
  fi
  local html
  html="$(render_html_report "PruPru — Modo Streaming Ativado" "${lines[@]}")"
  write_log "modo_streaming_on"
  open_report "$html"
}

tool_modo_streaming_off() {
  local lines=()
  for p in obs obs-studio streamlabs-desktop; do
    if pgrep -x "$p" >/dev/null 2>&1; then
      renice -n 0 -p "$(pgrep -x "$p" | head -1)" >/dev/null 2>&1
    fi
  done
  if command -v gsettings >/dev/null 2>&1; then
    gsettings set org.gnome.desktop.notifications show-banners true 2>/dev/null
  fi
  lines+=("Prioridades e notificações restauradas ao normal.")
  local html
  html="$(render_html_report "PruPru — Modo Streaming Desativado" "${lines[@]}")"
  write_log "modo_streaming_off"
  open_report "$html"
}

# ---------------------------------------------------------------------------
# Ferramenta: Tweaks de privacidade — Get/On/Off por item, como no Windows
# ---------------------------------------------------------------------------
tool_tweaks_privacidade() {
  echo "== Tweaks de Privacidade =="
  local lines=()

  if command -v systemctl >/dev/null 2>&1 && systemctl list-unit-files 2>/dev/null | grep -q '^apport'; then
    local state
    state="$(systemctl is-enabled apport 2>/dev/null)"
    echo "1) Relatório de erros (apport): $state"
  fi
  if command -v gsettings >/dev/null 2>&1; then
    echo "2) Sugestões de busca online (GNOME): $(gsettings get org.gnome.desktop.privacy 2>/dev/null || echo n/d)"
    echo "3) Serviço de localização: $(gsettings get org.gnome.system.location enabled 2>/dev/null || echo n/d)"
  fi

  read -rp "Número do item pra alternar (Enter pra sair): " sel
  case "$sel" in
    1)
      require_root "tool_tweaks_privacidade"
      if systemctl is-enabled apport >/dev/null 2>&1; then
        systemctl disable --now apport 2>/dev/null
        lines+=("Apport (relatório de erros) desativado.")
      else
        systemctl enable --now apport 2>/dev/null
        lines+=("Apport (relatório de erros) reativado.")
      fi
      ;;
    2)
      local cur
      cur="$(gsettings get org.gnome.desktop.privacy report-technical-problems 2>/dev/null)"
      if [ "$cur" = "true" ]; then
        gsettings set org.gnome.desktop.privacy report-technical-problems false 2>/dev/null
        lines+=("Relatório de problemas técnicos desativado.")
      else
        gsettings set org.gnome.desktop.privacy report-technical-problems true 2>/dev/null
        lines+=("Relatório de problemas técnicos reativado.")
      fi
      ;;
    3)
      local cur
      cur="$(gsettings get org.gnome.system.location enabled 2>/dev/null)"
      if [ "$cur" = "true" ]; then
        gsettings set org.gnome.system.location enabled false 2>/dev/null
        lines+=("Serviço de localização desativado.")
      else
        gsettings set org.gnome.system.location enabled true 2>/dev/null
        lines+=("Serviço de localização reativado.")
      fi
      ;;
    *) lines+=("Nenhuma alteração feita.") ;;
  esac

  write_log "tweaks_privacidade"
  printf '%s\n' "${lines[@]}"
}

# ---------------------------------------------------------------------------
# Ferramenta: Instalador de apps — equivalente ao winget (apt/dnf/flatpak)
# ---------------------------------------------------------------------------
tool_instalador_apps() {
  echo "== Instalador de Apps =="
  local -a catalog=(
    "Firefox:firefox:org.mozilla.firefox"
    "Chromium:chromium:org.chromium.Chromium"
    "VLC:vlc:org.videolan.VLC"
    "GIMP:gimp:org.gimp.GIMP"
    "LibreOffice:libreoffice:org.libreoffice.LibreOffice"
    "VS Code:code:com.visualstudio.code"
    "Telegram:telegram-desktop:org.telegram.desktop"
  )

  local i=1
  for entry in "${catalog[@]}"; do
    echo "  $i) ${entry%%:*}"
    i=$((i+1))
  done

  read -rp "Números separados por espaço pra instalar (Enter pra cancelar): " -a sels
  [ "${#sels[@]}" -eq 0 ] && { write_log "instalador_apps"; return; }

  require_root "tool_instalador_apps"
  for sel in "${sels[@]}"; do
    local entry="${catalog[$((sel-1))]:-}"
    [ -z "$entry" ] && continue
    local apt_name flatpak_id
    apt_name="$(echo "$entry" | cut -d: -f2)"
    flatpak_id="$(echo "$entry" | cut -d: -f3)"
    if command -v apt-get >/dev/null 2>&1; then
      apt-get install -y "$apt_name" 2>&1
    elif command -v dnf >/dev/null 2>&1; then
      dnf install -y "$apt_name" 2>&1
    elif command -v flatpak >/dev/null 2>&1; then
      flatpak install -y flathub "$flatpak_id" 2>&1
    else
      echo "Nenhum gerenciador de pacotes suportado encontrado."
    fi
  done
  write_log "instalador_apps"
}

# ---------------------------------------------------------------------------
# Ferramenta: Verificador de drivers (somente leitura)
# ---------------------------------------------------------------------------
tool_verificador_drivers() {
  local lines=()
  lines+=("-- Dispositivos PCI e drivers em uso --")
  if command -v lspci >/dev/null 2>&1; then
    while IFS= read -r l; do lines+=("  $l"); done < <(lspci -k 2>/dev/null | grep -E '^[0-9a-f]|Kernel driver')
  else
    lines+=("lspci não disponível.")
  fi
  lines+=("")

  lines+=("-- Avisos de firmware/driver no dmesg --")
  if command -v dmesg >/dev/null 2>&1; then
    local warns
    warns="$(dmesg 2>/dev/null | grep -iE 'firmware|failed to load|driver.*error' | tail -20)"
    if [ -n "$warns" ]; then
      while IFS= read -r l; do lines+=("[ALERTA] $l"); done <<< "$warns"
    else
      lines+=("Nenhum aviso de firmware/driver encontrado no dmesg.")
    fi
  else
    lines+=("dmesg não disponível (pode exigir sudo em alguns sistemas).")
  fi

  local html
  html="$(render_html_report "PruPru — Verificador de Drivers" "${lines[@]}")"
  write_log "verificador_drivers"
  open_report "$html"
}

# ---------------------------------------------------------------------------
# Menu principal
# ---------------------------------------------------------------------------
# Ordem única das 17 ferramentas — usada pelo menu e pelo dispatch.
# Cada entrada: "chave_de_traducao:nome_da_funcao"
MENU_ENTRIES=(
  "menu_diagnostico:tool_diagnostico"
  "menu_saude_disco:tool_saude_disco"
  "menu_scanner:tool_scanner_seguranca"
  "menu_teste_integridade:tool_teste_integridade"
  "menu_backup_config:tool_backup_config"
  "menu_otimizador:tool_otimizador"
  "menu_reverter:tool_reverter"
  "menu_limpar_espaco:tool_limpar_espaco"
  "menu_gerenciador_init:tool_gerenciador_inicializacao"
  "menu_desinstalador:tool_desinstalador_guiado"
  "menu_foco_jogo_on:tool_foco_jogo_on"
  "menu_foco_jogo_off:tool_foco_jogo_off"
  "menu_turbo_rede_on:tool_turbo_rede_on"
  "menu_turbo_rede_off:tool_turbo_rede_off"
  "menu_streaming_on:tool_modo_streaming_on"
  "menu_streaming_off:tool_modo_streaming_off"
  "menu_tweaks:tool_tweaks_privacidade"
  "menu_instalador_apps:tool_instalador_apps"
  "menu_verificador_drivers:tool_verificador_drivers"
)

run_zenity_menu() {
  local -a labels=()
  for entry in "${MENU_ENTRIES[@]}"; do
    labels+=("$(t "${entry%%:*}")")
  done
  labels+=("$(t menu_sair)")

  zenity --list \
    --title="$(t menu_title)" \
    --width=460 --height=560 \
    --column="Ferramenta" \
    "${labels[@]}" 2>/dev/null
}

run_terminal_menu() {
  echo "== $(t menu_title) =="
  local i=1
  for entry in "${MENU_ENTRIES[@]}"; do
    echo "$i) $(t "${entry%%:*}")"
    i=$((i+1))
  done
  echo "$i) $(t menu_sair)"
  read -rp "> " opt

  if [ "$opt" -ge 1 ] 2>/dev/null && [ "$opt" -lt "$i" ]; then
    local entry="${MENU_ENTRIES[$((opt-1))]}"
    t "${entry%%:*}"
  else
    t menu_sair
  fi
}

# Resolve o nome de função de ferramenta a partir do rótulo escolhido no menu.
fn_for_choice() {
  local choice="$1"
  for entry in "${MENU_ENTRIES[@]}"; do
    if [ "$(t "${entry%%:*}")" = "$choice" ]; then
      echo "${entry#*:}"
      return 0
    fi
  done
  return 1
}

main() {
  # Relançamento elevado (via require_root): roda só a ferramenta pedida.
  if [ "${1:-}" = "--run-tool" ] && [ -n "${2:-}" ]; then
    "$2"
    exit $?
  fi

  while true; do
    local choice fn
    if command -v zenity >/dev/null 2>&1; then
      choice="$(run_zenity_menu)"
    else
      choice="$(run_terminal_menu)"
    fi

    [ -z "$choice" ] && exit 0
    fn="$(fn_for_choice "$choice")" || exit 0
    "$fn"
  done
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi
