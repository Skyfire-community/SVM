/*
12 disk cutters change tool macro program
Modified by: JOSH HANDEL
Date of repair: 2019.02.10
IO configuration
Output point configuration:

OUT10 Power Draw bar
OUT08 Extend ATC
OUT09 Return ATC
OUT07 ATC CCW
OUT06 ATC CW
OUT55 Spindle Orientation Enable
OUT54 Spindle Enable

Input point configuration:

IN07 spindle orient complete
IN13 ATC Index Sensor
      Tool magazine zero signal
IN12 Power Drawbar Sensor
      Tight knife completion signal
IN14 ATC Extended
IN15 ATC Retracted

System parameter definition:
#200 Target Tool Number 
#201 Current tool number 
#500 Current tool slot
#501 max tool slot
#4120 Current tool number in the system
#400 The number of system tools set should be equal to the magazine capacity.
#403 Tool change height
#404 Tool magazine movement safety height
#405 Tool change fast speed
#406 Tool change slow speed
#3000 System prompt information display

Tool change coordinate system: G599
*/

O0123

#501 = 12 (Skyfire SVM2 has 12 tool slots)

IF[#1855==1] THEN #3006=1(WARNING:ATC DEBUG ENABLED!)

#201=#4120

IF[#201 LE #501] THEN #500 = #201 (Set the current tool slot in the umbrella to the current tool if the current tool is within the tool capacity)


IF[[#200] == 0] THEN #3000=1(ERROR:Target Tool # 0 ERROR!)

IF[[#200] == #201] GOTO 100 (the target tool number is equal to the current tool number to exit the tool change program)

IF[[[#200] > [#400]] || [[#201] > [#400]]] THEN #3000=1(ERROR:Target Tool # > System Volume!)

IF[#201==0] THEN #3000=1(ERROR:Current Tool #=0 ERROR!)

M09 (close cooling)
G90 G599  G1 Z#403 F#405 (Move to the tool change height using the G599 coordinate system Z)

M89 P54 L1 (spindle forward rotation output)
M89 P55 L1 (spindle directional output)

#1013=0 (The number of knife counts is cleared)

#101=0
WHILE[#1007!=0] DO1  (detects the spindle to stop IN07 for more than 10 seconds)
      IF[#101>1000]THEN #3000=1(ERROR:Spindle orientation timed out!)
      G04 P10
      #101=#101+1
END1

IF[[#201]==0] GOTO 200(The spindle has a tool currently in it)
      IF[#201 GT #501] GOTO 210
            M98 P9701
            M98 P9702
            G599 Z#404 F#405 (Moving to a safe height to prepare for the target tool)
            GOTO 290
      N210 (current tool doesn't use the umbrella)
            #3006=1(Remove the current tool from the spindle and press "start" to continue)
            M00
            G599 Z#404 F#405 (Moving to a safe height to prepare for the target tool)
            IF[#200 GT #501] THEN GOTO 220
                  M98 P9701
                  M98 P9702
            N220 (next tool is not using the umbrella)
                  GOTO 290

N200 (no tool in spindle)
      #3006=1(Please Confirm there is no tool in the spindle and press "Start" to continue)
      M00
      IF[#200 GT #501] THEN GOTO 300
            M98 P9701
            M98 P9702
N290
G04P10
#3006=1(Start Tool loading)
IF[#200 LE #501] THEN GOTO 300
      IF[#500 GT #501] THEN GOTO 310
            M98 P9703
            M98 P9704
      N310 (Next tool does not use the umbrella)
            #3006=1(Please install the next tool and press "Start" to continue)
            M00
            GOTO 100 (we are done with this tool change)
N300 (Use the umbrella for the next tool)
      #1=0
      #2=#500 (current tool location)
      #3=#200-#2 (steps to move forward or backwards)
      #4=#501/2 (half way mark on the tool holder)

      IF[#3 GE #4] GOTO 315
            IF[#3 LE [#4*-1]] THEN #3 = #3 + #501  (do we need to move more than half the distance --)
            GOTO 316
      N315
            #3 = #3-#501  (do we need to move more than half the distance ++)
      N316

      IF[#3 LT 0] THEN GOTO 320
            #3006=1("going forward")     
            #1=1 (decrement tool holder for each pulse)
            GOTO 330
      N320 (Go backwards)
            IF [#3 EQ 0] GOTO 330
            #3006=1("going backwards")
            #1=-1 (increment the tool holder each pulse)
N330
      IF[#3 EQ 0] GOTO 340
N345
      #11 = 1 (Singal we are looking for)
      #12 = 0 (times found, we will look for it multiple times)
      #13 = 0 (flag for finding both high and low signals)
      IF[#1 > 0] GOTO 350
            M89 P07 L1 (turn off forwards/backwards pin settings)
            GOTO 355
      N350
            M89 P06 L1 (turn off forwards/backwards pin settings)
      N355
      (jacked up loop that is crazy sause because for some reasons I can't put a loop inside here with out bad juju)
      WHILE[#2 NE #200] DO1 (when the current tool is not yet a command tool)
            #3006=1(Start tool move)
            IF[#1013==#11] GOTO 1010 (did we find our target signal)
                  #12 = 0 (no then reset our counter, we might have had a jitter)
                  G04 P1 (tiny breather)
                  GOTO 1099 (back into the loop of doom)
            N1010
                  #12 = #12 + 1 (yes we found our signal, lets count it)
                  G04 P1 (and wait a moment)
            IF[#12 NE 2] GOTO 1099 (back into the loop of doom if we only heard the signal once)
            IF[#11 EQ 0] GOTO 1050 (we were looking for low signal, that means we have changed tools)
                  #11 = 0 (we just found a high signal, now to start looking low)
                  #12 = 0 (reset our counter for the low signal loop)
                  GOTO 1099 (return to the loop of doom)
            N1050
                  #13 = 1 (we found our low signal, means we are ready to count this as a moved tool)

            IF[#13 EQ 0] GOTO 1099 (we probably don't need this if looking at the flow, but hey lets be safe)
                  #2 = #2+#1 (increment tool location)       
                  IF[#2>#501] THEN #2=1  (moved all the way around the umbrells (13 becomes 1)
                  IF[#2<=0] THEN #2=#501 (moved all the way around the umbrells, (0 becomes 12)
                  #500 = #2 (set our tool holder location so we don't loose it)
                  #11 = 1 (reset for a new loop)
                  #12 = 0 (reset for a new loop)
                  #13 = 0 (reset for a new loop)
                  #3006=1(tool moved)
            N1099
      END1
N340
      M89 P06 L0 (turn off forwards/backwards pin settings)
      M89 P07 L0 (turn off forwards/backwards pin settings)

      G04 P100  (delay to make sure everything has stopped with a small delay)
      G1 Z#403 F#406 (Z moves to tool change height)
      G04 P100 (delay to make sure everything has stopped with a small delay)
      M98 P9704
      G04 P100
      M98 P9703
N100
M89 P54 L0 (turn off the spindle forward port)
M89 P55 L0 (turn off the spindle positioning port)
#3006=1(Tool Change completed)
M30

O9701(Extend Umbrella)
#3006=1(Extend Umbrella Start)
M89 P09 L0
M89 P08 L1 (extend tool umbrella to install current tool)
#101=0
WHILE[#1014!=0] DO1 (detects tool umbrella is extended or times out)
      IF[#101>1000] THEN #3000=1(ERROR:Tool umbrella extention timed out)
      G04P10
      #101=#101+1
      END1
G04 P300  (delayed for 0.3 seconds)
#3006=1(Extend Umbrella End)
M99

O9702(Release Drawbar)
#3006=1(Release Drawbar Start)
M89 P10 L1 (release current tool from power drawbar)
#101=0
WHILE[#1012!=0] DO1 (detects the action of the knife cylinder in-position signal IN12 for more than 3 seconds)
      IF[#101>300]THEN #3000=1(ERROR:Power draw bar opening timed out)
      G04P10
      #101=#101+1
END1
G04 P100 (delay 0.1 seconds to ensure sufficient delay to fully release the shank)
#3006=1(Release Drawbar End)
M99

O9703 (Retract Umbrella)

#3006=1(Retract Umbrella Start)
M89 P08 L0
M89 P09 L1  (retract the umbrella)
#101=0
WHILE[#1015 NE 0] DO1 (wait for the tool changer umbrella to retract completely)
      IF[#101>1000] THEN #3000=1(ERROR:Tool umbrella retraction timed out)
      G04 P10
      #101=#101+1
END1
G04 P300  (delayed for 0.3 seconds)
#3006=1(Retract Umbrella End)
M99

O9704(Close Power drawbar)
#3006=1(Close Powerbar Start)
M89 P10 L0 (close power drawbar)
#101=0
WHILE[#1012==0] DO1 (wait to confirm the power drawbar has closed)
      IF[#101>300]THEN #3000=1(ERROR:Power draw bar closing timed out)
      G04P10
      #101=#101+1
END1
G04 P300  (delayed for 0.3 seconds)
#3006=1(Close Powerbar End)
M99
%