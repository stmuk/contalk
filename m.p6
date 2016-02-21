use v6;
use Mandel;
use Benchmark;

if @*ARGS[0] {
    say "benchmarking";
    for (1..4) -> $max_threads {
        say "{$max_threads} max thread(s)";
        my ($start,$end,$diff,$avg) = timethis(3, 
        sub { Mandel.new.run(:$max_threads)});
        say 'arg:' ~ $avg;
    }
} else {
    Mandel.new.run(:max_threads(2), :plot(1));
}
