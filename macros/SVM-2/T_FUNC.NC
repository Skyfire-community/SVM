
/*
12 disk cutters change tool macro program
Modified by: SKYFIRE
Date of repair: 2017.12.02
IO configuration
Output point configuration:

OUT 10 elastic knife cylinder
OUT 08 tool magazine is introduced to the tool change position
OUT 09 magazine returns to standby
OUT 07 magazine reversal
OUT 06 tool magazine forward
OUT 31 Spindle Orientation Enable

Input point configuration:

IN 07 spindle quasi-stop completion
IN 13 knife position counting signal
      Tool magazine zero signal
IN 12 knife completion signal
      Tight knife completion signal
IN14 cutter head pushes in place signal
IN15 Cutter Standby In Place Signal

System parameter definition:
#200 Target Tool Number Register
#201 Current tool number register
#4120 Current tool number in the system
#400 The number of system tools set should be equal to the magazine capacity.
#403 Tool change height
#404 刀库运动安全高度
#405 Tool change fast speed
#406 Tool change slow speed
#3000 System prompt information display

Tool change coordinate system: G599
*/

O0123
IF[#1855==1]
{
#3000=1(WARNING:ATC DEBUG ENABLED!)
}

#201=#4120

IF[[#200] == 0]
{
#3000=1(WARNING:Target Tool # 0 ERROR!)
GOTO 100
}

IF[[#200] == #201] GOTO 100 (the target tool number is equal to the current tool number to exit the tool change program)

IF[#400 > 12] (The maximum number of tools in the system cannot be greater than 12 magazine capacity)
{
#3000=1(WARNING:Set Tool Qty > ATC Capacity!)
}

IF[[[200] > [#400]] || [[#201] > [#400]]]
{
#3000=1(WARNING:Target Tool # > System Volume!)
}

IF[#201==0]
{
#3000=1(WARNING:Current Tool #=0 ERROR!)
}

M09 (close cooling)
G90 G599 G1 Z#403 F#405 (Move to the tool change height using the G599 coordinate system Z)


IF[[#201]!=0] (The spindle has a knife and a knife to the tool magazine)
{
M89 P30 L1 (spindle forward rotation output)
M89 P31 L1 (spindle directional output)

#1013=0 (The number of knife counts is cleared)

#101=0
WHILE[#1007!=0] DO2 (detects the spindle to stop IN07 for more than 10 seconds)
IF[#101>1000]THEN #3000=1(WARNING:IN07! Spindle Orientation Timeout!)
G04 P10
#101=#101+1
END2

M89 P09 L0
M89 P08 L1 (knife cylinder pushes the shank into the cutter head back to the library)

#101=0
WHILE[#1014!=0] DO20 (detects the cutter head to push the positioning signal IN14 for more than 10 seconds)
IF[#101>1000]THEN #3000=1(WARNING:IN14! Carousel to TCP Timeout!)
G04P10
#101=#101+1
END20

G04 P300 (delayed for 0.3 seconds)

M89 P10 L1 (cylinder tool holder and spindle release)

#101=0
WHILE[#1012!=0] DO30 (detects the action of the knife cylinder in-position signal IN12 for more than 3 seconds)
IF[#101>300]THEN #3000=1(WARNING:IN12! PDB Action Timeout!)
G04P10
#101=#101+1
END30

G04 P100 (delay 0.1 seconds to ensure sufficient delay to fully release the shank)
G599 Z#404 F#405 (Moving to a safe height to prepare for the target tool)
}

#1=0
IF[#201 > [#400/2]] GOTO 1 (The current tool number position is in the second half of the magazine, then the tool is being rotated)
IF[[#201 >= #200] || [#200 > [#201+[#400/2]]]] GOTO 2 (When the condition is met, the magazine is reversed to select the knife)
M89 P06 L1 (knife forward)
#1=0
GOTO 3
N2
M89 P07 L1 (The command tool number is smaller than the tool number reversed)
#1=1
GOTO 3
N1
IF[[#201 >= #200 && #200 <= #400] && [#200 > [#201+#400/2]MOD#400]] GOTO 4 (The knife number is greater than the command number. Reverse)
M89 P06 L1 (knife forward)
#1=0
GOTO 3
N4
M89 P07 L1 (tool magazine reversal)
#1=1
N3
#2=#201
WHILE[#2!=#200] DO1 (when the current tool is not yet a command tool)
M88 P13 L0
M88 P13 L1 (The tool position counts one pulse falling edge corresponding to one tool position signal)
IF[#1==1] GOTO 7 (reverse count processing)
#2 = #2+1 (forward rotation)
IF[#2>#400] #2=1   
GOTO 8
N7
#2 = #2-1 (reverse self-reduction)
IF[#2<=0] #2=#400
N8
END1

IF[#1==1] GOTO 5
M89 P06 L0 (See N3 for closing forward output)
GOTO 6
N5
M89 P07 L0 (close the reverse output see N4)
N6
M89 P09 L0
M89 P08 L1 (cutter cylinder release)

#101=0
WHILE[#1014!=0] DO22 (detects the cutter head to push the positioning signal IN14 for more than 10 seconds)
IF[#101>1000]THEN #3000=1(WARNING:IN14! Carousel to TCP Timeout!)
G04P10
#101=#101+1
END22

M89 P10 L1 (Spindle cylinder cutter release output needs to be inserted into the cutter sleeve in the loose knife state)
G04 P100 (knife guarantees enough delay)
G1 Z#403 F#406 (Z moves to tool change height)
G04 P100
M89 P10 L0 (cutter cylinder tensioning knife)

#101=0
WHILE[#1012==0] DO31 (Detects the action of the knife cylinder in-position signal IN12 for more than 3 seconds)
IF[#101>300]THEN #3000=1(WARNING:IN12! PDB Action Timeout!)
G04P10
#101=#101+1
END31

G04 P100

M89 P08 L0
M89 P09 L1 (cutter cylinder retracted)

#101=0
WHILE[#1015!=0] DO25 (detects the cutter head retraction positioning signal IN15 for more than 10 seconds)
IF[#101>1000]THEN #3000=1(WARNING:IN15! Carousel to STP Timeout!)
G04 P10
#101=#101+1
END25
M89 P30 L0 (turn off the spindle forward port)
M89 P31 L0 (turn off the spindle positioning port)
N100
M30
%