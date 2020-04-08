#! /usr/bin/env perl

use strict;
use File::Copy;

# my @files = split(/\n/, `ls -1d /projects/souris/psteadman/MRdata/reconstructed-fids/fse3dmice*.fid/`);
# 
# foreach(@files){
# 
# 	chdir($_);
# 	my @date = split(/\n/, `basename $_ .fid | cut -c16-`);
# 	do_cmd(qw(vrecon -vmap /projects/souris/psteadman/MRdata/vmap/fse_192_192_8_3
# 	-shiftppe2 -dc -scalefft -p), $_."/procpar", "fid", "img_".$date[0], qw(-clobber -verbose));
# 	my @images = split(/\n/, `ls -1 img*.mnc`);
# 	foreach(@images){
# 		copy($_,"/projects/souris/jurgen/LearnAndMem/live_imaging/native/") or die "copy failed";
# 		}	
# 	}

# my @files2 = split(/\n/, `ls -1d /projects/souris/psteadman/MRdata/t2w3dfse_livemice_lisa*.fid/`);
# 
# foreach(@files2){
# 
# 	chdir($_);
# 	my @date2 = split(/\n/, `basename $_ .fid | cut -c24-`);
# 	do_cmd(qw(vrecon -vmap /projects/souris/psteadman/MRdata/vmap/fsetable_feather_336_168_12_4
# 	-shiftppe2 -dc -scalefft -croplpe -p), $_."/procpar", "fid", "img_".$date2[0], qw(-clobber -verbose));
# 	my @images2 = split(/\n/, `ls -1 img*.mnc`);
# 	foreach(@images2){
# 		copy($_,"/projects/souris/jurgen/LearnAndMem/live_imaging/native/") or die "copy failed";
# 		}
# 	move($_,"/projects/souris/psteadman/MRdata/reconstructed-fids/") or die "move failed";	
# 	}

#my @filesA = split(/\n/, `ls -1d /projects/souris/psteadman/MRdata/t2w3dfse_livemice_V1*.fid/`);
#
#foreach(@filesA){
#
#	chdir($_);
#	my @dateA = split(/\n/, `basename $_ .fid | cut -c22-`);
#	do_cmd(qw(vrecon -vmap /projects/souris/psteadman/MRdata/vmap/fsetable_feather_336_168_12_4
#	-shiftppe2 -dc -scalefft -croplpe -p), $_."/procpar", "fid", "img_".$dateA[0], qw(-clobber -verbose));
#	my @imagesA = split(/\n/, `ls -1 img*.mnc`);
#	foreach(@imagesA){
#		copy($_,"/projects/souris/jurgen/LearnAndMem/live_imaging/native/") or die "copy failed";
#		}	
# 	move($_,"/projects/souris/psteadman/MRdata/reconstructed-fids/") or die "move failed";
#	}

my @filesB = split(/\n/, `ls -1d /projects/souris/psteadman/MRdata/t2w3dfse_livehead_V1*.fid/`);

foreach(@filesB){

	chdir($_);
	my @dateB = split(/\n/, `basename $_ .fid | cut -c22-`);
	do_cmd(qw(vrecon -vmap /projects/souris/psteadman/MRdata/vmap/fsetable_feather_336_168_12_4
	-shiftppe2 -dc -scalefft -croplpe -p), $_."/procpar", "fid", "img_".$dateB[0], qw(-clobber -verbose));
	my @imagesB = split(/\n/, `ls -1 img*.mnc`);
	foreach(@imagesB){
		copy($_,"/projects/souris/jurgen/LearnAndMem/live_imaging/native/") or die "copy failed";
		}	
 	move($_,"/projects/souris/psteadman/MRdata/reconstructed-fids/") or die "move failed";
	}

sub do_cmd{
	print "@_ \n";
	system(@_) == 0 or die "Dude must quit";
}