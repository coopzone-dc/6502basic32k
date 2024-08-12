This is a Rom image that uses modified versions of Apple 1 software, right the way back to 1976!

It boots to Apple 1 monitor, Known better by most as WozMon written originally by Steve Wozniak
of Apple Computers.

Wozmon prompts with a \ and a return:

\

At this point you can refer to the "Apple 1 opperation manual"

The ROM contains the original Interger Basic (supplied on tape by apple, but now in ROM). And a copy of krusader ASM

D000R Run Krusaider ASM

E000R Apple Integer BASIC

\

To run these pakages you enter the HEX address (E000, for BASIC) followed by the letter R (in caps!) to RUN it

The BASIC prompt is >

You can now program in Apple BASIC, The folder conatins copies of the manual for WozMon, Krusaider and Apple BASIC

NOTE: Most of the addresses used by the original apple 1 are the same, but some maybe different. In particular the KBD and KBDCTL (D000 / D001) do not exist on the SBC6502. Most BASIC programs will work ok, but assembler programs using direct hardware will not work without changes.

  WozMon  FF00(original)  FF00
  
  BASIC    E000(original)  E000
  
  Krusaider  F000(original)  D000
