!/usr/bin/env zsh

##############################################################################
#                                                                            #
# illizian's zsh theme                                                       #
# A Powerline, agnoster & amuse inspired theme for ZSH                       #
#                                                                            #
# Dependencies                                                               #
# * fonts-font-awesome package                                               #
#                                                                            #
# MODIFIED VERSION BY Slash The Underground                                  #
##############################################################################

############################
# Variables                #
############################

# Icons
FA_I_GIT=""
FA_I_UNSTAGED=""
FA_I_STAGED=""

FA_I_CLCK=""
FA_I_WIFI="" #  酪
FA_I_ETH0=""
FA_I_DSCD=""
FA_I_HOME=""
FA_I_ACTV=""
FA_I_FAIL=""
FA_I_ROOT=""
FA_I_NODE=""
FA_I_GRPH=""
FA_I_SPED=""

FA_I_OTBD=""
FA_I_INBD=""
FA_I_CAL=""

# Formatting
TXT_BOLD="\e[1m"
TXT_UNBOLD="\e[21m"

############################
# Prompt Segments          #
############################

CURRENT_BG='NONE'
SEGMENT_SEPARATOR=''

prompt_break() {
  echo -n "\n"
}
# Begin a segment
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.
prompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    echo -n " %{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%} "
  else
    echo -n "%{$bg%}%{$fg%} "
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && echo -n $3
}

key_val() {
  [[ -n $3 ]] && echo -n "$1 ${TXT_BOLD}$2${TXT_UNBOLD}" || echo -n "$1 $2"
}

############################
# Functions                #
############################

prompt_status() {
  # Status:
  # - was there an error
  # - are there background jobs?
  [[ $RETVAL -ne 0 ]] && prompt_segment yellow black "$FA_I_FAIL"
  [[ $(jobs -l | wc -l) -gt 0 ]] && prompt_segment yellow black "$FA_I_ACTV"
}

prompt_time() {
  prompt_segment blue white "$FA_I_CLCK %*% "
}

# Dir: current working directory
prompt_dir() {
  prompt_segment green white "${PWD/#$HOME/$FA_I_HOME }% "
}

prompt_ip() {
  #ip="$(hostname -i | awk '{print $2}')"
  ip="$(ip -4 addr show ens33 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')"
  #eth0="$(/usr/sbin/ifconfig eth0)"

  prompt_segment cyan white
  #if [[ $ip > /dev/null ]]; then
  #  if [[ -n $eth0 ]]; then
  #    key_val $FA_I_ETH0 $ip
  #  else
  #    key_val $FA_I_WIFI $ip
  #  fi
  #else
  #  echo -n "$FA_I_DSCD"
  echo -n " $ip"
  #fi
}

# in progress - prompt jadi slow
prompt_pubip() {
	#pubip="$(curl -s http://whatismyip.akamai.com/)"
	if [ -s $HOME/hacklabs/dotfile/tmp/pubip.txt ]
	then
		pubip="$(cat $HOME/hacklabs/dotfile/tmp/pubip.txt; echo)"
	else
		pubip="$(wget http://whatismyip.akamai.com/ -O - -q; echo)"
	fi

	prompt_segment magenta white
	echo -n "酪$pubip"
}

prompt_coding() {
	python_ver="$(python -c 'import sys; print(".".join(map(str, sys.version_info[:3])))')"
	ruby_ver="$(ruby -v | awk '{print $2}')"

	prompt_segment red white
	echo -n " $ruby_ver |  $python_ver"
}

# nerd font meslo
#           
prompt_sneakyrat() {
	prompt_segment blue white "  sneakyrat" # 
}

prompt_nodeversion() {
  version=$(node -v 2>/dev/null)
  prompt_segment red white
  key_val $FA_I_NODE $version
}

prompt_stats() {
  if [[ -n $3 ]]; then
    cpu_load_avg=$(uptime | awk '{print $(NF-2),$(NF-1),$NF}' | tr -d ',')
  elif [[ -n $2 ]]; then
    cpu_load_avg=$(uptime | awk '{print $(NF-2),$(NF-1)}' | tr -d ',')
  else
    cpu_load_avg=$(uptime | awk '{print $(NF-2)}' | tr -d ',')
  fi
  mem_used=$(free -h | grep Mem: | awk '{print $3}')
  prompt_segment blue white 
  key_val $FA_I_GRPH "$cpu_load_avg "
  key_val $FA_I_SPED $mem_used
}

# Git: branch/detached head, dirty status
prompt_git() {
  local ref dirty
  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    dirty=$(parse_git_dirty)
    ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="➦ $(git show-ref --head -s --abbrev |head -n1 2> /dev/null)"
    if [[ -n $dirty ]]; then
      prompt_segment yellow black
    else
      prompt_segment green white
    fi

    setopt promptsubst
    autoload -Uz vcs_info

    zstyle ':vcs_info:*' enable git
    zstyle ':vcs_info:*' get-revision true
    zstyle ':vcs_info:*' check-for-changes true
    zstyle ':vcs_info:*' stagedstr $FA_I_STAGED
    zstyle ':vcs_info:git:*' unstagedstr $FA_I_UNSTAGED
    zstyle ':vcs_info:*' formats ' %u%c'
    zstyle ':vcs_info:*' actionformats ' %u%c'
    vcs_info
    echo -n "${ref/refs\/heads\//$FA_I_GIT }${vcs_info_msg_0_%% }"
    # key_val ${ref/refs\/heads\//$FA_I_GIT } ${vcs_info_msg_0_%% }
  fi
}

# Context: user@hostname (who am I and where am I)
prompt_context() {
  local user=`whoami`

  if [[ $UID -eq 0 ]]; then
    echo -n "$FA_I_ROOT $user"
  elif [[ "$user" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
    echo -n "$user@%m "
  fi
}

# End the prompt, closing any open segments
prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
    echo -n " %{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
  else
    echo -n "%{%k%}"
  fi
  echo -n "%{%f%}"
  CURRENT_BG=''
}

# Setup for user input
prompt_cmd() {
  #                    
	uid=`/usr/bin/id -u`
        if [ $uid = 0 ]; then
                echo -n "   "
        else
                echo -n "  "
        fi
}

############################
# Build the Prompt         #
############################
# The prompt is responsive, to customise change 
# the variable below or enable modules in sml/lrg 
# respectively

build_prompt() {
  if [[ ${COLUMNS} -gt 90 ]]; then
    build_lrg_prompt
  else
    build_sml_prompt
  fi
}
build_lrg_prompt() {
  prompt_sneakyrat
  prompt_status
  prompt_dir
  prompt_coding
  #prompt_stats 1 5 10
  # prompt_time
  prompt_ip
  #prompt_pubip
  #prompt_nodeversion
  prompt_git
  prompt_end
  prompt_break
  prompt_cmd
}

build_sml_prompt() {
  prompt_sneakyrat
  prompt_status
  # prompt_time
  prompt_dir
  #prompt_stats 1 #5 10
  prompt_ip
  #prompt_pubip
  # prompt_nodeversion
  prompt_git
  prompt_end
  prompt_break
  prompt_cmd
}

PROMPT='$(build_prompt)'

# EOF
