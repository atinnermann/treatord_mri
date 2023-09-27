function t = ImportStimvars(t,toggleDebug)
%% MRI 

t.mri.dummy           = 5; %waits for the 5th pulse, resulting in 4 dummy scans!
t.mri.tr              = 2.195;
t.mri.pulses          = 0;
t.mri.times           = 0;
    
%% Preexposure

t.test.exp.temp            = 40;
t.test.exp.dur             = 10;
t.test.exp.iti             = 5;
t.test.exp.wrapITI         = 3;
t.test.exp.cue             = 1;
t.test.exp.trials          = 2;

%% CORE VARIABLES: Other protocol parameters

t.test.debug          = 0;

t.test.baseTemp       = 32; % to determine approximate wait time
t.test.riseSpeed      = 15; % to determine approximate wait time
t.test.fallSpeed      = 15; % to determine approximate wait time

t.test.ratingDur      = 6;
t.test.ratDelay       = 1;

t.test.sBlank         = 0.5;
t.test.firstITI       = 3; 
t.test.imgDur         = 2;

t.test.cueing         = 1; %switch cueing on or off
t.test.chTherm        = [1 2 4]; %before which runs the thermode needs to be changed
t.test.nRuns          = 5;
t.test.condsRun       = 2;
t.test.stimDur        = 6; % to determine approximate wait time % pain stimulus duration
t.test.iti            = [12 16];
t.test.cue            = [1.5 2.5];
t.test.nTrials        = 2; %!!!!!changed for testing purposes %10;

%change timings and number of trials in debug mode
if toggleDebug
    t.test.debug      = 1;
    
    t.test.stimDur    = 1; % to determine approximate wait time
    t.test.iti        = [2 3];
    t.test.cue        = [0.5 1.5];
    t.test.nTrials    = 2;   
end

    
    

    
