#!/usr/bin/env python

import commands # removed in python version 3
import subprocess
import string
from numpy import *
from subprocess import call

import os, glob
from optparse import OptionParser

if __name__ == "__main__":
	usage = 'usage: %prog image.mnc'
	parser = OptionParser(usage=usage)
	
	(opts, args) = parser.parse_args()
	image = args[0]
#	startx_str = 'mincinfo -attval xspace:start %s' %image
#	startx = commands.getoutput(startx_str)
#	starty_str = 'mincinfo -attval yspace:start %s' %image
#	starty = commands.getoutput(starty_str)
#	startz_str = 'mincinfo -attval zspace:start %s' %image
#	startz = commands.getoutput(startz_str)
	stepx_str = 'mincinfo -attval xspace:step %s' %image
	stepx = commands.getoutput(stepx_str)
	stepy_str = 'mincinfo -attval yspace:step %s' %image
	stepy = commands.getoutput(stepy_str)
	stepz_str = 'mincinfo -attval zspace:step %s' %image
	stepz = commands.getoutput(stepz_str)
#	lengthx_str = 'mincinfo -attval xspace:length %s' %image
#	lengthx = commands.getoutput(lengthx_str)
#	lengthy_str = 'mincinfo -attval yspace:length %s' %image
#	lengthy = commands.getoutput(lengthy_str)
#	lengthz_str = 'mincinfo -attval zspace:length %s' %image
#	lengthz = commands.getoutput(lengthz_str)
#	adjustx = float(lengthx)*float(stepx)
#	adjusty = float(lengthy)*float(stepy)
#	adjustz = float(lengthz)*float(stepz)
	print 'steps are x=%s y=%s z=%s' % (stepx, stepy, stepz)
#	print 'starts are x=%s y=%s z=%s' % (startx, starty, startz)
	
	if (stepz >= '0'):
#		newstartx = float(startx) - adjustx
#		newstarty = float(starty) - adjusty
#		newstartz = float(startz) - adjustz
#		newstepx = float(stepx)*-1
		newstepz = float(stepz)*-1
#		newstepz = float(stepz)*-1
#		modify_str = 'minc_modify_header -dinsert xspace:step=%s -dinsert yspace:step=%s -dinsert zspace:step=%s -dinsert xspace:start=%s -dinsert yspace:start=%s -dinsert zspace:start=%s %s' % (newstepx, newstepy, newstepz, newstartx, newstarty, newstartz, image)
		modify_str = 'minc_modify_header -dinsert zspace:step=%s %s' % (newstepz, image)
		p = commands.getoutput(modify_str)
		print 'new steps are x=%s y=%s z=%s' % (stepx, stepy, newstepz)
	else:
		print 'no modification to %s' %image