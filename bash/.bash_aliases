alias hax='cat ~/shell-tips.txt'

pyexec () {
    export $(cat .env | xargs) && python3 "$@"
}

pydebug () {
    export $(cat .env | xargs) && python3 -m pdb "$@"
}

nodexec () {
    export $(cat .env | xargs) && node "$@"
}

l () {
    ledger -f $JOURNAL_PATH/journal.ledger "$@"
}

lscript () {
    bash $JOURNAL_PATH/scripts/main "$@"
}

xact () {
    local xact_fmt="$(l xact "$@" | sed -E s/"([0-9]{4})-([0-9]{2})-([0-9]{2}) "/"\1-\2-\3 * "/g)";
    echo "$xact_fmt";
    if [ $? -eq 0 ]; then
        read -p "Write to ledger? [y/n] " yn
        case $yn in
            [yY] )
                echo "" >> $JOURNAL_PATH/journal.ledger;
                echo "$xact_fmt" >> $JOURNAL_PATH/journal.ledger;
                echo "Written successfully!";;
            [nN] ) ;;
            * ) echo Invalid response;;
        esac
    fi
}

setup-artifact() {
    export CODEARTIFACT_TOKEN=$(aws --profile dev codeartifact get-authorization-token \
        --domain alude --query authorizationToken --output text) &&
    poetry config http-basic.codeartifact-read aws $CODEARTIFACT_TOKEN
    poetry config http-basic.codeartifact-write aws $CODEARTIFACT_TOKEN
}


ollama-unload() {
    curl http://localhost:11434/api/generate -d '{"model": "'$1'", "keep_alive": 0}'
}

tfplandiff () {
    cat $1 | jq -r '
    .resource_changes[]
    | select(.change.actions[0] != "no-op")
    | . as $change
    | (
        # Print the Header (Action + Address)
        "------------------------------------------------------------------------\n" +
        ($change.change.actions | join("/") | ascii_upcase) + ": " + $change.address + "\n"
        ),
        (
        # If it is an UPDATE, find the changed fields
        if $change.change.actions == ["update"] then
            (
            $change.change.before as $old |
            $change.change.after as $new |
            ($old | keys_unsorted) as $keys |
            $keys[] |
            select($old[.] != $new[.]) |
            "  ~ " + . + ": \"" + ($old[.] | tostring) + "\" -> \"" + ($new[.] | tostring) + "\""
            )
        else
            empty
        end
        )
    '
}

tfplandigested () {
    terraform plan -out=/tmp/plan.bin &> /dev/null
    terraform show -json /tmp/plan.bin > /tmp/plan.json && tfplandiff /tmp/plan.json
}

alias pyblack='poetry run black . --line-length 79'
alias display-monitor-only='xrandr --output HDMI-1 --auto && xrandr --output eDP-1 --off'
alias display-both='xrandr --output eDP-1 --auto && xrandr --output HDMI-1 --left-of eDP-1'
alias rmorigs='find . -name '*.orig' -delete'
alias penv='eval $(poetry env activate)'
