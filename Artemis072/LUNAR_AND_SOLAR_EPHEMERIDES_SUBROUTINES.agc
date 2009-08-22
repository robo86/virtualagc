### FILE="Main.annotation"
# Copyright:	Public domain.
# Filename:	LUNAR_AND_SOLAR_EPHEMERIDES_SUBROUTINES.agc
# Purpose:	Part of the source code for Artemis (i.e., Colossus 3),
#		build 072.  This is for the Command Module's (CM)
#		Apollo Guidance Computer (AGC), we believe for
#		Apollo 15-17.
# Assembler:	yaYUL
# Contact:	Jim Lawton <jim DOT lawton AT gmail DOT com>
# Website:	www.ibiblio.org/apollo/index.html
# Page scans:	www.ibiblio.org/apollo/ScansForConversion/Artemis072/
# Mod history:	2009-08-11 JL	Adapted from corresponding Comanche 055 file.

## Page 789

# LUNAR AND SOLAR EPHEMERIDES SUBROUTINES
#
# FUNCTIONAL DESCRIPTION
#
#	THESE SUBROUTINES ARE USED TO DETERMINE THE POSITION AND VELOCITY
#	VECTORS OF THE SUN AND THE MOON RELATIVE TO THE EARTH AT THE
#	SPECIFIED GROUND ELAPSED TIME INPUT BY THE USER.
#
#	THE POSITION OF THE MOON IS STORED IN THE COMPUTER IN THE FORM OF
#	A NINTH DEGREE POLYNOMIAL APPROXIMATION WHICH IS VALID OVER A 15
#	DAY INTERVAL BEGINNING SHORTLY BEFORE LAUNCH.  THEREFORE THE TIME
#	INPUT BY THE USER SHOULD FALL WITHIN THIS 15 DAY INTERVAL.
# 
##	The 9th-degree polynomial spoken of here is a pad load, meaning
##	that it is not actually hardcoded into the software.  Additional
##	information about calculating the polynomial can be found on the 
##	<a href="http://nassp.sourceforge.net/wiki/Lunar_Ephemeris_Polynomials">
##	<b>Orbiter</b> NASSP wiki</a>, as well as information about calculation
##	of the <a href="http://nassp.sourceforge.net/wiki/Solar_Ephemeris">
##	solar ephemerides</a>.
#
#	LSPOS COMPUTES THE POSITION VECTORS OF THE SUN AND THE MOON.
#
#	LUNPOS COMPUTES THE POSITION VECTOR OF THE MOON.
#
#	LUNVEL COMPUTES THE VELOCITY VECTOR OF THE MOON.
#
# CALLING SEQUENCE
#
#	DLOAD	CALL
#		TIME		GROUND ELAPSED TIME
#		SUBROUTINE	LSPOS OR LUNPOS OR LUNVEL
#
# INPUT
#
#	1) SPECIFIED GROUND ELAPSED TIME IN CS x B-28 LOADED IN MPAC.
#
#	2) TIMEMO - TIME AT THE CENTER OF THE RANGE OVER WHICH THE LUNAR
#	   POSITION POLYNOMIAL IS VALID IN CS x B-42.
#
#	3) VECOEM - VECTOR COEFFICIENTS OF THE LUNAR POSITION POLYNOMIAL
#	   LOADED IN DESCENDING SEQUENCE IN METERS/CS**N x B-2
#
#	4) RESO - POSITION VECTOR OF THE SUN RELATIVE TO THE EARTH AT
#	   TIMEMO IN METERS x B-38
#
#	5) VESO - VELOCITY VECTOR OF THE SUN RELATIVE TO THE EARTH AT
#	   TIMEMO IN METERS/CS x B-9
# 
#	6) OMEGAES - ANGULAR VELOCITY OF THE VECTOR RESO AT TIMEMO IN
#	   REV/CS x B+26.
#
#	ALL EXCEPT THE FIRST INPUT ARE INCLUDED IN THE PRE-LAUNCH
#	ERASABLE DATA LOAD.
#
# OUTPUT - LSPOS
#
#	1) 2D OF VAC AREA CONTAINS THE POSITION VECTOR OF THE SUN RELATIVE
## Page 790
#	   TO THE EARTH AT TIME INPUT BY THE USER IN METERS x B-38.
#
#	2) MPAC CONTAINS THE POSITION VECTOR OF THE MOON RELATIVE TO THE
#	   EARTH AT TIME INPUT BY THE USER IN METERS x B-29.
#
# OUTPUT - LUNPOS
#
#	MPAC CONTAINS THE POSITION VECTOR OF THE MOON RELATIVE TO THE
#	EARTH AT THE TIME INPUT BY USER IN METERS x B-29.
#
# OUTPUT - LUNVEL
#
#	MPAC CONTAINS THE VELOCITY VECTOR OF THE MOON RELATIVE TO THE
#	EARTH AT THE TIME INPUT BY THE USER IN METERS/CS x B-7.
#
# SUBROUTINES USED
#
#	NONE
#
# REMARKS
#
#	THE VAC AREA IS USED FOR STORAGE OF INTERMEDIATE AND FINAL RESULTS
#	OF COMPUTATIONS.
#
#	S1, X1, AND X2 ARE USED BY THESE SUBROUTINES.
#	PRELAUNCH ERASABLE DATA LOAD ARE ONLY ERASABLE STORAGE USED BY
#	THESE SUBROUTINES.
#	RESTARTS DURING OPERATION OF THESE SUBROUTINES MUST BE HANDLED BY
#	THE USER.

		SETLOC	EPHEM
		BANK
		
		COUNT*	$$/EPHEM
		EBANK=	WHOCARES
LSPOS		AXT,1	GOTO
			RES		# AREA.  THE POSITION VECTOR OF THE MOON
			LSTIME		# IS STORED IN MPAC.
LUNPOS		AXT,1	GOTO		# COMPUTES THE POSITION VECTOR OF THE MOON
			REM		# AND STORES IT IN MPAC.
			LSTIME
LUNVEL		AXT,1
			VEM		# AND STORES IT IN MPAC.
LSTIME		SETPD	SR
			0D
			14D
		TAD	DCOMP
			TEPHEM
		TAD	DCOMP
			TIMEMO
## Page 791
		SL	SSP
			16D
			S1
			6D
		GOTO
			X1
RES		PUSH	DMP		#					PD- 2
			OMEGAES
		PUSH	COS		#					PD- 4
		VXSC	PDDL		#					PD- 8
			RESO	
		SIN	PDVL		#					PD-10
			RESO
		PUSH	UNIT		#					PD-16
		VXV	UNIT
			VESO
		VXV	VSL1		#					PD-10
		VXSC	VAD		#					PD-02
		VSL1	
RESA		STODL	2D		# RES IN METERS x B-38 IN 2D OF VAC.	PD- 0
REM		AXT,1	PDVL		#					PD- 2
			54D
			VECOEM
REMA		VXSC	VAD*
			0D
			VECOEM +60D,1
		TIX,1	VSL2		# REM IN METERS x B-29 IN MPAC.
			REMA
		RVQ
VEM		AXT,1	PDDL		#					PD- 2
			48D
			NINEB4
		PUSH	VXSC		#					PD- 4
			VECOEM
VEMA		VXSC
			0D
		STODL	4D		#					PD- 2
		DSU	PUSH		#					PD- 4
			ONEB4
		VXSC*	VAD
			VECOEM +54D,1
			4D
		TIX,1	VSL2		# VEM IN METERS/CS x B-7 IN MPAC.
			VEMA
		RVQ
NINEB4		2DEC	9.0 B-4

ONEB4		EQUALS	DP2(-4)		# 1 B-4
