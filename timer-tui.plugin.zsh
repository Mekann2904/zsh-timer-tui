## === tt (タイマー) ===
tt() {
  if [ -z "$1" ]; then
    echo "Usage: tt <time> [label] (e.g., tt 5, tt 1h30m)"
    return 1
  fi

  local input="$1"
  shift
  local duration=""

  if [[ "$input" =~ ^[0-9]+$ ]]; then
    duration="00:${input}:00"
  else
    local h=$(echo "$input" | grep -oE '[0-9]+h' | tr -d 'h')
    local m=$(echo "$input" | grep -oE '[0-9]+m' | tr -d 'm')
    local s=$(echo "$input" | grep -oE '[0-9]+s' | tr -d 's')
    h=${h:-0}; m=${m:-0}; s=${s:-0}
    duration=$(printf "%02d:%02d:%02d" $h $m $s)
  fi

  echo "⏱️  Starting timer: $duration ($input)"
  timr-tui -c "$duration" -m countdown "$@"

  if [ $? -eq 0 ]; then
    echo -e "\a"
    if [[ "$OSTYPE" == "darwin"* ]]; then
      osascript -e "display notification \"Finished: $input\" with title \"Timer Done\" sound name \"Glass\""
    fi
  fi
}

