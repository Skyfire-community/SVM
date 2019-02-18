/*
M code macro program
Modified by: Josh Handel
Date of repair: 2019.02.01
The OXX number represents the corresponding MXX code;
the #14XX code represents the output port OUTXX;
the #10XX code represents the input port INXX;
the #18XX code repersents the console light;
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
#1421=1
#1884=1 (coolant 2 light)
M3000
%

O0008
(cooling open M08)
(port configuration cooling output port)
#[#10036+1400]=1
M3000
%

O0009
(cooling off M09)
(port configuration cooling output port)
#[#10036+1400]=0
#1421=0 (coolant 2spray output off)
#1884=0 (coolant 2 light off)
M3000
%

O0010
(Chuck Clamp)
(do nothing)
#1849=1
M3000
%
O0011
(Chuck Clamp)
(do nothing)
#1849=0
M3000
%

O0012
(lighting on OUT16)
#1416=1
#1852=1
M3000
%
O0013
(lighting off OUT16)
#1416=0
#1852=0
M3000
%

O0014
(Powerdrawbar open OUT10)
IF[#3906!=2]M3000 (non-manual mode exit)
#1410=1
#1854=1
M3000
%
O0015
(Powerdrawbar open OUT10)
IF[#3906!=2]M3000 (non-manual mode exit)
#1410=0
#1854=0
M3000
%

O0016
(The magazine status is initialized)
IF[#3906!=2]M3000
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
IF[#3906!=2]M3000
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
IF[#3906!=2]M3000
#2=1400+6
##2=0
#1856=0
M3000
%

O0020
(Tool position reversal - open OUT07)
IF[#3906!=2]M3000
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
IF[#3906!=2]M3000
#2=1400+7
##2=0
#1857=0
M3000
%

O0022
(spindle blower - off OUT20)
IF[#3906!=2]M3000 (non-manual mode exit)
#2=1400+20
##2=1
#1860=1
M3000
%

O0023
(spindle blower - off OUT20)
IF[#3906!=2]M3000 (non-manual mode exit)
#2=1400+20
##2=0
#1860=0
M3000
%

O0024
(chip discharge open NA)
IF[#3906!=2]M3000 (non-manual mode exit)
(do nothing)
#1862=1
M3000
%

O0025
(chip discharge off NA)
IF[#3906!=2]M3000 (non-manual mode exit)
(do nothing)
#1862=0
M3000
%

O0026
(FCNC6D chip removal 2 open NA)
IF[#3906!=2]M3000 (non-manual mode exit)
(do nothing)
#1883=1
M3000
%

O0027
(FCNC6D chip removal 2 off NA)
IF[#3906!=2]M3000 (non-manual mode exit)
(do nothing)
#1883=0
M3000
%

O0128
(FCNC6D cooling 2 open OUT13)
#1421=1
#1884=1
M3000
%
O0129
(FCNC6D cooling 2 off OUT13)
#1421=0
#1884=0
M3000
%

O0130
(FCNC6D elastic material open OUT14)
(do nothing)
#1885=1
M3000
%
O0131
(FCNC6D elastic material off OUT14)
(do nothing)
#1885=0
M3000
%

O0032
(Lubrication open M32)
(#1=#10043) (port configuration lubrication output port)
#[#10035+1400]=1
M3000
%
O0033
(Lubrication off M33)
(#1=#10043) (port configuration lubrication output port)
#[#10035+1400]=0
M3000
%

O0034
(FCNC6D discharge open OUT15)
(do nothing)
#1886=1
M3000
%
O0035
(FCNC6D discharge off OUT15)
(do nothing)
#1886=0
M3000
%

O0036
(FCNC6D feed open OUT16)
IF[#3906!=2]M3000 (non-manual mode exit)
(do nothing)
#1887=1
M3000
%
O0037
(FCNC6D feed off OUT16)
IF[#3906!=2]M3000 (non-manual mode exit)
(do nothing)
#1887=0
M3000
%

O0038
(FCNC6D spindle positioning open OUT17)
IF[#3906!=2]M3000 (non-manual mode exit)
(do nothing)
#1889=1
M3000
%
O0039
(FCNC6D spindle positioning off OUT17)
IF[#3906!=2]M3000 (non-manual mode exit)
(do nothing)
#1889=0
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
(F3 open OUT21)
(do nothing)
#1858=1
M3000
%
O0047
(F3 off OUT21)
(do nothing)
#1858=0
M3000
%

O0048
(F4 open OUT22)
(do nothing)
#1863=1
M3000
%
O0049
(F4 off OUT22)
(do nothing)
#1863=0
M3000
%

O0050
(FCNC6D F5 open OUT23)
(do nothing)
#1874=1
M3000
%
O0051
(FCNC6D F5 off OUT23)
(do nothing)
#1874=0
M3000
%

O0052
(FCNC6D F6 open OUT24)
(do nothing)
#1890=1
M3000
%
O0053
(FCNC6D F6 off OUT24)
(do nothing)
#1890=0
M3000
%

O0054
(FCNC6D F7 open OUT25)
(do nothing)
#1891=1
M3000
%
O0055
(FCNC6D F7 off OUT25)
(#2=1400+25)
(##2=0)
(do nothing)
#1891=0
M3000
%

O0056
(FCNC6D F8 open OUT26)
(#2=1400+26)
(##2=1)
(do nothing)
#1892=1
M3000
%
O0057
(FCNC6D F8 off OUT26)
(#2=1400+26)
(##2=0)
(do nothing)
#1892=0
M3000
%

O0058
(FCNC6D F9 open OUT27)
(#2=1400+27)
(##2=1)
(do nothing)
#1893=1
M3000
%
O0059
(FCNC6D F9 off OUT27)
(#2=1400+27)
(##2=0)
(do nothing)
#1893=0
M3000
%

O0060
(FCNC6D F10 open OUT28)
(#2=1400+28)
(##2=1)
(do nothing)
#1894=1
M3000
%
O0061
(FCNC6D F10 off OUT28)
(#2=1400+28)
(##2=0)
(do nothing)
#1894=0
M3000
%

O0062
(FCNC6D F11 open OUT29)
(#2=1400+29)
(##2=1)
(do nothing)
#1895=1
M3000
%
O0063
(FCNC6D F11 off OUT29)
(#2=1400+29)
(##2=0)
(do nothing)
#1895=0
M3000
%

O0064
(FCNC6D F12 ​​open OUT30)
(#2=1400+30)
(##2=1)
(do nothing)
#1896=1
M3000
%
O0065
(FCNC6D F12 ​​off OUT30)
(#2=1400+30)
(##2=0)
(do nothing)
#1896=0
M3000
%

O0066
(FCNC6D F13 open OUT31)
(#2=1400+31)
(##2=1)
(do nothing)
#1897=1
M3000
%
O0067
(FCNC4D F13 off OUT31)
(#2=1400+31)
(##2=0)
(do nothing)
#1897=0
M3000
%

O0068
(alternate output is open OUT32)
(#2=1400+32)
(##2=1)
#1432=1
M3000
%
O0069
(alternate output off OUT32)
(#2=1400+32)
(##2=0)
#1432=0
M3000
%

O0070
(Alternate output open OUT33)
(#2=1400+33)
(##2=1)
#1433=1
M3000
%
O0071
(Alternate output off OUT33)
(#2=1400+33)
(##2=0)
#1433=0
M3000
%

O0072
(Alternate output is open OUT34)
(#2=1400+34)
(##2=1)
#1434=1
M3000
%
O0073
(alternate output off OUT34)
(#2=1400+34)
(##2=0)
#1434=0
M3000
%

O0074
(Alternate output open OUT35)
(#2=1400+35)
(##2=1)
#1435=1
M3000
%
O0075
(Alternate output off OUT35)
(#2=1400+35)
(##2=0)
#1435=0
M3000
%

O0076
(alternate output open OUT36)
(#2=1400+36)
(##2=1)
#1436=1
M3000
%
O0077
(alternate output off OUT36)
(#2=1400+36)
(##2=0)
#1436=0
M3000
%

O0078
(alternate output open OUT37)
(#2=1400+37)
(##2=1)
#1437=1
M3000
%
O0079
(alternate output off OUT37)
(#2=1400+37)
(##2=0)
#1437=0
M3000
%

O0080
(Alternate output open OUT38)
(#2=1400+38)
(##2=1)
#1438=1
M3000
%
O0081
(Alternate output off OUT38)
(#2=1400+38)
(##2=0)
#1438=0
M3000
%

O0082
(Alternate output open OUT39)
(#2=1400+39)
(##2=1)
#1439=1
M3000
%
O0083
(Alternate output off OUT39)
(#2=1400+39)
(##2=0)
#1439=0
M3000
%

O0084
(alternate output open OUT40)
(#2=1400+40)
(##2=1)
#1440=1
M3000
%
O0085
(alternate output off OUT40)
(#2=1400+40)
(##2=0)
#1440=0
M3000
%

O0086
(alternate output open OUT41)
(#2=1400+41)
(##2=1)
#1441=1
M3000
%
O0087
(Alternate output off OUT41)
(#2=1400+41)
(##2=0)
#1441=0
M3000
%

O0090
(Alternate output is open OUT42)
(#2=1400+42)
(##2=1)
#1442=1
M3000
%
O0091
(Alternate output off OUT42)
(#2=1400+42)
(##2=0)
#1442=0
M3000
%

O0092
(Alternate output is open OUT43)
(#2=1400+43)
(##2=1)
#1443=1
M3000
%
O0093
(Alternate output off OUT43)
(#2=1400+43)
(##2=0)
#1443=0
M3000
%

O0094
(Alternate output is open OUT44)
(#2=1400+44)
(##2=1)
#1444=1
M3000
%
O0095
(Alternate output off OUT44)
(#2=1400+44)
(##2=0)
#1444=0
M3000
%

O0096
(Alternate output is open OUT45)
(#2=1400+45)
(##2=1)
#1445=1
M3000
%
O0097
(Alternate output off OUT45)
(#2=1400+45)
(##2=0)
#1445=0
M3000
%

O0198
(alternate output open OUT46)
(#2=1400+46)
(##2=1)
#1446=1
M3000
%
O0199
(alternate output off OUT46)
(#2=1400+46)
(##2=0)
#1446=0
M3000
%

O0100
(alternate output open OUT47)
(#2=1400+47)
(##2=1)
#1447=1
M3000
%
O0101
(alternate output off OUT47)
(#2=1400+47)
(##2=0)
#1447=0
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
IF[#3906!=2]M3000 (non-manual mode exit)
(#1=#3918 spindle status)
(#2=#4118 spindle speed)
IF[#3918==0] (spindle state stop)
{
 M03S#4118
}
ELSE
{
 M05
}
M3000
%
O204
(panel spindle inversion)
IF[#3906!=2]M3000 (non-manual mode exit)
(#1=#3918 spindle status)
(#2=#4118 spindle speed)
IF[#3918==0] (spindle state stop)
{
 M04S#4118
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
(#1=#10044) (port configuration cooling output port)
#[#10036+1400]=1
#1810=1(LED light)
#1861=1(additional panel LED light)
M3000
%
O209
(panel cooling off)
(#1=#10044) (port configuration cooling output port)
#[#10036+1400]=0
#1810=0(LED light)
#1861=0(additional panel LED light)
M3000
%

O212
(panel lubrication on)
(#1=#10043) (port configuration cooling output port)
#[#10035+1400]=1
#1811=1(LED light)
#1859=1 (additional panel LED light)
M3000
%
O213
(panel lubrication off)
(#1=#10043) (port configuration cooling output port)
#[#10035+1400]=0
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
