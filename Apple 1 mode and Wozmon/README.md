Here you will find the original Apple 1 manual etc.

Also the 16k Rom Image that has a Software Compatatble version of Apple 1 replica software on it. It supports most programs written in integer basic, however since it does not have a 6821 chip on the board any software that accesses tha tchip directly will not work. It is possible to patch the hexdumps (see software folder, I have pre-patched lots of programs), Or if you have the source code, to recompile a version for this ROM.

Rom Layout:

| 	8k original Replica ROM	 | 		 | 	16k Rom for Grant's SBC	 |  |
| 	:-----:	 | 	:-----:	 | 	:-----:	 |  :-----: |
| 	N/A	| 	N/A	| 	DFB8- DFFF	 | Emulated I/O for ACIA, "shims"|
| 	E000- EFFF	| 	Integer Basic	| 	E000- EFFF	 | Integer Basic |
| 	F000- FEFF	| 	Krusaider 1.2	| 	F000- FEFF	 | Krusadier 1.3 |

The copies of Krusader and Integer basic have been patched to use the "software Shims" in the DFxx part of the ROM to work with the ACIA.

The software directory has a collection of original Apple 1 software, including FIGFORTH and CHESS. Some of the software has been patched to work with this ROM. The others, mostly BASIC, will just work anyway.

You cut and paste them into the WozMon monitor. Don't forget to set the line/char delay values!

