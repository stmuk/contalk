#!/usr/bin/env perl6
use v6;
use Benchmark;
use JSON::Fast;

=pod
can pass number of times to run script on command line - defaults to 3
=cut

# don't prompt for key press in benchmarks 
%*ENV{'MBROT_BATCH'}++;

# EVALFILE stomps over MAIN so we can't use it!
my $times = @*ARGS[0] // 3;
$times.=Int;

say "benchmarking will run {$times} interation(s)";

my $desc = from-json( 'README.json'.IO.slurp);
my @p = (dir ".", :test(/mbrot\d\.p6$/))>>.Str.sort;

for @p -> $p {
    say $p ~ ' - ' ~ $desc{$p};
    my ($start,$end,$diff,$avg) = timethis($times, 
    sub { EVALFILE $p });
    say 'avg:' ~ $avg;
}
