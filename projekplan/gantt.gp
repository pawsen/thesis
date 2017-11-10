$DATA << EOD
#Task                 start      end
Duration              2016-09-01 2016-10-28
"Prelim. reading"     2016-09-01 2016-09-05
"CISM course/Italy"   2016-09-05 2016-09-12
"Nolinsys course"     2016-09-14 2016-09-16
"ISMA conference"     2016-09-19 2016-09-21
"Intro."              2016-09-22 2016-10-28
"Partial FNSI impl."  2016-10-01 2016-10-28
EOD

$DATA2 << EOD
#Task                 start      end
Duration              2017-06-20 2017-11-03
"RFS"                 2017-06-20 2017-07-01
"HB impl."            2017-06-20 2017-07-01
"Vacation"            2017-07-01 2017-07-14
"FEM+mesh solve"      2017-07-14 2017-07-21
"NNM + FNSI cont."    2017-07-14 2017-08-15
"Vacation2+hosp."     2017-08-15 2017-08-31
"Writing"             2017-09-01 2017-10-06
"FNSI splines"        2017-09-18 2017-09-22
"Midway report"       2017-10-05 2017-10-06
"Corrections"         2017-10-06 2017-11-03
"Final report"        2017-11-02 2017-11-03
EOD

set xdata time
timeformat = "%Y-%m-%d"
set format x "%b\n'%y"

set yrange [-1:]

OneMonth = strptime("%m","2")
set xtics OneMonth nomirror
set xtics scale 2, 0.5
set mxtics 4
set ytics nomirror
set grid x y
unset key
set title "{/=15 Projektplan}\n\n{/:Italic Before leave}"
set border 3

T(N) = timecolumn(N,timeformat)
set style arrow 1 filled size screen 0.02, 15 fixed lt 3 lw 1.5

set terminal pdf
set output "projektplan.pdf"

plot $DATA using (T(2)) : ($0) : (T(3)-T(2)) : (0.0) : yticlabel(1) with vector as 1

set title "{/=15 Projektplan}\n\n{/:Italic After leave}"
plot $DATA2 using (T(2)) : ($0) : (T(3)-T(2)) : (0.0) : yticlabel(1) with vector as 1
