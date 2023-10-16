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

t.test.maxTemp        = 49; 
t.test.baseTemp       = 34; 
t.test.riseSpeed      = 15; % to determine approximate wait time
t.test.fallSpeed      = 15; % to determine approximate wait time
t.test.maxRampDur     = ((t.test.maxTemp-t.test.baseTemp)/t.test.riseSpeed)+((t.test.maxTemp-t.test.baseTemp)/t.test.fallSpeed);

t.test.sBlank         = 0.5;
t.test.firstITI       = 3; 
t.test.imgDur         = 2;

t.test.cueing         = 1; %switch cueing on or off
t.test.chTherm        = [1 2 4]; %before which runs the thermode needs to be changed
t.test.nRuns          = 5;
t.test.condsRun       = 2;
t.test.ratingDur      = 6;
t.test.stimDur        = 6; %  pain stimulus duration
t.test.nTrials        = 10; %!!!!!changed for testing purposes %10;

t.test.rangeITI       = [3 7];
t.test.rangeCue       = [1.5 2.5];
t.test.rangeJit       = [2 5];

t.test.iti            = DetermineJitter(t.test.nTrials,t.test.rangeITI);
t.test.cue            = DetermineJitter(t.test.nTrials,t.test.rangeCue);
t.test.jit            = DetermineJitter(t.test.nTrials,t.test.rangeJit);

%change timings and number of trials in debug mode
if toggleDebug
    t.test.debug      = 1;
    
    t.test.stimDur    = 1; 
    t.test.nTrials    = 2;   
    
    t.test.rangeITI   = [2 3];
    t.test.rangeCue   = [0.5 1.5];
    t.test.rangeJit   = [1 2];

    t.test.iti        = DetermineJitter(t.test.nTrials,t.test.rangeITI);
    t.test.cue        = DetermineJitter(t.test.nTrials,t.test.rangeCue);
    t.test.jit        = DetermineJitter(t.test.nTrials,t.test.rangeJit);
    
end

    
    

    
