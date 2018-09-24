#!/usr/bin/perl

use strict;
use warnings;
use Monitoring::Plugin;
use Monitoring::Plugin::REST;

my $plugin = Monitoring::Plugin::REST->new(
    shortname => 'OCEANSTOR',
    version   => '1.00',
    usage => 'check_oceanstor -H https://HOST -u USER -p PASS [-i] [--help]',
    authentication => {
        method => 'POST',
        endpoint => '/deviceManager/rest/xxxxx/sessions',
        request_map => {
            username => [ 'content', 'username' ],
            password => [ 'content', 'password' ],
        },
        static_content_data => {
            scope => 0,
        },
        response_map => {
            'data/iBaseToken' => [ 'header', 'iBaseToken' ],
            'data/deviceid' => [ 'path', 'deviceid' ],
        },
    },
);
$plugin->getopts;

# Fetch current alarm
my $alarm = $plugin->fetch('GET', '/deviceManager/rest/@deviceid@/alarm/currentalarm');

# Verify basic structure, just in case
for ($alarm->{error}, $alarm->{error}->{code}, $alarm->{data}) {
    $plugin->plugin_exit(UNKNOWN, 'Invalid response') unless defined($_);
}

# Actually check
my $alarms = @{$alarm->{data}};
$plugin->plugin_exit(CRITICAL, "$alarms alarms") if $alarms != 0;
$plugin->plugin_exit(OK, 'No alarms');
