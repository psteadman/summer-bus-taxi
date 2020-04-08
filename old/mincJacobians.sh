#!/bin/bash

cd /projects/souris/psteadman/in-vivo-buildmodel/in-vivo-plbase/mincANTS-15jul10_long
for file in /projects/souris/psteadman/in-vivo-buildmodel/in-vivo-plbase/mincANTS-15jul10_long/img_*_mincANTS_inverse_grid_0.mnc; do base=`basename $file .mnc`; echo sge_batch -J jacobians-${base} mincJacobiansinside.sh $file $base; sge_batch -J jacobians-${base} mincJacobiansinside.sh $file $base; done

cd /projects/souris/psteadman/in-vivo-buildmodel/in-vivo-plbase/mincANTS-15jul10
for file in /projects/souris/psteadman/in-vivo-buildmodel/in-vivo-plbase/mincANTS-15jul10/img_*_mincANTS_inverse_grid_0.mnc; do base=`basename $file .mnc`; echo sge_batch -J jacobians-${base} mincJacobiansinside.sh $file $base;sge_batch -J jacobians-${base} mincJacobiansinside.sh $file $base;
done