Enter quarantine 
. /projects/mice/share/arch/linux64/quarantine_how_old/environment

MICe-build-model.pl -sge \
-pipeline-name invivo-23jun10 \
-pipeline-base /projects/souris/psteadman/in-vivo-buildmodel/plbase23jun10/ \
-bootstrap-model /projects/souris/psteadman/in-vivo-buildmodel/native23jun10 \
-no-lsq6-large-rotations \
-downsampling-factor 1 \
-lsq12 \
-nlin-partial \
/projects/souris/jurgen/LearnAndMem/live_imaging/native/*.mnc

MICe-build-model.pl -sge \
-pipeline-name invivo-25jun10 \
-pipeline-base /projects/souris/psteadman/in-vivo-buildmodel/in-vivo-plbase/ \
-init-model /projects/souris/psteadman/in-vivo-buildmodel/manual-transform/make-init-model/native-model \
-no-lsq6-large-rotations \
-downsampling-factor 1 \
-lsq12 \
-nlin-protocol nlin-config.pl -nlin -nlin-stats \
-no-resample-atlas -no-registration-accuracy \
/projects/souris/jurgen/LearnAndMem/live_imaging/native/*.mnc 

*********************Creating mask/model for in-vivo mice*********************

************Step1:************
<MICe-build-model> on in-vivo images with new model 
MICe-build-model.pl -sge \
-pipeline-name invivo-25jun10 \
-pipeline-base /projects/souris/psteadman/in-vivo-buildmodel/in-vivo-plbase/ \
-init-model /projects/souris/psteadman/in-vivo-buildmodel/manual-transform/make-init-model/native-model \
-no-lsq6-large-rotations \
-downsampling-factor 1 \
-lsq12 \
-nlin-protocol nlin-config.pl -nlin -nlin-stats \
-no-resample-atlas -no-registration-accuracy \
/projects/souris/jurgen/LearnAndMem/live_imaging/native/*.mnc 
Inputs:
-nlin-protocol                File containing the nonlinear fitting procotocol.
  This was copied over from jurgen's folder into mine. Not sure what the function is.
-nlin                         Run full series non-linear fitting steps
-nlin-stats                   Create volumes for analysis of deformation fields.
-init-model                   Initial model to register towards (we specified this and it is a directory)
-resample-atlas               Resample the classified atlas to the final non-linear model. [default]
-no-resample-atlas            opposite of -resample-atlas
-registration-accuracy        Perform a registration accuracy test on the pipeline. [default]
-no-registration-accuracy     opposite of -registration-accuracy
-classified-atlas             The classified atlas used for the
                                 atlas-to-atlas resampling [default:
                                 /projects/mice/jlerch/water-maze/200704/atlas
                                 -registration/c57bl6_atlas_on_mwm_full_size_f
                                 ixed.mnc]
  Will probably use this with the path to in-vivo atlas once I am finished painting


MINCANTS - ATLAS RESAMPLE STEPS - eventually write this in to a simple short script
*********************
sge_batch -J mdl-to-nlin5 mincANTS 3 -m PR[/projects/souris/psteadman/in-vivo-atlas/in-vivo-model.mnc,/projects/souris/psteadman/in-vivo-buildmodel/in-vivo-plbase/invivo-15jul10_nlin/nlin-5.mnc,1,5] -t SyN[0.25] -r Gauss[2,0.5] -i 100x80x70x20 -x ../../../model-registration-mincANTS/in-vivo-model-mask.mnc -o mdl-to-nlin5-july15.xfm
**********************
mincresample label-in-vivo-5.mnc \
     15jul10-nlin5atlas.mnc -transform mdl-to-nlin5-july15.xfm -like \
     ../invivo-15jul10_nlin/nlin-5.mnc -keep_real_range -nearest_neighbour
**********************
mincconvert -2 atlas-15jul10-nlin5.mnc \
     tmp.mnc

**********************
mv tmp.mnc atlas-15jul10-nlin5.mnc
