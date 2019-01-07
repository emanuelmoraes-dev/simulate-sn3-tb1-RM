set key left bottom
set xrange[0:112]
set yrange[0:110]
set terminal pdf
set output '/home/emanuel/simulate-ns3-out/plot/pkgsize-128/graphic-pkgsize-128.pdf'
set xlabel "Distância"
set ylabel "Taxa de Entrega"
set style line 1 lw 2 pt 1 lc 1
set style line 2 lw 2 pt 2 lc 2
set style line 3 lw 2 pt 3 lc 3
set style line 4 lw 2 pt 4 lc 4
plot "/home/emanuel/simulate-ns3-out/plot/pkgsize-128/graphic-interval-100.txt" title 'Intervalo de Envio de .100 segundos' lw 3 pt 1 lt rgb 'blue' with yerrorlines, "/home/emanuel/simulate-ns3-out/plot/pkgsize-128/graphic-interval-10.txt" title 'Intervalo de Envio de .010 segundos' lw 3 pt 2 lt rgb 'black' with yerrorlines, "/home/emanuel/simulate-ns3-out/plot/pkgsize-128/graphic-interval-1.txt" title 'Intervalo de Envio de .001 segundos' lw 3 pt 3 lt rgb 'red' with yerrorlines
