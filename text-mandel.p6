# ported from mandel.pl (from Rosetta code)
# this in turn was based on mandel.rb
# see 3rdparty
#
use v6;

my $rows = 40;
my $cols = 79;
 
my $t0 = DateTime.now.Instant;

$PROCESS::SCHEDULER=ThreadPoolScheduler.new(initial_threads => 0, max_threads =>1, uncaught_handler => Callable);

loop (my $y = 1; $y >= -1; $y -= $rows/800) { # rows
        loop (my $x = -2; $x <= 0.5; $x += $cols/2500) { # cols
            print mandelbrot($x + $y * i) ?? ' ' !! '#';
        }
        print "\n";
}

say  DateTime.now.Instant - $t0;

sub mandelbrot($c) {
    my $z = $c;
    for (1 .. 20) {
        $z = $z * $z + $c;
        return $_ if $z.re.abs > 2;
    }
}


