# fix https://github.com/skim-rs/skim/issues/775 by moving `--no-multi` to `SKIM_DEFAULT_OPTIONS`
skim-cd-widget() {
  local cmd="${SKIM_ALT_C_COMMAND:-"command find -L . -mindepth 1 \\( -path '*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune \
    -o -type d -print 2> /dev/null | cut -b3-"}"
  setopt localoptions pipefail no_aliases 2> /dev/null
  REPORTTIME_=$REPORTTIME
  unset REPORTTIME
  local dir="$(eval "$cmd" | SKIM_DEFAULT_OPTIONS="--height ${SKIM_TMUX_HEIGHT:-40%} --reverse $SKIM_DEFAULT_OPTIONS $SKIM_ALT_C_OPTS --no-multi" $(__skimcmd))"
  if ! [ -z $REPORTTIME_ ]; then
      REPORTTIME=$REPORTTIME_
  fi
  unset REPORTTIME_
  if [[ -z "$dir" ]]; then
    zle redisplay
    return 0
  fi
  if [ -z "$BUFFER" ]; then
    BUFFER="cd ${(q)dir}"
    zle accept-line
  else
    print -sr "cd ${(q)dir}"
    cd "$dir"
  fi
  local ret=$?
  unset dir # ensure this doesn't end up appearing in prompt expansion
  zle skim-redraw-prompt
  tput cnorm
  return $ret
}

zle -N skim-cd-widget

