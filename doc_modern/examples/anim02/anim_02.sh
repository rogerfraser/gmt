#!/bin/bash
#               GMT ANIMATION 02
#               $Id$
#
# Purpose:      Make simple animated GIF of an illuminated DEM grid
# GMT modules   gmtmath, makecpt, grdimage, psxy, movie
# Unix progs:   cat
# Note:         Run with any argument to build movie; otherwise 1st frame is plotted only.

if [ $# -eq 1 ]; then	# Just make master PostScript frame 0
	opt="-Mps -Fnone"
else	# Make animated GIF
	opt="-A"
fi	
# 1. Create files needed in the loop
cat << EOF > pre.sh
	gmt math -T0/360/10 T 180 ADD = angles.txt
	gmt makecpt -Crainbow -T500/4500 > main.cpt
EOF
# 2. Set up the main frame script
cat << EOF > main.sh
gmt begin
	width=\`gmt math -Q \${GMT_MOVIE_WIDTH} 0.5i SUB =\`
	gmt grdimage @tut_relief.nc -I+a\${GMT_MOVIE_VAL1}+nt2 -JM\${width} -Cmain.cpt \
		-BWSne -B1 -X0.35i -Y0.3i -P --FONT_ANNOT_PRIMARY=9p
	gmt psxy -Sc0.8i -Gwhite -Wthin <<< "256.25 35.6" 
	gmt psxy -Sv0.1i+e -Gred -Wthick <<< "256.25 35.6 \${GMT_MOVIE_VAL2} 0.37i" 
gmt end
EOF
# 3. Run the movie
gmt movie main.sh -C3.5ix4.167ix72 -Nanim_02 -Tangles.txt -Sbpre.sh -D6 -Z $opt
rm -rf main.sh pre.sh
