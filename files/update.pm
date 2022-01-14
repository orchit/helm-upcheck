package update;
use strict;
use warnings FATAL => 'all';
use nginx;

sub handler {
    my $r = shift;
    $r->send_http_header("text/html");
    return OK if $r->header_only;
    my $out=`/usr/local/bin/update.sh`;
    $r->print($out);
    return OK;
}
1;