function t = ImportStimvars(toggleDebug)
%% MRI 

t.mri.dummy           = 5; %waits for the 5th pulse, resulting in 4 dummy scans!
t.mri.tr              = 2.65;
t.mri.log.pulses      = [];
t.mri.log.times       = [];
    
%% Preexposure

t.test.exp.temp            = 40;
t.test.exp.dur             = 20;
t.test.exp.ITI             = 3;
t.test.exp.cue             = 2;

%% CORE VARIABLES: Other protocol parameters
t.test.baseTemp       = 34; % to determine approximate wait time
t.test.riseSpeed      = 15; % to determine approximate wait time
t.test.fallSpeed      = 15; % to determine approximate wait time

t.test.ratingDur      = 6;
t.test.ratDelay       = 2;

t.test.sBlank         = 0.5;
t.test.firstITI       = 3; 
t.test.lastITI        = 3;
t.test.cueDur         = 3;

t.test.cueing         = 1; %switch cueing on or off
t.test.chTherm        = [1 4]; %before which runs the thermode needs to be changed
t.test.nRuns          = 5;
t.test.condsRun       = 2;

if ~toggleDebug
    t.test.debug      = 0;
    
    t.test.stimDur    = 6; % to determine approximate wait time % pain stimulus duration
    t.test.ITI        = [11 15];  
    t.test.cue        = [1.5 2.5]; 
    t.test.nTrials    = 10;
    
else
    t.test.debug      = 1;
   
    t.test.stimDur    = 1; % to determine approximate wait time
    t.test.ITI        = [2 3];
    t.test.cue        = [0.5 1.5];
    t.test.nTrials    = 2;
    
end

    
    

    
