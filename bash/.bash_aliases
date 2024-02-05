alias hax='cat ~/shell-tips.txt'

pyexec () {
    export $(cat .env | xargs) && poetry run python3 "$@"
}

l () {
    ledger -f $JOURNAL_PATH --check-payees --pedantic "$@"
}

xact () {
    local xact_fmt="$(l xact "$@" | sed -E s/"([0-9]{4})\/([0-9]{2})\/([0-9]{2}) "/"\1-\2-\3 * "/g)";
    echo "$xact_fmt";
    if [ $? -eq 0 ]; then
        read -p "Write to ledger?" yn
        case $yn in 
            [yY] )
                echo "" >> $JOURNAL_PATH;
                echo "$xact_fmt" >> $JOURNAL_PATH;
                echo "Written successfully!";;
            [nN] ) ;;
            * ) echo Invalid response;;
        esac
    fi
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
