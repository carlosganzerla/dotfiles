export DC_CMDS=(attach build commit config cp create down events exec export images kill logs ls pause port ps publish pull push restart rm run scale start stats stop top unpause up version volumes wait watch)

export-env() {
    eval $(sed 's/=\(.*\)/=\"\1\"/g' dev.env | grep -v '^\s*$\|^\s*#' | sed 's/^/export /')
}

pr-submit() {
    local sbj=""
    read -p "Subject: " sbj

    if [ -z "$sbj" ]; then
        echo "Subject cannot be empty. Aborting PR creation."
        return 1
    fi
    gh pr create --fill --base devel -b "Subject: $sbj"
}

pyexec () {
    export-env && python3 "$@"
}

nodexec () {
    export-env && node "$@"
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
    export CODEARTIFACT_TOKEN=$(aws --profile alude-sso-dev codeartifact get-authorization-token \
        --domain alude --query authorizationToken --output text) &&
        poetry config http-basic.codeartifact-read aws $CODEARTIFACT_TOKEN
    poetry config http-basic.codeartifact-write aws $CODEARTIFACT_TOKEN
}

tfplanvim() {
    terraform validate

    if [ $? -ne 0 ]; then
        echo "Terraform validation failed. Please fix the issues before running tfplanvim."
        return 1
    fi

    local output
    output=$(terraform plan -parallelism=100 -out=plan.bin 2>&1)

    if [ $? -eq 0 ]; then
        terraform show -no-color plan.bin | nvim -c 'setlocal buftype=nofile foldmethod=indent' -
    else
        echo "$output"
    fi
}

tfapply () {
    terraform apply -parallelism=100
}

toggle-profile() {
    if [ "$AWS_PROFILE" = "alude-sso-dev" ]; then
        export AWS_PROFILE=alude-sso-prod
        echo "Switched to prod profile"
    else
        export AWS_PROFILE=alude-sso-dev
        echo "Switched to dev profile"
    fi
}

# 2. Dynamically Generate the Execution Functions
for cmd in "${DC_CMDS[@]}"; do
    eval "compose-${cmd}() { (cd \"\$CONTAINER_ROOT_DIR\" && docker compose ${cmd} \"\$@\"); }"
done

# 3. The Universal Auto-Complete Router
_dc_alias_complete() {
    if ! complete -p docker &>/dev/null; then
        if type _completion_loader &>/dev/null; then
            _completion_loader docker 2>/dev/null
        else
            source /usr/share/bash-completion/completions/docker 2>/dev/null
        fi
    fi

    local docker_func
    docker_func=$(complete -p docker 2>/dev/null | sed -n 's/.*-F \([^ ]*\).*/\1/p')

    if [[ -z "$docker_func" ]] || ! declare -f "$docker_func" >/dev/null; then
        return 0
    fi

    local triggered_alias="${COMP_WORDS[0]}"
    local docker_cmd="${triggered_alias#compose-}"

    local new_words=("docker" "compose" "$docker_cmd")
    for (( i=1; i<${#COMP_WORDS[@]}; i++ )); do
        new_words+=("${COMP_WORDS[i]}")
    done
    COMP_WORDS=("${new_words[@]}")
    COMP_CWORD=$((COMP_CWORD + 2))

    COMP_LINE="docker compose ${docker_cmd}${COMP_LINE#$triggered_alias}"
    COMP_POINT=$((COMP_POINT + 7))

    local cur="${COMP_WORDS[COMP_CWORD]}"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"

    pushd "$CONTAINER_ROOT_DIR" >/dev/null 2>&1 || return
    "$docker_func" "docker" "$cur" "$prev"
    popd >/dev/null 2>&1
}

# 4. THE SICK PART: Bind the completion dynamically!
# The /#/ syntax automatically prepends "compose-" to every single item in the DC_CMDS array.
complete -F _dc_alias_complete "${DC_CMDS[@]/#/compose-}"

alias pyblack='poetry run black . --line-length 79'
alias display-monitor-only='xrandr --output HDMI-1 --auto && xrandr --output eDP-1 --off'
alias display-both='xrandr --output eDP-1 --auto && xrandr --output HDMI-1 --left-of eDP-1'
alias rmorigs='find . -name '*.orig' -delete'
alias penv='eval $(poetry env activate)'
alias hax='cat ~/shell-tips.txt'
