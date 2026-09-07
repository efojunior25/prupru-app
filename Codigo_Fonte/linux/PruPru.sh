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

open_report() {
  local path="$1"
  local dest="$HOME/Desktop/$(basename "$path" .html)-$(date +%Y%m%d-%H%M%S).html"
  mkdir -p "$HOME/Desktop" 2>/dev/null
  cp "$path" "$dest" 2>/dev/null || dest="$path"
  echo "$(t report_saved) $dest"
  ( xdg-open "$dest" >/dev/null 2>&1 & ) || true
}

# ---------------------------------------------------------------------------
# Auto-elevação — pronta pra fases futuras (Otimizador, Turbo de Rede etc.)
# que precisam de root. As ferramentas da Fase 1 são todas somente-leitura
# e não chamam isto.
# ---------------------------------------------------------------------------
require_root() {
  if [ "$(id -u)" -eq 0 ]; then
    return 0
  fi
  if command -v pkexec >/dev/null 2>&1; then
    exec pkexec "$0" "$@"
  elif command -v sudo >/dev/null 2>&1; then
    exec sudo "$0" "$@"
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
# Menu principal
# ---------------------------------------------------------------------------
run_zenity_menu() {
  local choice
  choice="$(zenity --list \
    --title="$(t menu_title)" \
    --width=420 --height=300 \
    --column="Ferramenta" \
    "$(t menu_diagnostico)" \
    "$(t menu_saude_disco)" \
    "$(t menu_sair)" 2>/dev/null)"
  echo "$choice"
}

run_terminal_menu() {
  echo "== $(t menu_title) =="
  echo "1) $(t menu_diagnostico)"
  echo "2) $(t menu_saude_disco)"
  echo "3) $(t menu_sair)"
  read -rp "> " opt
  case "$opt" in
    1) echo "$(t menu_diagnostico)" ;;
    2) echo "$(t menu_saude_disco)" ;;
    *) echo "$(t menu_sair)" ;;
  esac
}

main() {
  while true; do
    local choice
    if command -v zenity >/dev/null 2>&1; then
      choice="$(run_zenity_menu)"
    else
      choice="$(run_terminal_menu)"
    fi

    case "$choice" in
      "$(t menu_diagnostico)") tool_diagnostico ;;
      "$(t menu_saude_disco)") tool_saude_disco ;;
      *) exit 0 ;;
    esac
  done
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi
