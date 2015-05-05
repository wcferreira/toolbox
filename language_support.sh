#!/bin/bash

LANGUAGE_SUPPORT="language-pack-pt firefox-locale-pt myspell-en-za thunderbird-locale-pt-br mythes-en-au
                  libreoffice-help-pt-br thunderbird-locale-pt myspell-en-au libreoffice-help-pt 
                  libreoffice-help-en-gb thunderbird-locale-en-us libreoffice-l10n-pt-br kde-l10n-pt 
                  thunderbird-locale-pt-pt wbritish mythes-en-us wbrazilian libreoffice-l10n-en-za 
                  wportuguese libreoffice-l10n-pt hunspell-en-ca thunderbird-locale-en-gb kde-l10n-engb
                  myspell-en-gb kde-l10n-ptbr myspell-pt libreoffice-l10n-en-gb firefox-locale-en
                  openoffice.org-hyphenation thunderbird-locale-en language-pack-gnome-pt hyphen-en-us"

log()
{
    echo "`date`: $@"
}

log_error()
{
    log "ERROR: $@"
}

exit_error()
{
    log_error $@
    exit 1
}

run()
{
    $@
}

run_safe()
{
    run $@
    if [ $? != 0 ]; then
        exit_error "Could not execute [$@]"
    fi
}

update_aptget()
{
    log "Updating apt-get..."
    run sudo -E apt-get update
}

install_language_support()
{
    update_aptget
    log "Installing language support packages..."
    for pkg in `echo $LANGUAGE_SUPPORT`; do
        log "Installing [$pkg]..."
        run_safe sudo -E apt-get install $pkg --assume-yes
    done
}

main()
{
    install_language_support
    log "Environment successfully configured!"
}

main
