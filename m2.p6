#!/usr/bin/env perl6 -Ilib
use v6;
use Mandel2;
use Benchmark;

if @*ARGS[0] {
    %*ENV{'MBROT_BATCH'}++;
    say "benchmarking";
    for (1..4) -> $max_threads {
        say "{$max_threads} max thread(s)";
        my ($start,$end,$diff,$avg) = timethis(3, 
        sub { Mandel2.new.run()});
        say 'arg:' ~ $avg;
    }
} else {
    Mandel2.new.run();
}
