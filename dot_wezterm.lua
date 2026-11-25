-- Pull in the wezterm API
local wezterm = require("wezterm")

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
config.audible_bell = "Disabled"

config.scrollback_lines = 10000

-- Windows-specific defaults and Launcher entries
local launch_menu = {}
if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
  -- wsl 사용하지 않아도 git은 깔려있겠지
  -- config.default_prog = { "C:\\Program Files\\Git\\bin\\bash.exe", "--login", "-i" }
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

-- https://wezterm.org/config/lua/keyassignment/ShowLauncher.html
config.keys = {
  { key = 'l', mods = 'ALT', action = wezterm.action.ShowLauncher },
}

-- and finally, return the configuration to wezterm
return config
