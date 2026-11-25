-- Pull in the wezterm API
local wezterm = require('wezterm')

-- This will hold the configuration.
local config = wezterm.config_builder()

config.initial_cols = 128
config.initial_rows = 28

config.font = wezterm.font('D2Coding')
config.font_size = 12

-- disable ligatures
-- https://wezterm.org/faq.html?h=ligature#how-do-i-disable-ligatures
-- '>=' 같은거 뭉쳐지는거 익숙하지 않아서 끄고싶다
config.harfbuzz_features = { 'calt = 0', 'clig = 0', 'liga = 0' }


config.color_scheme = 'Material Darker (base16)'

-- 비프음(소리) 끄기
config.audible_bell = 'Disabled'

config.scrollback_lines = 10000

-- Windows-specific defaults and Launcher entries
local launch_menu = {}
if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
  -- wsl 사용하지 않아도 git은 깔려있겠지
  -- config.default_prog = { 'C:\\Program Files\\Git\\bin\\bash.exe', '--login', '-i' }
  config.default_domain = 'WSL:Ubuntu-26.04'

  table.insert(launch_menu, {
    label = 'Git Bash',
    args = { 'C:/Program Files/Git/bin/bash.exe', '--login', '-i' },
    domain = { DomainName = 'local' },
  })
  table.insert(launch_menu, {
    label = 'Command Prompt',
    args = { 'cmd.exe' },
    domain = { DomainName = 'local' },
  })
  table.insert(launch_menu, {
    label = 'PowerShell',
    args = { 'powershell.exe', '-NoLogo' },
    domain = { DomainName = 'local' },
  })
end
config.launch_menu = launch_menu

-- wsl.exe -> wslhost.ext로 탭 이름이 바뀌는거 못생겨서 기본값 고정
wezterm.on('format-tab-title', function(tab)
  local pane = tab.active_pane
  local title = pane.title or ''

  if pane.domain_name == 'WSL:Ubuntu-26.04' then
    local lower_title = title:lower()
    if lower_title:match('wsl%.exe$') or lower_title:match('wslhost%.exe$') then
      return 'wsl'
    end
  end

  return title
end)

-- wezterm + shift-enter + pi.dev(codex, ...)
-- pi.dev, codex cli 같은 환경에서 개행으로 shift-enter 안먹힌다
-- https://github.com/wezterm/wezterm/issues/7164
-- 수정1. config.enable_kitty_keyboard = true
-- link: https://www.reddit.com/r/wezterm/s/gWfCWWjKE3
-- shift-enter는 되는데 한글입력이 안된다! 어쩔수 없이 포기
-- 수정2. config.keys
-- link: https://www.reddit.com/r/wezterm/s/ZZYLUPqCPS
-- 멍청하게 생겼지만 확실한 방법

config.keys = {
  -- https://wezterm.org/config/lua/keyassignment/ShowLauncher.html
  { key = 'l', mods = 'ALT', action = wezterm.action.ShowLauncher },
  { mods = 'SHIFT', key = 'Enter', action = wezterm.action.SendString('\x1b[13;2u') },
  { mods = 'CTRL', key = 'Enter', action = wezterm.action.SendString('\x1b[13;5u') },
}

-- and finally, return the configuration to wezterm
return config
