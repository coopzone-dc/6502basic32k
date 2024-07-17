This is a Rom image that uses modified versions of Apple 1 software, right the way back to 1976!

It boots to Apple 1 monitor, Know better by most as WozMon written originally by Steve Wozniak
of Apple Computers.

Wozmon prompts with a \ and a return:
\

I have added a text reminder that tells you what to type to get the the software pakages in the ROM:

<PWR up or RESET>
Apple 1 software mode
E000R Run Krusaider ASM
C000R Apple Integer BASIC
\

In addition to Wozmon, the ROM also contains Apple 1 Integer BASIC and Krusaider assembler package.

To run these pakages you enter the HEX address (C000, for BASIC) followed by the letter R (in caps!) to RUN it

The BASIC prompt is >

you can now program in Apple BASIC, The folder conatins copies of the manual for WozMon, Krusaider and Apple BASIC

NOTE: the address's in memory differ from the documentation, keep this in mind!
        Original  this version
  WozMon  FF00  FE00
  BASIC    E000  C000
  Krusaider  F000  E000

  Some software from the APPLE 1 will not run, especially if it expects address's to be different. However some can be changed to work ok.

  As an example
  STARTREK2003.TXT is txt file in MON format, that means you can paste it into WozMon. The Last but one line of the file reads:
  E2B3R - this tells WozMon to execute from E2B3 (integer basic warm start address) the R is the Run command
  The address for this version of BASIC warm start is C2B3, so just change the last line to read C2B3R
  like this:
3FF8: AE 29 01 05 14 1E 51 01
E2B3R

RUN

Then past the file into WozMon And basic will start, and the word RUN will be typed ready to run startrek:
\
CTRL-V (takes a while to paste in, remember to set the end of line delay=100ms and character delay=2ms)
.......
The last lines are:
3FF8: AE 29 01 05 14 1E 51 01                                                   
3FF8: FE                                                                        
C2B3R                                                                           
C2B3: 20                                                                        
>                                                                               
                                                                                
>RUN                                                                            
                                                                                
                                                                                
      S T A R T R E K  2 0 0 3                                                  
                                                                                
                                                                                
                                                                                
                                                                                
WHAT IS YOUR NAME CAPTAIN?

Good luck with your mission!

