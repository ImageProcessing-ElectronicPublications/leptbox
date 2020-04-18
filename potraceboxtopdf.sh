#!/bin/sh
# potraceboxtopdf.sh
# Depends: graphicsmagick, potrace, ghostscript, texlive-extra-utils, pdftk

tnocomp=""
tcomp="gm"; [ $(which $tcomp) ] || tnocomp="$tnocomp $tcomp"
tcomp="potrace"; [ $(which $tcomp) ] || tnocomp="$tnocomp $tcomp"
tcomp="ps2pdf"; [ $(which $tcomp) ] || tnocomp="$tnocomp $tcomp"
tcomp="pdfcrop"; [ $(which $tcomp) ] || tnocomp="$tnocomp $tcomp"
tcomp="pdftk"; [ $(which $tcomp) ] || tnocomp="$tnocomp $tcomp"
if [ "x$tnocomp" != "x" ]
then
    echo "Not found $tnocomp !"
    echo ""
    exit 0
fi

ti="$1"; tf="$2"; td="$3"; to="$4"; tiw="0"; tih="0"
if [ "x$0" != "x--help" ] && [ -f "$ti" ] && [ -f "$tf" ] &&  [ "$td" -gt 0 ]
then
    if [ "x$to" = "x" ]
    then
        to="$ti.pdf"
    fi
    cat "$tf" | while read tline
    do
        tn=$(echo "$tline" | cut -d\, -f1)
        tx=$(echo "$tline" | cut -d\, -f2)
        ty=$(echo "$tline" | cut -d\, -f3)
        tw=$(echo "$tline" | cut -d\, -f4)
        th=$(echo "$tline" | cut -d\, -f5)
        if [ "x$tn" = "x00000000" ]
        then
            tiw="$tw"
            tih="$th"
        else
            gm convert -verbose -crop "${tw}x${th}+${tx}+${ty}" +repage "$ti" "$tn.pbm"
            potrace -r "${td}" -e -o "$tn.eps" "$tn.pbm" && rm -fv "$tn.pbm"
            ps2pdf "$tn.eps" "$tn.pdf" && rm -fv "$tn.eps"
            mgl=$(echo "${tx}*7200/${td}*0.01" | bc)
            mgt=$(echo "${ty}*7200/${td}*0.01" | bc)
            mgr=$(echo "(${tiw}-${tx}-${tw}-1)*7200/${td}*0.01" | bc)
            mgb=$(echo "(${tih}-${ty}-${th}-1)*7200/${td}*0.01" | bc)
            pdfcrop --margins "${mgl} ${mgt} ${mgr} ${mgb}" "$tn.pdf" "$tn.m.pdf" && mv -fv "$tn.m.pdf" "$tn.pdf"
            if [ -f "$to" ]
            then
                pdftk "$to" stamp "$tn.pdf" output "$to.$$.pdf" && mv -fv "$to.$$.pdf" "$to" && rm -fv "$tn.pdf"
            else
                mv -fv "$tn.pdf" "$to"
            fi
        fi
    done
else
    echo "Usage: $0 image box.file DPI [outfile]"
fi
