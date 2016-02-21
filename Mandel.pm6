unit class Mandel;
use v6;
use SDL2::Raw;

my Int $width = 240;
my Int $height = 192;

my $hwidth = ($width /2).Int;
my $hheight = ($height/2).Int;

my Int $wid = 4;
my (Int $xcenter, Int $ycenter) = (-1,0);

my @screen[$height*4;$width*4];

constant SDL_WINDOW_SHOWN = 0x00000004;

method run(:$max_threads, :$plot) {
    my $t0 = DateTime.now.Instant;

    $PROCESS::SCHEDULER=ThreadPoolScheduler.new(initial_threads => 0, max_threads => $max_threads, uncaught_handler => Callable);

    await do for ( 0..$width) -> Int $xcoord {
        start {
            say ($xcoord/$width *100).Int ~'%' if $xcoord %% 20 and $plot;
            for ( 0..$height-1) -> Int $ycoord {

                my $ca = ($xcoord - $hwidth) / $width * $wid + $xcenter;
                my $cb = ($ycoord - $hheight) / $width * 1 * $wid + $ycenter;

                my ($res, $i) = mandelbrot($ca + $cb * i);

                my $hcolor=128;
                $hcolor=10*$i if $i;

                my $color;
                if !$res.defined {
                    $color = (0,0,0);
                }  
                else {
                    if $i < 5 {
                        $color = (0, 0,128);
                    } elsif $i > 5 and $i < 7 {
                        $color =  (0, 0, $hcolor);
                    } elsif $i > 7 and $i < 10 {
                        $color = (0, $hcolor, 0);
                    } else {
                        $color =  ($hcolor,0, 0);
                    }
                }
                save $xcoord, $ycoord, $color;

            }                   

        }

    }


    if $plot {

        SDL_Init(VIDEO);

        my $window = SDL_CreateWindow("Mandelbrot",
        SDL_WINDOWPOS_CENTERED_MASK, SDL_WINDOWPOS_CENTERED_MASK,
        $width, $height, SDL_WINDOW_SHOWN);

        my $render = SDL_CreateRenderer($window, -1, 1);
        SDL_SetRenderDrawColor($render, 0, 0,128, 0);
        SDL_RenderClear($render);
        SDL_RenderPresent($render);

        for ( 25..$width) -> $xcoord {
            for ( 0..$height-1) -> $ycoord {

                if @screen[$xcoord; $ycoord ].defined {
                    my $color = @screen[$xcoord; $ycoord ];
                    plot $render, $xcoord, $ycoord, $color.list;

                }
            }
        }

        SDL_RenderPresent($render);

        say  DateTime.now.Instant - $t0;
        prompt("wait..");
        SDL_Quit();

    }

}

sub save($x,$y,$c) {
    @screen[$x; $y ]=$c;
}

sub plot($render, $x,$y,$c) {
    my ($c1, $c2, $c3) = $c; # XXX
    SDL_SetRenderDrawColor($render,$c1,$c2,$c3,0);
    SDL_RenderDrawPoint($render, $x, $y);
}

sub mandelbrot(Complex $c) {
    my $z = $c;
    for (1 .. 20) -> $i {
        $z = $z * $z + $c;
        return ($z,$i) if $z.abs> 2;
    }
}

