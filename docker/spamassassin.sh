#!/usr/bin/with-contenv sh

if [ ! -f /tmp/state/10-spamassassin ]; then
    
    echo "Starting Initialization..."
    ### File Permissions Check
    mkdir -p /var/lib/spamassassin
    mkdir -p /var/log/spamassassin
    mkdir -p /var/run/spamassassin
    chown -R spamassassin:spamassassin /var/lib/spamassassin /var/run/spamassassin /var/log/spamassassin
    
    ### Assets Setup
    if [ ! -f /etc/mail/spamassassin/local.cf ] ; then
        echo '** [spamasassin] Copying Default Configuration'
        cp -R /assets/mail /etc/
        #chown -R spamassassin:spamassassin /etc/mail
    fi
    
    ### Update Spamassassin Ruleset
    if [ ! -f /var/lib/spamassassin/.initialized ] ; then
        echo '** [spamasassin] Updating Rulesets'
        s6-envuidgid spamassassin sa-update
        touch /var/lib/spamassassin/.initialized
    fi
    
    ### Set Debug Mode
    if [ "$DEBUG_MODE" = "TRUE" ] || [ "$DEBUG_MODE" = "true" ]; then
        set -x
        DEBUG_ARG="--debug"
    fi
    
    echo 'Initialization Complete' >/tmp/state/10-spamasassin
fi

echo ''
echo '** Starting spamassassin'
exec spamd --username spamassassin --nouser-config --syslog=/var/log/spamassassin/spamd.log -pidfile /var/run/spamassassin/spamd.pid --helper-home-dir /var/lib/spamassassin --ip-address 0.0.0.0:737 --allowed-ips 0.0.0.0/0 $DEBUG_ARG
