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

tgplanvim() {
    terragrunt init

    if [ $? -ne 0 ]; then
        echo "Terraform validation failed. Please fix the issues before running tgplanvim."
        return 1
    fi

    local output
    output=$(terragrunt plan --log-disable -parallelism=100 -out=/tmp/plan.bin 2>&1)

    if [ $? -eq 0 ]; then
        terragrunt run --log-disable -- show -no-color /tmp/plan.bin | nvim -c 'setlocal buftype=nofile foldmethod=indent' -
    else
        echo "$output"
    fi
}

tgapply () {
    terragrunt apply -parallelism=100 $1
}

tgchanges () {
    terragrunt plan --all --log-disable -no-color --parallelism=100 2>&1 | grep -E '(^Plan:|^No changes|^Error|will be|must be)'
}

tfapply () {
    terraform apply -parallelism=100 $1
}

pinstall() {
    poetry install
    local container
    container=$(docker ps --filter "volume=$(pwd)" --format '{{.ID}}' | head -n 1)
    if [ -n "$container" ]; then
        docker exec "$container" poetry install
    fi
}

alias pyblack='poetry run black . --line-length 79'
alias display-monitor-only='xrandr --output HDMI-1 --auto && xrandr --output eDP-1 --off'
alias display-both='xrandr --output eDP-1 --auto && xrandr --output HDMI-1 --left-of eDP-1'
alias rmorigs='find . -name '*.orig' -delete'
alias penv='eval $(poetry env activate)'
alias hax='cat ~/shell-tips.txt'
