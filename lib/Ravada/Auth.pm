use warnings;
use strict;

package Ravada::Auth;

our $LDAP;

use Ravada::Auth::SQL;

eval { 
    require Ravada::Auth::LDAP; 
    $LDAP = 1 
};

sub init {
    my ($config, $db_con) = @_;
    if ($config->{ldap}) {
        Ravada::Auth::LDAP::init($config);
        warn "LDAP enabled";
    } else {
        $LDAP = 0;
    }
#    Ravada::Auth::SQL::init($config, $db_con);
}

sub login {
    my ($name, $pass) = @_;

    return Ravada::Auth::LDAP->new(name => $name, password => $pass)
        if $LDAP;
    if ($@ =~ /I can't connect/i) {
        $LDAP = 0;
        warn $@;
    }
    return Ravada::Auth::SQL::login(@_);
}

1;
