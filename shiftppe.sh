#!/bin/bash


mincresample -coronal -nearest -clobber $1 1c.mnc
mincreshape -start 0,0,0 -count 35,280,168 -clobber 1c.mnc p1.mnc
mincreshape -start 35,0,0 -count 133,280,168 -clobber 1c.mnc p2.mnc
mincconcat -filestarts 0,21.0 p2.mnc p1.mnc 1c.mnc -clobber
mincreshape -dimorder xspace,yspace,zspace -clobber 1c.mnc $1
rm 1c.mnc
rm p1.mnc
rm p2.mnc
