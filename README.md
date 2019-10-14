# lickometer
description of an open-source arduino-controlled lickometer system for the investigation of reward consumption in neuroscience research. 


Included are the associated arduino control code and example MATLAB analysis code for the extraction of data and 
microstructural analysis of rodent fluid consumption


This project is a cost-effective solution (~$75 per system) to the recording of licking during the consumption of liquid rewards.

JanakLickometer.pdf contains an overview of the design of the lickometer and step-by-step constructions for parts ordering all the way to the analysis
of the data

LicksLaser.ino is the Arduino control code for running the lickometer

ReadTwoBottle.m is MATLAB code for extracting data from the Arduino generated files from a lickometer system that was recording from
two sensors and logging stimulation times for optogenetics.

AnalyzeLicks.m is MATLAB code that separates lick data into the units of rodent fluid consumption, bursts and clusters. Bursts are bouts of licks that are separated by inter-lick intervals of less than 0.25 seconds. Clusters are a more conservative estimate of consumption 
and are composed of bouts of licks separated by inter-lick intervals of less than 1 second. The number of bursts and/or clusters reflects
motivational processes in consumption whereas the number of licks per each burst and/or cluster reflects palatability of the consumed
substance. For more on rodent fluid consumption see Davis JD and Perez MC 1993; Spector AC St. John SJ 1998;  Spector AC, Klumpp PA, Kaplan JM 1998.

