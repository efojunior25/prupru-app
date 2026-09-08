#!/usr/bin/env bash
# PruPru para macOS — diagnóstico e otimização, um arquivo só, sem instalação.
# Extensão .command pra abrir com duplo clique no Finder (abre o Terminal).
# Mesma arquitetura do PruPru.sh (Linux): idioma persistente, log de
# execuções, relatório HTML com o mesmo CSS de marca, GUI via AppleScript
# (osascript, nativo do macOS — sem instalar nada), auto-elevação via sudo.
#
# AVISO: este script foi revisado com cuidado mas NÃO foi executado numa
# máquina macOS real (ambiente de desenvolvimento é Linux). Teste antes do
# release. Ver /home/edson-oliveira/.claude/plans/pure-dancing-grove.md
set -u

PRUPRU_HOME="$HOME/Library/Application Support/PruPru"
PRUPRU_LANG_FILE="$PRUPRU_HOME/lang.txt"
PRUPRU_LOG_FILE="$PRUPRU_HOME/PruPru_Log.txt"
mkdir -p "$PRUPRU_HOME"

# ---------------------------------------------------------------------------
# Idioma (pt/en/es), mesmo padrão persistente do Windows/Linux
# ---------------------------------------------------------------------------
detect_lang() {
  if [ -f "$PRUPRU_LANG_FILE" ]; then
    cat "$PRUPRU_LANG_FILE"
    return
  fi
  local sys_lang
  sys_lang="$(defaults read -g AppleLocale 2>/dev/null || echo en_US)"
  case "$sys_lang" in
    pt*) echo "pt" ;;
    es*) echo "es" ;;
    *) echo "en" ;;
  esac
}

PRUPRU_LANG="$(detect_lang)"

t() {
  local key="$1"
  case "$PRUPRU_LANG" in
    pt) local -n dict="TXT_PT_$key" ;;
    es) local -n dict="TXT_ES_$key" ;;
    *)  local -n dict="TXT_EN_$key" ;;
  esac
  echo "${dict}"
}

TXT_PT_menu_title="PruPru — Diagnóstico e Otimização para macOS"
TXT_EN_menu_title="PruPru — Diagnostics and Optimization for macOS"
TXT_ES_menu_title="PruPru — Diagnóstico y Optimización para macOS"

TXT_PT_menu_diagnostico="Diagnóstico completo"
TXT_EN_menu_diagnostico="Full diagnostics"
TXT_ES_menu_diagnostico="Diagnóstico completo"

TXT_PT_menu_saude_disco="Saúde do disco (SMART)"
TXT_EN_menu_saude_disco="Disk health (SMART)"
TXT_ES_menu_saude_disco="Salud del disco (SMART)"

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

TXT_PT_menu_verificador_drivers="Verificador de extensões"
TXT_EN_menu_verificador_drivers="Extension checker"
TXT_ES_menu_verificador_drivers="Verificador de extensiones"

TXT_PT_menu_sair="Sair"
TXT_EN_menu_sair="Exit"
TXT_ES_menu_sair="Salir"

TXT_PT_report_saved="Relatório salvo em:"
TXT_EN_report_saved="Report saved to:"
TXT_ES_report_saved="Informe guardado en:"

TXT_PT_smartctl_missing="smartctl não encontrado. Instale com 'brew install smartmontools' para ver a saúde SMART dos discos. Mostrando o status básico do diskutil."
TXT_EN_smartctl_missing="smartctl not found. Install it with 'brew install smartmontools' to see disk SMART health. Showing basic diskutil status instead."
TXT_ES_smartctl_missing="smartctl no encontrado. Instálelo con 'brew install smartmontools' para ver la salud SMART de los discos. Mostrando el estado básico de diskutil."

TXT_PT_brew_missing="Homebrew não encontrado. Instale em https://brew.sh para usar o Instalador de Apps e algumas otimizações."
TXT_EN_brew_missing="Homebrew not found. Install it from https://brew.sh to use the App Installer and some optimizations."
TXT_ES_brew_missing="Homebrew no encontrado. Instálelo desde https://brew.sh para usar el Instalador de Apps y algunas optimizaciones."

# ---------------------------------------------------------------------------
# Log de execuções — mesmo formato do Windows/Linux
# ---------------------------------------------------------------------------
write_log() {
  local tool_key="$1"
  printf '%s\t%s\n' "$(date -Iseconds 2>/dev/null || date +%Y-%m-%dT%H:%M:%S%z)" "$tool_key" >> "$PRUPRU_LOG_FILE"
}

# ---------------------------------------------------------------------------
# Relatório HTML — mesmo CSS de marca do Windows/Linux
# ---------------------------------------------------------------------------
render_html_report() {
  local title="$1"
  shift
  local lines=("$@")
  local out
  out="$(mktemp -t pruprureport.XXXXXX)"
  mv "$out" "$out.html"
  out="$out.html"

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
    printf '<p class="meta">PruPru para macOS &middot; %s</p>\n' "$(date '+%d/%m/%Y %H:%M')"

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

# Descobre o $HOME de verdade mesmo rodando elevado via sudo (que troca
# $HOME pro do root) — mesmo raciocínio e correção aplicados na versão
# Linux depois de testes reais em VM.
real_user_home() {
  if [ -n "${SUDO_USER:-}" ]; then
    dscl . -read "/Users/$SUDO_USER" NFSHomeDirectory 2>/dev/null | awk '{print $2}'
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
    chown "$SUDO_USER":staff "$dest" 2>/dev/null
  fi
  echo "$(t report_saved) $dest"
  ( open "$dest" >/dev/null 2>&1 & ) || true
}

# ---------------------------------------------------------------------------
# GUI helpers via osascript (AppleScript nativo, sem instalar nada)
# ---------------------------------------------------------------------------
has_gui() {
  [ -n "${DISPLAY:-}" ] || [ "$(launchctl managername 2>/dev/null)" = "Aqua" ]
}

osa_info() {
  osascript -e "display dialog \"$2\" with title \"$1\" buttons {\"OK\"} default button \"OK\"" >/dev/null 2>&1
}

osa_choose() {
  # osa_choose <título> <opção1> <opção2> ... — retorna a opção escolhida
  local title="$1"; shift
  local items="\"$1\""; shift
  for i in "$@"; do items="$items, \"$i\""; done
  osascript -e "choose from list {$items} with title \"$title\" without multiple selections allowed" 2>/dev/null
}

# ---------------------------------------------------------------------------
# require_root <nome-da-função> — mesma lógica da versão Linux
# ---------------------------------------------------------------------------
require_root() {
  local tool_fn="$1"
  if [ "$(id -u)" -eq 0 ]; then
    return 0
  fi
  if command -v sudo >/dev/null 2>&1; then
    exec sudo "$0" --run-tool "$tool_fn"
  else
    echo "Este recurso precisa de privilégios de administrador (sudo não encontrado)." >&2
    exit 1
  fi
}

# ---------------------------------------------------------------------------
# Ferramenta: Diagnóstico completo
# ---------------------------------------------------------------------------
tool_diagnostico() {
  local lines=()
  lines+=("-- Sistema --")
  lines+=("macOS: $(sw_vers -productName 2>/dev/null) $(sw_vers -productVersion 2>/dev/null) (build $(sw_vers -buildVersion 2>/dev/null))")
  lines+=("Modelo: $(sysctl -n hw.model 2>/dev/null)")
  lines+=("Uptime: $(uptime | sed 's/.*up //;s/,.*load.*//')")
  lines+=("")

  lines+=("-- CPU e memória --")
  lines+=("CPU: $(sysctl -n machdep.cpu.brand_string 2>/dev/null)")
  local mem_total_bytes mem_total_mb
  mem_total_bytes="$(sysctl -n hw.memsize 2>/dev/null)"
  mem_total_mb=$(( mem_total_bytes / 1024 / 1024 ))
  local vm_stat_out page_size pages_free pages_active pages_inactive pages_wired
  page_size="$(vm_stat 2>/dev/null | head -1 | grep -o '[0-9]\+')"
  pages_active="$(vm_stat 2>/dev/null | awk '/Pages active/{gsub(/\./,"",$3); print $3}')"
  pages_wired="$(vm_stat 2>/dev/null | awk '/Pages wired/{gsub(/\./,"",$4); print $4}')"
  if [ -n "${page_size:-}" ] && [ -n "${pages_active:-}" ]; then
    local used_mb=$(( (pages_active + pages_wired) * page_size / 1024 / 1024 ))
    local mem_pct=$(( used_mb * 100 / mem_total_mb ))
    lines+=("Memória: ${used_mb}MB usados de ${mem_total_mb}MB (${mem_pct}%)")
    if [ "$mem_pct" -ge 90 ]; then
      lines+=("[ALERTA] Uso de memória acima de 90% — considere fechar aplicativos.")
    fi
  fi
  lines+=("")

  lines+=("-- Disco --")
  while IFS= read -r disk_line; do
    lines+=("$disk_line")
  done < <(df -H / /System/Volumes/Data 2>/dev/null | tail -n +2)
  local root_pct
  root_pct="$(df / 2>/dev/null | tail -1 | awk '{print $5}' | tr -dc '0-9')"
  if [ -n "${root_pct:-}" ] && [ "$root_pct" -ge 90 ]; then
    lines+=("[ALERTA] Volume do sistema com ${root_pct}% de uso — espaço em disco crítico.")
  fi
  lines+=("")

  lines+=("-- Itens de inicialização --")
  local agents_dir="$HOME/Library/LaunchAgents"
  if [ -d "$agents_dir" ]; then
    local count
    count="$(find "$agents_dir" -name '*.plist' 2>/dev/null | wc -l | tr -d ' ')"
    lines+=("$count item(ns) de inicialização automática em $agents_dir")
    while IFS= read -r f; do
      lines+=("  - $(basename "$f" .plist)")
    done < <(find "$agents_dir" -name '*.plist' 2>/dev/null)
  else
    lines+=("Nenhuma pasta de LaunchAgents encontrada para este usuário.")
  fi
  lines+=("")

  lines+=("-- Atualizações pendentes --")
  local upd
  upd="$(softwareupdate -l 2>/dev/null | grep -c '\* Label:')"
  lines+=("$upd atualização(ões) do sistema disponível(is) (softwareupdate -l).")
  if command -v brew >/dev/null 2>&1; then
    local brew_upd
    brew_upd="$(brew outdated 2>/dev/null | wc -l | tr -d ' ')"
    lines+=("Homebrew: $brew_upd pacote(s) desatualizado(s).")
  fi
  lines+=("")

  lines+=("-- Eventos críticos recentes (7 dias) --")
  if command -v log >/dev/null 2>&1; then
    local crit_count
    crit_count="$(log show --predicate 'messageType == 16' --last 7d 2>/dev/null | wc -l | tr -d ' ')"
    lines+=("$crit_count linha(s) de erro no log unificado nos últimos 7 dias.")
    if [ "${crit_count:-0}" -gt 0 ] 2>/dev/null; then
      lines+=("[ALERTA] Há erros recentes no log do sistema — rode 'log show --predicate \"messageType == 16\" --last 7d' para detalhes.")
    fi
  else
    lines+=("Comando 'log' não disponível.")
  fi

  local html
  html="$(render_html_report "PruPru — Diagnóstico Completo" "${lines[@]}")"
  write_log "diagnostico"
  open_report "$html"
}

# ---------------------------------------------------------------------------
# Ferramenta: Saúde do disco (SMART via smartctl, com fallback pro diskutil)
# ---------------------------------------------------------------------------
tool_saude_disco() {
  local lines=()
  lines+=("-- Discos detectados --")

  local has_smartctl=1
  if ! command -v smartctl >/dev/null 2>&1; then
    has_smartctl=0
    lines+=("[ALERTA] $(t smartctl_missing)")
    lines+=("")
  fi

  while IFS= read -r disk; do
    [ -z "$disk" ] && continue
    lines+=("Disco $disk")
    if [ "$has_smartctl" -eq 1 ]; then
      # Mesma correção de falso-positivo aplicada na versão Linux: só
      # confia na linha real de resultado SMART, nunca no texto de erro
      # genérico (que também pode conter a palavra FAILED).
      local health
      health="$(smartctl -H "$disk" 2>/dev/null | grep -i 'overall-health\|test result')"
      if [ -n "$health" ]; then
        lines+=("  SMART: $health")
        if echo "$health" | grep -qi 'FAILED'; then
          lines+=("[ALERTA] Disco $disk reporta falha SMART iminente — faça backup imediatamente.")
        fi
      else
        lines+=("  SMART: não foi possível ler via smartctl (pode exigir sudo, ou disco sem suporte SMART/USB).")
      fi
    else
      local diskutil_smart
      diskutil_smart="$(diskutil info "$disk" 2>/dev/null | grep -i 'SMART Status')"
      lines+=("  ${diskutil_smart:-SMART Status: não informado pelo diskutil}")
    fi
    lines+=("")
  done < <(diskutil list 2>/dev/null | grep -o '^/dev/disk[0-9]\+')

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
    if pgrep -qi "$m" >/dev/null 2>&1; then
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

  lines+=("-- Itens de inicialização (LaunchAgents/LaunchDaemons) --")
  for dir in "$HOME/Library/LaunchAgents" "/Library/LaunchAgents" "/Library/LaunchDaemons"; do
    if [ -d "$dir" ]; then
      while IFS= read -r f; do
        lines+=("  - $(basename "$f") ($dir)")
      done < <(find "$dir" -name '*.plist' 2>/dev/null)
    fi
  done
  lines+=("Revise os itens acima que você não reconhece.")

  local html
  html="$(render_html_report "PruPru — Scanner de Segurança" "${lines[@]}")"
  write_log "scanner_seguranca"
  open_report "$html"
}

# ---------------------------------------------------------------------------
# Ferramenta: Teste de integridade rápido
# ---------------------------------------------------------------------------
tool_teste_integridade() {
  local msgs=()

  local mem_total_bytes mem_total_mb page_size pages_active pages_wired
  mem_total_bytes="$(sysctl -n hw.memsize 2>/dev/null)"
  mem_total_mb=$(( mem_total_bytes / 1024 / 1024 ))
  page_size="$(vm_stat 2>/dev/null | head -1 | grep -o '[0-9]\+')"
  pages_active="$(vm_stat 2>/dev/null | awk '/Pages active/{gsub(/\./,"",$3); print $3}')"
  pages_wired="$(vm_stat 2>/dev/null | awk '/Pages wired/{gsub(/\./,"",$4); print $4}')"
  if [ -n "${page_size:-}" ] && [ -n "${pages_active:-}" ] && [ "$mem_total_mb" -gt 0 ]; then
    local used_mb=$(( (pages_active + pages_wired) * page_size / 1024 / 1024 ))
    local mem_pct=$(( used_mb * 100 / mem_total_mb ))
    [ "$mem_pct" -ge 90 ] && msgs+=("[ALERTA] Memória em ${mem_pct}% de uso.")
  fi

  local root_pct
  root_pct="$(df / 2>/dev/null | tail -1 | awk '{print $5}' | tr -dc '0-9')"
  if [ -n "${root_pct:-}" ] && [ "$root_pct" -ge 90 ]; then
    msgs+=("[ALERTA] Volume do sistema em ${root_pct}% de uso.")
  fi

  if command -v smartctl >/dev/null 2>&1; then
    while IFS= read -r disk; do
      [ -z "$disk" ] && continue
      local health
      health="$(smartctl -H "$disk" 2>/dev/null | grep -i 'overall-health\|test result')"
      if echo "$health" | grep -qi 'FAILED'; then
        msgs+=("[ALERTA] Disco $disk reporta falha SMART.")
      fi
    done < <(diskutil list 2>/dev/null | grep -o '^/dev/disk[0-9]\+')
  fi

  local summary
  if [ "${#msgs[@]}" -eq 0 ]; then
    summary="Tudo certo: memória, disco e SMART dentro do esperado."
  else
    summary="$(printf '%s\n' "${msgs[@]}")"
  fi

  write_log "teste_integridade"
  if has_gui; then
    osa_info "PruPru — Teste de Integridade" "$summary"
  else
    echo "== PruPru — Teste de Integridade =="
    echo "$summary"
  fi
}

# ---------------------------------------------------------------------------
# Ferramenta: Backup de configurações (somente leitura)
# ---------------------------------------------------------------------------
tool_backup_config() {
  local lines=()

  lines+=("-- DNS por serviço de rede --")
  while IFS= read -r svc; do
    [ -z "$svc" ] && continue
    local dns
    dns="$(networksetup -getdnsservers "$svc" 2>/dev/null)"
    lines+=("$svc: $dns")
  done < <(networksetup -listallnetworkservices 2>/dev/null | tail -n +2)
  lines+=("")

  lines+=("-- Energia (pmset) --")
  while IFS= read -r l; do lines+=("  $l"); done < <(pmset -g 2>/dev/null | head -15)
  lines+=("")

  lines+=("-- Configuração de rede (TCP) --")
  lines+=("delayed_ack: $(sysctl -n net.inet.tcp.delayed_ack 2>/dev/null)")
  lines+=("sendspace: $(sysctl -n net.inet.tcp.sendspace 2>/dev/null)")
  lines+=("recvspace: $(sysctl -n net.inet.tcp.recvspace 2>/dev/null)")

  local html
  html="$(render_html_report "PruPru — Backup de Configurações" "${lines[@]}")"
  write_log "backup_config"
  open_report "$html"
}

# ---------------------------------------------------------------------------
# Ferramenta: Otimizador de sistema (+ Reverter) — precisa de root
# Paralelo ao "pausar indexador tracker" do Linux: desativa a indexação
# do Spotlight temporariamente (mdutil), que ajuda em discos externos
# lentos ou logo após copiar muitos arquivos.
# ---------------------------------------------------------------------------
PRUPRU_OTIMIZADOR_STATE="$PRUPRU_HOME/otimizador_state.txt"

tool_otimizador() {
  require_root "tool_otimizador"
  local lines=()
  : > "$PRUPRU_OTIMIZADOR_STATE"

  lines+=("-- Limpeza --")
  if command -v brew >/dev/null 2>&1; then
    brew cleanup -s >/dev/null 2>&1
    lines+=("Cache do Homebrew limpo (brew cleanup -s).")
  else
    lines+=("[ALERTA] $(t brew_missing)")
  fi
  purge >/dev/null 2>&1 && lines+=("Memória inativa liberada (purge).")
  lines+=("")

  lines+=("-- Indexação do Spotlight --")
  if mdutil -s / 2>/dev/null | grep -qi "Indexing enabled"; then
    mdutil -i off / >/dev/null 2>&1
    echo "/" >> "$PRUPRU_OTIMIZADOR_STATE"
    lines+=("Indexação do Spotlight pausada no volume do sistema — ajuda logo após copiar muitos arquivos.")
  else
    lines+=("Indexação do Spotlight já estava pausada ou não disponível.")
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
    while IFS= read -r vol; do
      [ -z "$vol" ] && continue
      mdutil -i on "$vol" >/dev/null 2>&1
      lines+=("Indexação do Spotlight reativada em $vol.")
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
# Ferramenta: Limpar espaço em disco — precisa de root
# ---------------------------------------------------------------------------
tool_limpar_espaco() {
  require_root "tool_limpar_espaco"
  local lines=()
  local before after freed_mb
  before="$(df -m / 2>/dev/null | tail -1 | awk '{print $4}')"

  lines+=("-- O que foi limpo --")

  if [ -n "${SUDO_USER:-}" ]; then
    local user_home
    user_home="$(dscl . -read "/Users/$SUDO_USER" NFSHomeDirectory 2>/dev/null | awk '{print $2}')"
    if [ -n "$user_home" ]; then
      rm -rf "${user_home:?}/Library/Caches"/* 2>/dev/null
      lines+=("Cache do usuário $SUDO_USER limpo (~/Library/Caches).")
      rm -rf "${user_home:?}/.Trash"/* 2>/dev/null
      lines+=("Lixeira esvaziada.")
    fi
  fi

  if command -v brew >/dev/null 2>&1; then
    brew cleanup -s >/dev/null 2>&1
    lines+=("Cache do Homebrew limpo (brew cleanup -s).")
  fi

  after="$(df -m / 2>/dev/null | tail -1 | awk '{print $4}')"
  freed_mb=$(( after - before ))
  [ "$freed_mb" -lt 0 ] && freed_mb=0
  lines+=("")
  lines+=("Espaço livre aproximadamente ${freed_mb}MB maior que antes (volume do sistema).")

  local html
  html="$(render_html_report "PruPru — Limpeza de Disco" "${lines[@]}")"
  write_log "limpar_espaco"
  open_report "$html"
}

# ---------------------------------------------------------------------------
# Ferramenta: Gerenciador de inicialização — LaunchAgents do usuário,
# com "cofre" de itens desativados (sem root)
# ---------------------------------------------------------------------------
PRUPRU_STARTUP_VAULT="$PRUPRU_HOME/disabled-startup"

tool_gerenciador_inicializacao() {
  mkdir -p "$PRUPRU_STARTUP_VAULT" "$HOME/Library/LaunchAgents"

  local -a active=()
  local -a disabled=()
  while IFS= read -r f; do active+=("$(basename "$f")"); done \
    < <(find "$HOME/Library/LaunchAgents" -name '*.plist' 2>/dev/null)
  while IFS= read -r f; do disabled+=("$(basename "$f")"); done \
    < <(find "$PRUPRU_STARTUP_VAULT" -name '*.plist' 2>/dev/null)

  echo "== Gerenciador de Inicialização =="
  echo "-- Itens --"
  local i=1
  local -a idx_map=()
  for f in "${active[@]}"; do
    echo "  $i) [ATIVO]      $f"
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
      launchctl unload "$HOME/Library/LaunchAgents/$fname" 2>/dev/null
      mv "$HOME/Library/LaunchAgents/$fname" "$PRUPRU_STARTUP_VAULT/$fname"
      echo "$fname desativado (movido pro cofre)."
    else
      mv "$PRUPRU_STARTUP_VAULT/$fname" "$HOME/Library/LaunchAgents/$fname"
      launchctl load "$HOME/Library/LaunchAgents/$fname" 2>/dev/null
      echo "$fname reativado."
    fi
  fi
  write_log "gerenciador_inicializacao"
}

# ---------------------------------------------------------------------------
# Ferramenta: Desinstalador guiado — Aplicativos por tamanho + Homebrew
# ---------------------------------------------------------------------------
tool_desinstalador_guiado() {
  echo "== Desinstalador Guiado =="
  local -a names=()
  local -a paths=()

  while IFS= read -r line; do
    local size app
    size="$(echo "$line" | awk '{print $1}')"
    app="$(echo "$line" | cut -f2-)"
    names+=("$app ($size)")
    paths+=("/Applications/$app")
  done < <(du -sh /Applications/*.app 2>/dev/null | sed 's#/Applications/##' | sort -rh | head -30)

  if [ "${#names[@]}" -eq 0 ]; then
    echo "Nenhum aplicativo encontrado em /Applications."
    write_log "desinstalador_guiado"
    return
  fi

  local i=1
  for n in "${names[@]}"; do
    echo "  $i) $n"
    i=$((i+1))
  done

  read -rp "Número do app a mover pra Lixeira (Enter pra cancelar): " sel
  if [ -n "$sel" ] && [ -n "${paths[$((sel-1))]:-}" ]; then
    local target="${paths[$((sel-1))]}"
    local dest_home
    dest_home="$(real_user_home)"
    mv "$target" "$dest_home/.Trash/" 2>/dev/null && echo "Movido pra Lixeira: $target" \
      || echo "Não foi possível mover $target — tente com privilégios de administrador."
  fi
  write_log "desinstalador_guiado"
}

# ---------------------------------------------------------------------------
# Ferramenta: Foco no Jogo ON/OFF
# Mesma decisão consciente da versão Linux: reprioriza processos em vez
# de bloquear rede por app (não existe firewall por processo simples e
# portável no macOS sem instalar algo).
# ---------------------------------------------------------------------------
tool_foco_jogo_on() {
  local lines=()
  for p in Steam Lutris; do
    local pid
    pid="$(pgrep -x "$p" | head -1)"
    if [ -n "$pid" ]; then
      renice -n -5 -p "$pid" >/dev/null 2>&1
      lines+=("Prioridade de $p elevada.")
    fi
  done
  for b in "Google Chrome" Safari firefox; do
    local pid
    pid="$(pgrep -x "$b" | head -1)"
    if [ -n "$pid" ]; then
      renice -n 10 -p "$pid" >/dev/null 2>&1
      lines+=("Prioridade de $b reduzida.")
    fi
  done
  local html
  html="$(render_html_report "PruPru — Foco no Jogo Ativado" "${lines[@]}")"
  write_log "foco_jogo_on"
  open_report "$html"
}

tool_foco_jogo_off() {
  local lines=()
  for b in "Google Chrome" Safari firefox Steam Lutris; do
    local pid
    pid="$(pgrep -x "$b" | head -1)"
    [ -n "$pid" ] && renice -n 0 -p "$pid" >/dev/null 2>&1
  done
  lines+=("Prioridades de processos restauradas ao normal.")
  local html
  html="$(render_html_report "PruPru — Foco no Jogo Desativado" "${lines[@]}")"
  write_log "foco_jogo_off"
  open_report "$html"
}

# ---------------------------------------------------------------------------
# Ferramenta: Turbo de Rede ON/OFF — precisa de root pro networksetup
# ---------------------------------------------------------------------------
tool_turbo_rede_on() {
  require_root "tool_turbo_rede_on"
  local lines=()
  while IFS= read -r svc; do
    [ -z "$svc" ] && continue
    networksetup -setdnsservers "$svc" 1.1.1.1 1.0.0.1 >/dev/null 2>&1
    lines+=("DNS do serviço \"$svc\" definido pra 1.1.1.1 / 1.0.0.1 (Cloudflare).")
  done < <(networksetup -listallnetworkservices 2>/dev/null | tail -n +2)

  local html
  html="$(render_html_report "PruPru — Turbo de Rede Ativado" "${lines[@]}")"
  write_log "turbo_rede_on"
  open_report "$html"
}

tool_turbo_rede_off() {
  require_root "tool_turbo_rede_off"
  local lines=()
  while IFS= read -r svc; do
    [ -z "$svc" ] && continue
    networksetup -setdnsservers "$svc" "Empty" >/dev/null 2>&1
    lines+=("DNS do serviço \"$svc\" revertido pro padrão do DHCP.")
  done < <(networksetup -listallnetworkservices 2>/dev/null | tail -n +2)

  local html
  html="$(render_html_report "PruPru — Turbo de Rede Desativado" "${lines[@]}")"
  write_log "turbo_rede_off"
  open_report "$html"
}

# ---------------------------------------------------------------------------
# Ferramenta: Modo Streaming ON/OFF
# Suporte limitado e best-effort: o toggle de "Não Perturbe" via
# `defaults write` deixou de funcionar de forma confiável a partir do
# macOS Catalina/Monterey (Focus/Control Center não expõe uma API de
# linha de comando estável). Documentado como limitação conhecida.
# ---------------------------------------------------------------------------
tool_modo_streaming_on() {
  local lines=()
  for p in OBS obs-studio "Streamlabs Desktop"; do
    local pid
    pid="$(pgrep -x "$p" | head -1)"
    if [ -n "$pid" ]; then
      renice -n -5 -p "$pid" >/dev/null 2>&1
      lines+=("Prioridade de $p elevada.")
    fi
  done
  lines+=("[ALERTA] Alternar \"Não Perturbe\" automaticamente não é confiável nas versões recentes do macOS — ative manualmente pela Central de Controle, se quiser.")
  local html
  html="$(render_html_report "PruPru — Modo Streaming Ativado" "${lines[@]}")"
  write_log "modo_streaming_on"
  open_report "$html"
}

tool_modo_streaming_off() {
  local lines=()
  for p in OBS obs-studio "Streamlabs Desktop"; do
    local pid
    pid="$(pgrep -x "$p" | head -1)"
    [ -n "$pid" ] && renice -n 0 -p "$pid" >/dev/null 2>&1
  done
  lines+=("Prioridades de processos restauradas ao normal.")
  local html
  html="$(render_html_report "PruPru — Modo Streaming Desativado" "${lines[@]}")"
  write_log "modo_streaming_off"
  open_report "$html"
}

# ---------------------------------------------------------------------------
# Ferramenta: Tweaks de privacidade
# ---------------------------------------------------------------------------
tool_tweaks_privacidade() {
  echo "== Tweaks de Privacidade =="
  local lines=()

  echo "1) Sugestões da Spotlight/Siri (busca)"
  echo "2) Compartilhar análise com a Apple"

  read -rp "Número do item pra alternar (Enter pra sair): " sel
  case "$sel" in
    1)
      local cur
      cur="$(defaults read com.apple.lookup.shared LookupSuggestionsDisabled 2>/dev/null)"
      if [ "$cur" = "1" ]; then
        defaults write com.apple.lookup.shared LookupSuggestionsDisabled -bool false
        lines+=("Sugestões da Spotlight/Siri reativadas.")
      else
        defaults write com.apple.lookup.shared LookupSuggestionsDisabled -bool true
        lines+=("Sugestões da Spotlight/Siri desativadas.")
      fi
      ;;
    2)
      require_root "tool_tweaks_privacidade"
      local plist="/Library/Application Support/CrashReporter/DiagnosticMessagesHistory.plist"
      local cur
      cur="$(defaults read /Library/Preferences/com.apple.SubmitDiagInfo AutoSubmit 2>/dev/null)"
      if [ "$cur" = "1" ]; then
        defaults write /Library/Preferences/com.apple.SubmitDiagInfo AutoSubmit -bool false
        lines+=("Envio automático de diagnósticos pra Apple desativado.")
      else
        defaults write /Library/Preferences/com.apple.SubmitDiagInfo AutoSubmit -bool true
        lines+=("Envio automático de diagnósticos pra Apple reativado.")
      fi
      ;;
    *) lines+=("Nenhuma alteração feita.") ;;
  esac

  write_log "tweaks_privacidade"
  printf '%s\n' "${lines[@]}"
}

# ---------------------------------------------------------------------------
# Ferramenta: Instalador de apps — via Homebrew Cask
# ---------------------------------------------------------------------------
tool_instalador_apps() {
  echo "== Instalador de Apps =="
  if ! command -v brew >/dev/null 2>&1; then
    echo "$(t brew_missing)"
    write_log "instalador_apps"
    return
  fi

  local -a catalog=(firefox google-chrome vlc gimp libreoffice visual-studio-code telegram)
  local -a labels=("Firefox" "Google Chrome" "VLC" "GIMP" "LibreOffice" "VS Code" "Telegram")

  local i=1
  for label in "${labels[@]}"; do
    echo "  $i) $label"
    i=$((i+1))
  done

  read -rp "Números separados por espaço pra instalar (Enter pra cancelar): " -a sels
  [ "${#sels[@]}" -eq 0 ] && { write_log "instalador_apps"; return; }

  for sel in "${sels[@]}"; do
    local cask="${catalog[$((sel-1))]:-}"
    [ -z "$cask" ] && continue
    brew install --cask "$cask" 2>&1
  done
  write_log "instalador_apps"
}

# ---------------------------------------------------------------------------
# Ferramenta: Verificador de extensões (equivalente limitado a
# "Verificador de Drivers" — o macOS não expõe um "gerenciador de
# drivers" como o Windows; o mais próximo é o log de kernel extensions).
# ---------------------------------------------------------------------------
tool_verificador_drivers() {
  local lines=()
  lines+=("-- Extensões do sistema instaladas --")
  if command -v system_profiler >/dev/null 2>&1; then
    while IFS= read -r l; do lines+=("  $l"); done < <(system_profiler SPExtensionsDataType 2>/dev/null | grep -E '^\s{4}[A-Za-z]' | head -40)
  else
    lines+=("system_profiler não disponível.")
  fi
  lines+=("")
  lines+=("[ALERTA] Suporte parcial: o macOS não expõe um verificador de drivers com problema como o Windows Device Manager. Esta lista é informativa.")

  local html
  html="$(render_html_report "PruPru — Verificador de Extensões" "${lines[@]}")"
  write_log "verificador_drivers"
  open_report "$html"
}

# ---------------------------------------------------------------------------
# Menu principal — mesma estrutura MENU_ENTRIES/dispatch da versão Linux
# ---------------------------------------------------------------------------
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

run_osa_menu() {
  local -a labels=()
  for entry in "${MENU_ENTRIES[@]}"; do
    labels+=("$(t "${entry%%:*}")")
  done
  osa_choose "$(t menu_title)" "${labels[@]}"
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
  if [ "${1:-}" = "--run-tool" ] && [ -n "${2:-}" ]; then
    "$2"
    exit $?
  fi

  while true; do
    local choice fn
    if has_gui && command -v osascript >/dev/null 2>&1; then
      choice="$(run_osa_menu)"
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
