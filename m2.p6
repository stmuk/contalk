use v6;
use Mandel2;
use Benchmark;

if @*ARGS[0] {
    say "benchmarking";
    for (2..5) -> $max_threads {
        say "{$max_threads} max thread(s)";
        my ($start,$end,$diff,$avg) = timethis(3, 
        sub { Mandel2.new.run(:$max_threads)});
        say 'arg:' ~ $avg;
    }
} else {
    Mandel2.new.run(:max_threads(2));
    prompt "hit any key";
}
