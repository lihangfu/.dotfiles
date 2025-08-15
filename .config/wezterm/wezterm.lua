--
-- ██╗    ██╗███████╗███████╗████████╗███████╗██████╗ ███╗   ███╗
-- ██║    ██║██╔════╝╚══███╔╝╚══██╔══╝██╔════╝██╔══██╗████╗ ████║
-- ██║ █╗ ██║█████╗    ███╔╝    ██║   █████╗  ██████╔╝██╔████╔██║
-- ██║███╗██║██╔══╝   ███╔╝     ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║
-- ╚███╔███╔╝███████╗███████╗   ██║   ███████╗██║  ██║██║ ╚═╝ ██║
--  ╚══╝╚══╝ ╚══════╝╚══════╝   ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝
-- A GPU-accelerated cross-platform terminal emulator
-- https://wezfurlong.org/wezterm/

-- 引入工具模块和 wezterm 主模块
local k = require('utils/keys')
local wezterm = require('wezterm')

-- 设置 GUI 启动时的窗口位置
wezterm.on('gui-startup', function(cmd) -- set startup Window position
    local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
    window:gui_window():set_position(1000, 1000)
end)

-- 定义动作和透明度变量
local act = wezterm.action
local opacity = 1.0

-- 主配置表
local config = {
    -- ╭─────────────────────────────────────────────────────────╮
    -- │                         GENERAL                         │
    -- ╰─────────────────────────────────────────────────────────╯
    -- 禁用自动检查更新
    check_for_updates = false,
    
    -- ╭─────────────────────────────────────────────────────────╮
    -- │                       APPEARANCE                        │
    -- ╰─────────────────────────────────────────────────────────╯
    -- 字体设置
    font_size = 16,
    -- font = wezterm.font("JetBrainsMonoNL Nerd Font Mono", { weight = "Regular" }),
    -- font = wezterm.font("Hack Nerd Font", { weight = "Regular" }),
    -- 字体配置，包含多种字体的回退选项
    font = wezterm.font_with_fallback({
        -- { family = "FiraCode Nerd Font Mono", weight = "Regular" },
        -- { family = "Hack Nerd Font", weight = "Regular" },
        -- { family = "MesloLGL Nerd Font Mono", weight = "Regular" },
        { family = 'JetBrains Mono', weight = 'Regular' },
        { family = 'Sarasa Term SC Nerd', weight = 'Regular' },
        { family = 'SF Pro', weight = 'Regular' },
    }),
    line_height = 1.1,

    -- 颜色主题设置
    color_scheme = 'Catppuccin Mocha',
    set_environment_variables = {
        BAT_THEME = 'Catppuccin-mocha',
    },

    -- 窗口设置
    initial_cols = 127,
    initial_rows = 37,
    window_padding = {
        left = 15,
        right = 15,
        top = 15,
        bottom = 15,
    },
    -- 禁止在更改字体大小时调整窗口大小
    adjust_window_size_when_changing_font_size = false,
    -- 关闭窗口时总是提示确认
    window_close_confirmation = 'AlwaysPrompt',
    -- 窗口装饰设置
    window_decorations = 'RESIZE | MACOS_FORCE_ENABLE_SHADOW',
    -- 窗口背景透明度
    window_background_opacity = opacity,
    -- macOS 窗口背景模糊效果
    macos_window_background_blur = 70,
    -- 禁用原生 macOS 全屏模式
    native_macos_fullscreen_mode = false,

    -- 标签页设置
    enable_tab_bar = true,
    -- 禁用花哨的标签栏
    use_fancy_tab_bar = false,
    -- 只有一个标签页时隐藏标签栏
    hide_tab_bar_if_only_one_tab = true,
    -- 隐藏标签栏中的新建标签按钮
    show_new_tab_button_in_tab_bar = false,
    colors = {
        tab_bar = {
            -- 标签栏背景色
            background = 'rgba(12%, 12%, 18%, 90%)',
            active_tab = {
                -- 活动标签的背景和前景色
                bg_color = '#cba6f7',
                fg_color = 'rgba(12%, 12%, 18%, 0%)',
                intensity = 'Bold',
            },
            inactive_tab = {
                -- 非活动标签的颜色设置
                fg_color = '#cba6f7',
                bg_color = 'rgba(12%, 12%, 18%, 90%)',
                intensity = 'Normal',
            },
            inactive_tab_hover = {
                -- 鼠标悬停时非活动标签的颜色
                fg_color = '#cba6f7',
                bg_color = 'rgba(27%, 28%, 35%, 90%)',
                intensity = 'Bold',
            },
            new_tab = {
                -- 新标签按钮的颜色
                fg_color = '#808080',
                bg_color = '#1e1e2e',
            },
        },
    },

    -- ╭─────────────────────────────────────────────────────────╮
    -- │                          KEYS                           │
    -- ╰─────────────────────────────────────────────────────────╯
    -- 键盘快捷键配置
    keys = {
        -- Neovim 相关快捷键
        k.cmd_key('b', k.multiple_actions(':Neotree toggle')),
        k.cmd_key('p', k.multiple_actions(':Telescope find_files')),
        k.cmd_key('F', k.multiple_actions(':Telescope live_grep')),
        k.cmd_key('g', k.multiple_actions(':LazyGitCurrentFile')),
        k.cmd_key('G', k.multiple_actions(':Telescope git_submodules')),
        k.cmd_key('R', k.multiple_actions(':OverseerRestartLast')),
        k.cmd_key('r', k.multiple_actions(':OverseerRun')),
        k.cmd_ctrl_key('d', k.multiple_actions(':DiffviewFileHistory %')),
        -- 保存文件快捷键
        k.cmd_key(
            's',
            act.Multiple({
                act.SendKey({ key = '\x1b' }), -- escape
                k.multiple_actions(':w'),
            })
        ),
        -- Tmux 模拟快捷键
        k.cmd_to_tmux_prefix('1', '1'),
        k.cmd_to_tmux_prefix('2', '2'),
        k.cmd_to_tmux_prefix('3', '3'),
        k.cmd_to_tmux_prefix('4', '4'),
        k.cmd_to_tmux_prefix('5', '5'),
        k.cmd_to_tmux_prefix('6', '6'),
        k.cmd_to_tmux_prefix('7', '7'),
        k.cmd_to_tmux_prefix('8', '8'),
        k.cmd_to_tmux_prefix('9', '9'),
        k.cmd_to_tmux_prefix('n', '"'), -- tmux 水平分割
        k.cmd_to_tmux_prefix('N', '%'), -- tmux 垂直分割
        k.cmd_to_tmux_prefix('d', 'w'), -- tmux-sessionx
        k.cmd_to_tmux_prefix('t', 'c'), -- 新建 tmux 窗口
        k.cmd_to_tmux_prefix('w', 'x'), -- 关闭 tmux 窗格
        k.cmd_to_tmux_prefix('z', 'z'), -- tmux 缩放
        -- 切换窗口透明度
        {
            key = 't',
            mods = 'CMD|CTRL',
            action = wezterm.action.EmitEvent('toggle-opacity'),
        },
    },
}

-- 返回配置表
return config
