#
# (c) 2013 slash the underground $ Version 1.0 uDc-zsh.theme
# http://slash.hackerzlair.org - slash@slash.hackerzlair.org
#
# Based on "POWERLINE" and UDCZSH themes
#

UDCZSH_RIGHT_B=%D{%H:%M:%S}
UDCZSH_RIGHT_A=%D{%Y-%m-%d}

UDCZSH_COLOR_BG_GRAY=%K{240}
UDCZSH_COLOR_BG_LIGHT_GRAY=%K{240}
UDCZSH_COLOR_BG_WHITE=%K{255}

UDCZSH_COLOR_FG_GRAY=%F{240}
UDCZSH_COLOR_FG_LIGHT_GRAY=%F{240}
UDCZSH_COLOR_FG_WHITE=%F{255}

GIT_DIRTY_COLOR=%F{133}
GIT_CLEAN_COLOR=%F{118}
GIT_PROMPT_INFO=%F{012}

ZSH_THEME_GIT_PROMPT_PREFIX=" \u2b60 "
ZSH_THEME_GIT_PROMPT_SUFFIX="$GIT_PROMPT_INFO"
ZSH_THEME_GIT_PROMPT_DIRTY=" $GIT_DIRTY_COLOR✘"
ZSH_THEME_GIT_PROMPT_CLEAN=" $GIT_CLEAN_COLOR✔"

ZSH_THEME_GIT_PROMPT_ADDED="%F{082}✚%f"
ZSH_THEME_GIT_PROMPT_MODIFIED="%F{166}✹%f"
ZSH_THEME_GIT_PROMPT_DELETED="%F{160}✖%f"
ZSH_THEME_GIT_PROMPT_RENAMED="%F{220]➜%f"
ZSH_THEME_GIT_PROMPT_UNMERGED="%F{082]═%f"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%F{190]✭%f"

function get_git_branch() {
    ref=$(git symbolic-ref HEAD 2> /dev/null) || return 0
    ref=${ref#refs/heads/}
    echo "$ref       "
}

function get_zsh_pwd() {
    path=`echo $PWD | awk -F/ '{print $NF}'`
    if [ "$PWD" = "$HOME" ]; then
        path='~'
    fi
    echo $path
}

function get_rbenv_version() {
    rb_ver=`rbenv version | awk '{print $1}'`
    echo $rb_ver
}

function get_rbversion() {
	ruby_version=`ruby --version`
	echo $ruby_version
}

function get_kernel_version() {
	kernel_version=`uname -r`
	echo $kernel_version
}

function shell_status() {
	MYID=`id -u`
	if [[ "$MYID" = "0" ]] then
		MYSYM="%k%f%F{red}"$'\u268D'" %k%f%F{white} %n@%M %k%f%F{red}"$'\u26928'""
		echo $MYSYM
	else
		MYSYM="%k%f%F{cyan}"$'\u268D'" %k%f%F{white} %n@%M %k%f%F{cyan}"$'\u2697d'""
		echo $MYSYM
	fi
}


local pl_static_len=34
local pl_rvm_info='%K{166}%F{216} $(rvm-prompt i v g)'" %k%f""%F{166}%K{129}"$'\u2b80'%f
local pl_dir="%K{075}%F{237} %F{black}%1~ %k%f%F{magenta}"
local pl_git_branch="%F{black}%K{magenta}"$'`git_prompt_info`'" %k%f%F{075}%K{166} %f%k"
local pl_rb_version='%F{white}%K{blue} $(get_rbversion) %k%F{blue}%K{075}'%f
local pl_kr_version="%F{white}%K{red}"$'\u2b80'" Kernel-$(get_kernel_version) %k%F{red}%K{075}%f"

local pl_info="${pl_kr_version}${pl_rb_version}${pl_dir}${pl_git_branch}"
local pl_fill='${(l.((${COLUMNS}+2-${#$(get_git_branch)}-${#$(get_zsh_pwd)}-${#$(get_rbenv_version)}-$pl_static_len))...)}'
local pl_time=$UDCZSH_COLOR_FG_WHITE$'\u2b82'"%f$UDCZSH_COLOR_BG_WHITE $UDCZSH_COLOR_FG_GRAY%@ "$'\u2b82'"%f%k$UDCZSH_COLOR_BG_GRAY$UDCZSH_COLOR_FG_WHITE $UDCZSH_RIGHT_A %f%k"
local pl_host="$(shell_status) "$'\u2b80'"%f%k%{$reset_color%} "
# "%k%f%F{red}%K{black}"$'\u2b80'"%k%f%F{white}%K{black} slash@freebsd.md %k%f%F{red}%K{black}"$'\u2b82'"%f%k%{$reset_color%} "
# "$'\u2b80'" "$'\u262D'"

PROMPT="
${pl_info}
${pl_host} "

RPROMPT=$UDCZSH_COLOR_FG_WHITE$'\u2b82'"%f$UDCZSH_COLOR_BG_WHITE $UDCZSH_COLOR_FG_GRAY%@ "$'\u2b82'"%f%k$UDCZSH_COLOR_BG_GRAY$UDCZSH_COLOR_FG_WHITE $UDCZSH_RIGHT_A %f%k"
