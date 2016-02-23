#!/usr/bin/env perl6
use v6;
use Benchmark;
use JSON::Fast;

=begin pod

=head1 NAME

bench.p6

=head1 SYNOPSIS

   % ./bench.p6 
   runs benchmarks for default 3 times for all scripts

   % ./bench.p6 1 
   runs 1 benchmark for all scripts

   % ./bench.p6 1 mbrot1.p6 
   runs 1 benchmark for one script and pauses

=head1 NOTE
   Benchmarks are calculated in two ways so figures aren't consistant

=end pod

# EVALFILE stomps over MAIN so we can't use it!
my $times = @*ARGS[0] // 3;
$times.=Int;

my @p;
if  @*ARGS[1] {
    @p.push:  @*ARGS[1];
}
else {

    @p = (dir ".", :test(/mbrot\d\.p6$/))>>.Str.sort;
    # don't prompt for key press in benchmarks 
    %*ENV{'MBROT_BATCH'}++;

}

say "benchmarking will run {$times} interation(s)";

my $desc = from-json( 'README.json'.IO.slurp);

for @p -> $p {
    say $p ~ ' - ' ~ $desc{$p};
    my ($start,$end,$diff,$avg) = timethis($times, 
    sub { EVALFILE $p });
    say 'avg:' ~ $avg;
}
