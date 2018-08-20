
/*
M code macro program
Modified by: SKYFIRECNC
Date of repair: 2017.12.09

The OXX number represents the corresponding MXX code; the #14XX code represents the output port OUTXX; the #10XX code represents the input port INXX

Additional panel M22M23 Spindle blower using OUT20
Additional panel M16, M17 magazine initialization
Additional panel M24, M25 row swarf using OUT15
The additional panel F0 is defined as the first and second spindle switches, and the control OUT13 is the electric spindle pump control.
Additional panel F1 The second spindle rotates forward, F2 The second spindle reverses, corresponding to M code M303, M304, M305
Additional panel F3 spray cooling using OUT21
Additional panel F4 center water, external water spray switch to use OUT14
*/

O0007
(spray open M07 OUT21)
#2=1400+21
##2=1
#1858=1 (F3 output light on)
M3000
%

O0008
(cooling open M08)
#1=#10044 (Cooling output port in port configuration)
#2=1400+#1
##2=1
M3000
%

O0009
(cooling off M09)
#1=#10044 (Cooling output port in port configuration)
#2=1400+#1
##2=0
#1421=0 (spray output off)
#1858=0 (F3 output light off)
M3000
%

O0010
(Jig open OUT22)
#2=1400+22
##2=1
#1849=1
M3000
%

O0011
(Jig off OUT22)
#2=1400+22
##2=0
#1849=0
M3000
%

O0012
(Lighting on OUT16)
#2=1400+16
##2=1
#1852=1
M3000
%
O0013
(lighting off OUT16)
#2=1400+16
##2=0
#1852=0
M3000
%

O0014
(Cutter cylinder open OUT10)
#1=#3918 (Determination of spindle status allows the tool cylinder to operate if the spindle is stopped)
#2=1400+10
IF[#1==0]
{
##2=1
#1854=1
#1434=1 (The external emergency stop of the inverter prevents the knife from starting the spindle)
}
ELSE
{
#3000=1(Can Not Realse Tool When Spindle Rotating)
##2=0
#1854=0
}
M3000
%
O0015
(Cutter cylinder closed OUT10)
#2=1400+10
##2=0
#1434=0 (Turn off the external emergency stop of the inverter)
#1854=0
M3000
%

O0016
(The magazine status is initialized)
#1=1408
#2=1409
#1855=1
#1410=0 (knives and broaches)
G04 P500
##1=0
##2=1 (Tool library back to STP position)

WHILE[#1015==1]DO1 (waiting for standby bit signal ON)
END1
M5
#1431=0
#1855=0
M3000
%

O0017
(Tool library status initialization off)

#1855=0
M3000
%

O0018
(Position forward + open OUT06)
#2=1400+6
##2=1
#1856=1
WHILE[#1013==1]DO1 (waiting for the knife signal OFF)
END1
WHILE[#1013==0]DO1 (waiting for the knife signal ON)
END1
##2=0 (turn off the output)
#200=#4120+1
IF[#200>#400]
{
#200=#200-#400
}
#4120=#200
#1856=0 (turn off the LED)
M3000
%

O0019
(Tool position forward + OFF OUT06)
#2=1400+6
##2=0
#1856=0
M3000
%

O0020
(Tool position reversal - open OUT07)
#2=1400+7
##2=1
#1857=1
WHILE[#1013==1]DO1 (waiting for the knife signal OFF)
END1
WHILE[#1013==0]DO1 (waiting for the knife signal ON)
END1
##2=0 (turn off the output)
#200=#4120-1
IF[#200<1]
{
#200=#200+#400
}
#4120=#200
#1857=0 (turn off the LED)
M3000
%
O0021
(Tool position reversal - OFF OUT07)
#2=1400+7
##2=0
#1857=0
M3000
%

O0022
(膛 blowing - open OUT20)
#2=1400+20
##2=1
#1860=1
M3000
%
O0023
(膛 blowing - off OUT20)
#2=1400+20
##2=0
#1860=0
M3000
%

O0024
(chip discharge open OUT15)
#2=1400+15
##2=1
#1862=1
M3000
%
O0025
(chip discharge off OUT15)
#2=1400+15
##2=0
#1862=0
M3000
%

O0032
(Lubrication open M32)
#1=#10043 (Port configuration lubrication output port)
#2=1400+#1
##2=1
M3000
%
O0033
(Lubrication off M33)
#1=#10043 (Port configuration lubrication output port)
#2=1400+#1
##2=0
M3000
%

O0040
(F0 first second spindle switch open OUT5, second spindle cool open OUT13)
#1=1400+13
##1=1
#2=1400+5
##2=1
#1843=1
M3000
%
O0041
(F0 first second spindle switch off OUT5, second spindle cool off OUT13)
#1=1400+13
##1=0
#2=1400+5
##2=0
#1843=0
M3000
%

O0042
(F1 second spindle forward rotation)
IF [#3906==2]||[#3906==3]
{
  #1=#5115 (spindle status)
  #2=#5113 (spindle speed)
IF[#1==0]
  {
    M103S#2
    #1853=0
    #1848=1
   }
ELSE
{
   M105
   #1853=0
   #1848=0
}
}
M3000
%

O0043
(F1 second spindle forward rotation)
IF [#3906==2]||[#3906==3]
{
  #1=#5115 (spindle status)
  #2=#5113 (spindle speed)
IF[#1==0]
  {
    M103S#2
    #1853=0
    #1848=1
   }
ELSE
{
   M105
   #1853=0
   #1848=0
}
}
M3000
%

O0044
(F2 second spindle reverse)
IF [#3906==2]||[#3906==3]
{
  #1=#5115 (spindle status)
  #2=#5113 (spindle speed)
IF[#1==0]
  {
    M104S#2
    #1848=0
    #1853=1
   }
ELSE
{
   M105
   #1853=0
   #1848=0
}
}
M3000
%

O0045
(F2 second spindle reverse)
IF [#3906==2]||[#3906==3]
{
  #1=#5115 (spindle status)
  #2=#5113 (spindle speed)
IF[#1==0]
  {
    M104S#2
    #1848=0
    #1853=1
   }
ELSE
{
   M105
   #1853=0
   #1848=0
}
}
M3000
%

O0046
(F3 spray cooling on OUT21)
#2=1400+21
##2=1
#1858=1
M3000
%
O0047
(F3 spray cooling off OUT21)
#2=1400+21
##2=0
#1858=0
M3000
%

O0048
(F4 center water switch to open OUT14)
#2=1400+14
##2=1
#1863=1
M3000
%
O0049
(F4 center water outlet OUT14)
#2=1400+14
##2=0
#1863=0
M3000
%


O0303
(the second spindle is rotating forward)
M103
#1853=0
#1848=1
M3000
%

O0304
(second spindle reversal)
M104
#1848=0
#1853=1
M3000
%

O0305
(the second spindle stops)
M105
#1848=0
#1853=0
M3000
%

(**********************)
O203 
(panel spindle forward)
#1=#3918 (spindle status)
#2=#4118 (spindle speed)
IF[#1==0]
{
M03S#2
}
ELSE
{
M05
}
M3000
%
O204
(panel spindle inversion)
#1=#3918(#3918 Spindle Status)
#2=#4118(#4118 Spindle speed)
IF[#1==0]
{
M04S#2
}
ELSE
{
M05
}
M3000
%
O205
(panel spindle stop)
M05
M3000
%

O208
(panel cooling on)
#1=#10044 (port configuration cooling output port)
#2=1400+#1
##2=1
#1810=1(LED light)
#1861=1(additional panel LED light)
M3000
%
O209
(panel cooling off)
#1=#10044 (port configuration cooling output port)
#2=1400+#1
##2=0
#1810=0(LED light)
#1861=0(additional panel LED light)
M3000
%

O212
(panel lubrication on)
#1=#10043 (Port configuration lubrication output port)
#2=1400+#1
##2=1
#1811=1(LED light)
#1859=1 (additional panel LED light)
M3000
%
O213
(panel lubrication off)
#1=#10043 (Port configuration lubrication output port)
#2=1400+#1
##2=0
#1811=0(LED light)
#1859=0(additional panel LED light)
M3000
%
O3001
IF[#1926 == 0]
{ 
#1926 = 1
#3006 = 1(1926=1)
}
ELSE
{
#1926 = 0
#3006 = 1(1926=0)
}
M3000
%
O3002
IF[#1927 == 0]
{ 
#1927 = 1
#3006 = 1(1927=1)
}
ELSE
{
#1927 = 0
#3006 = 1(1927=0)
}
M3000
%
O3003
IF[#1928 == 0]
{ 
#1928 = 1
#3006 = 1(1928=1)
}
ELSE
{
#1928 = 0
#3006 = 1(1928=0)
}
M3000
%
O3004
IF[#1929 == 0]
{ 
#1929 = 1
#3006 = 1(1929=1)
}
ELSE
{
#1929 = 0
#3006 = 1(1929=0)
}
M3000
%
O3005
IF[#1930 == 0]
{ 
#1930 = 1
#3006 = 1(1930=1)
}
ELSE
{
#1930 = 0
#3006 = 1(1930=0)
}
M3000
%
O3006
IF[#1931 == 0]
{ 
#1931 = 1
#3006 = 1(1931=1)
}
ELSE
{
#1931 = 0
#3006 = 1(1931=0)
}
M3000
%
O3007
IF[#1932 == 0]
{ 
#1932 = 1
#3006 = 1(1932=1)
}
ELSE
{
#1932 = 0
#3006 = 1(1932=0)
}
M3000
%
O3008
IF[#1933 == 0]
{ 
#1933 = 1
#3006 = 1(1933=1)
}
ELSE
{
#1933 = 0
#3006 = 1(1933=0)
}
M3000
%
O3009
IF[#1934 == 0]
{ 
#1934 = 1
#3006 = 1(1934=1)
}
ELSE
{
#1934 = 0
#3006 = 1(1934=0)
}
M3000
%
O3010
IF[#1935 == 0]
{ 
#1935 = 1
#3006 = 1(1935=1)
}
ELSE
{
#1935 = 0
#3006 = 1(1935=0)
}
M3000
%
O3011
IF[#1936 == 0]
{ 
#1936 = 1
#3006 = 1(1936=1)
}
ELSE
{
#1936 = 0
#3006 = 1(1936=0)
}
M3000
%
O3012
IF[#1937 == 0]
{ 
#1937 = 1
#3006 = 1(1937=1)
}
ELSE
{
#1937 = 0
#3006 = 1(1937=0)
}
M3000
%
O3013
IF[#1938 == 0]
{ 
#1938 = 1
#3006 = 1(1938=1)
}
ELSE
{
#1938 = 0
#3006 = 1(1938=0)
}
M3000
%
O3014
IF[#1939 == 0]
{ 
#1939 = 1
#3006 = 1(1939=1)
}
ELSE
{
#1939 = 0
#3006 = 1(1939=0)
}
M3000
%
O3015
IF[#1940 == 0]
{ 
#1940 = 1
#3006 = 1(1940=1)
}
ELSE
{
#1940 = 0
#3006 = 1(1940=0)
}
M3000
%
O3016
IF[#1941 == 0]
{ 
#1941 = 1
#3006 = 1(1941=1)
}
ELSE
{
#1941 = 0
#3006 = 1(1941=0)
}
M3000
%
O3017
IF[#1942 == 0]
{ 
#1942 = 1
#3006 = 1(1942=1)
}
ELSE
{
#1942 = 0
#3006 = 1(1942=0)
}
M3000
%
O3018
IF[#1943 == 0]
{ 
#1943 = 1
#3006 = 1(1943=1)
}
ELSE
{
#1943 = 0
#3006 = 1(1943=0)
}
M3000
%
O3019
IF[#1944 == 0]
{ 
#1944 = 1
#3006 = 1(1944=1)
}
ELSE
{
#1944 = 0
#3006 = 1(1944=0)
}
M3000
%
O3020
IF[#1945 == 0]
{ 
#1945 = 1
#3006 = 1(1945=1)
}
ELSE
{
#1945 = 0
#3006 = 1(1945=0)
}
M3000
%

O2217
(before tapping)
IF[#5165 == 0]
{
    #3006 = 1 (Float Tapping...)
}
ELSE
{

   #3006 = 1 (Rigid Tapping...)
#1=#10027 (Port Configuration - Rigid Tapping Output Port)
#2=1400+#1
##2=1
}

M3000
%

O2218
(after tapping)
IF[#5165 == 0]
{
    #3006 = 1 (Float Tapping Finished)
}
ELSE
{

   #3006 = 1 (Rigid Tapping Finished)
#1=#10027 (Port configuration rigid tapping output port)
#2=1400+#1
##2=0
}

M3000
%