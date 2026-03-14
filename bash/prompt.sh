# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

git_prompt=
if command -v git >/dev/null 2>&1; then
    for git_prompt_script in /usr/lib/git-core/git-sh-prompt /etc/bash_completion.d/git-prompt; do
        if [ -f "$git_prompt_script" ]; then
            . "$git_prompt_script"
            break
        fi
    done

    if command -v __git_ps1 >/dev/null 2>&1; then
        git_prompt='$(__git_ps1 " (%s)")'
    fi
fi
unset git_prompt_script

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]'$git_prompt'\n\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w'$git_prompt'\n\$ '
fi
unset color_prompt force_color_prompt git_prompt
