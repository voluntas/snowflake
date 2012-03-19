#!/usr/bin/env perl
use strict;
use warnings;
use JSON qw/encode_json decode_json/;
use Time::HiRes;

sub bench {
    my $binary = shift;
    encode_json(decode_json($binary));
}

my $file = 'tokoroten.json';
open my $fh, '<', $file or die "Cannot open $file: $!";
my $binary = do { local $/; <$fh> };

my $start = Time::HiRes::time;
for my $i (1..100) {
    bench($binary);
}
my $end = Time::HiRes::time;
my $time = ($end - $start) * 1000 * 1000;
print $time . "\n";
