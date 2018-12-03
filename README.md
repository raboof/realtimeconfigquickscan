realtimeconfigquickscan
=======================

Linux configuration checker for systems to be used for real-time audio

This linux-only script inspects a linux installation, and makes suggestions for improving realtime/audio performance.

If you want to share the output of the script online, it is probably most convenient to use the Console version. If not, the GUI version might look a bit more friendly.
Console

    git clone git://github.com/raboof/realtimeconfigquickscan.git
    cd realtimeconfigquickscan
    perl ./realTimeConfigQuickScan.pl

GUI
---

An experimental GUI is now available. To try it:

    git clone git://github.com/raboof/realtimeconfigquickscan.git
    cd realtimeconfigquickscan
    perl ./QuickScan.pl

.. and hit 'Start'

You'll need to have Mercurial and perl/tk installed. 

Adding the sound card IRQ
-------------------------

open the file `/proc/interrupts`. Find your sound card. The first column represents the IRQ. Set this numer to the variable `SOUND_CARD_IRQ` in the same terminal session like this:

    export SOUND_CARD_IRQ={IRQ #}
