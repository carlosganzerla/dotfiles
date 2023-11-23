alias hax='cat ~/shell-tips.txt'

pyexec () {
    export $(cat .env | xargs) && poetry run python3 "$@"
}

setup-artifact() {
    export CODEARTIFACT_TOKEN=$(aws codeartifact get-authorization-token \
        --domain alude --query authorizationToken --output text) &&
    poetry config http-basic.codeartifact-read aws $CODEARTIFACT_TOKEN
    poetry config http-basic.codeartifact-write aws $CODEARTIFACT_TOKEN
}

alias pyblack='poetry run black . --line-length 79'
alias vimdiff='nvim -d'
alias display-monitor-only='xrandr --output HDMI-1 --auto && xrandr --output eDP-1 --off'
alias display-both='xrandr --output eDP-1 --right-of HDMI-1'
