#!/usr/bin/env -perl

use strict;
use warnings;
use Bio::Seq;

my (@results);

open (FH, '<', @ARGV) or die $!;

print "queryID\tmatchID\tmatch_start\tMAPQ\tseq_reverse\tmatch_seq\n";
while (<FH>) {
    chomp($_);
    if ($_ =~ /^@/) {
        next;
    } else {
        @results = split(/\t/, $_);
        if ($results[4] > 20) {
            my $obj = Bio::Seq->new(-id => "sam", -seq => $results[9]);
            if ($results[1] == 16) {
                print "$results[0]\t$results[2]\t$results[3]\t$results[4]\tRev\t";
                print $obj->revcom->seq;
                print "\n";
            } else {
                print "$results[0]\t$results[2]\t$results[3]\t$results[4]\tFor\t";
                print $obj->seq;
                print "\n";
            }
        } else {
            next;
        }
    }
}

close (FH);
