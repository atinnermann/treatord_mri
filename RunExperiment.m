function [abort] = RunExperiment(subID,nRun,TENS,preExp)
% Arguments: subID (001-200)
% if sub99 is entered, script is run in debug mode with fewer/shorter
% trials and smaller, transparent screen

clear mex global
clc

thermoino       = 0; % 0 for no thermoino, 1 for thermoino connected; 2: send trigger directly to thermode via e.g. outp
SCR             = 1;

if nargin == 0
    subID = input('Please enter subject ID.\n');
    nRun = input('Please enter run number.\n');
end
% %choose which parts of the experiment to run
if nargin == 2 || nargin == 0
    TENS            = 1;
    preExp          = 1;
end

tStartScript = GetSecs;

if subID == 99
    toggleDebug = 1;
else
    toggleDebug = 0;
end

[~, hostname]   = system('hostname');
hostname        = deblank(hostname);

if strcmp(hostname,'stimpc1')
    basePath    = 'C:\USER\tinnermann\treatorder\Paradigma_MRT\';
    toolboxPath = '';
elseif strcmp(hostname,'isn0068ebea3a78')
    basePath    = 'C:\Users\alexandra\Documents\Projects\TreatOrder\Paradigma\';
    toolboxPath = 'C:\Users\alexandra\Documents\MATLAB\toolbox';
else
    basePath    = 'C:\Users\Mari Feldhaus\Documents\Tinnermann\TreatOrd\';
    toolboxPath = 'C:\Users\Mari Feldhaus\Documents\MATLAB';
end

expPath     = fullfile(basePath,'ExpMRI');
savePath    = fullfile(expPath,'LogfilesExp',sprintf('Sub%02.2d',subID));
fileName    = sprintf('Sub%02.2d_TreatOrd_Exp_Vars',subID);

%%%%%%%%%%%%%%%%%%%%%%%
% START
%%%%%%%%%%%%%%%%%%%%%%%

if nRun == 1
    warning('Start thermode programme AT_TreatOrd.');
    
    % load all variables
    t = ImportStimvars(toggleDebug);
    t = ImportKeys(t,hostname);
    t = ImportCOM(t,hostname,thermoino,SCR);
    t = ImportImages(t,expPath);
    
    t.save.basePath     = basePath;
    t.save.toolboxPath  = toolboxPath;
    t.save.filePath     = savePath;
    mkdir(t.save.filePath);
    fprintf('Saving data to %s.\n\n',t.save.filePath);
    
    calibPath        = fullfile(t.save.basePath,'Calib','LogfilesCalib');
    t.save.calibFile = fullfile(calibPath,sprintf('Sub%02.2d',subID),sprintf('Sub%02.2d_tVAS.mat',subID));
    
    if isfile(t.save.calibFile)
        v = load(t.save.calibFile);
        yn = input('Do you want to use the existing mat file? (y/n)\n','s');
        if strcmp(yn,'y')
            fit = input('Please enter fit. (lin/sig/ran/fix/man)\n','s');
            WaitSecs(0.2);
            if strcmp(fit,'lin')
                t.test.tVAS = v.tVAS.lin;
            elseif strcmp(fit,'sig')
                t.test.tVAS = v.tVAS.sig;
            elseif strcmp(fit,'ran')
                t.test.tVAS = v.tVAS.ran;
            elseif strcmp(fit,'fix')
                t.test.tVAS = v.tVAS.fix;
            elseif strcmp(fit,'man')
                t.test.tVAS = v.tVAS.man;
            end
        elseif strcmp(yn,'n')
            t.test.tVAS = input('Please enter tVAS in one vector from low to high.\n');
        end
    elseif ~isfile(t.save.calibFile) && toggleDebug == 0
        t.test.tVAS = input('Please enter temps in one vector from low to high.\n');
    elseif toggleDebug == 1
        t.test.tVAS      = [42 42.5 43 43.5];
    end
    
    fprintf('The loaded temperatures for the experiment are:\n');
    fprintf(' %3.1f  ',t.test.tVAS);
    fprintf('\n');
    input('Please verify these temperatures and press enter!\n');
    WaitSecs(0.1);
    
    a = load('randOrder_StimColors.mat');
    t.test.stimColor = a.randCols(subID,:);
    
    b = load('randOrder_SkinPatches.mat');
    t.test.skinPatch = b.randPatch(subID,:);
    
    %define order of stimulation
    x = load('randOrder.mat');
    
    if x.randOrder(subID) == 1
        t.test.stimOrder = "decreasing";
        t.test.condOrder = [1,4,1,3,1,2,1,3,1,3];
        t.test.freqOrder = [0,150,0,100,0,50,0,100,0,100];
        t.test.VASOrder  = [70,25,70,40,70,55,70,40,70,40];
        t.test.tempOrder = [t.test.tVAS(4),t.test.tVAS(1),t.test.tVAS(4),t.test.tVAS(2),t.test.tVAS(4),t.test.tVAS(3),t.test.tVAS(4),t.test.tVAS(2),t.test.tVAS(4),t.test.tVAS(2)];
        t.test.colOrder  = [t.test.stimColor(1),t.test.stimColor(2),t.test.stimColor(1),t.test.stimColor(3),t.test.stimColor(1),t.test.stimColor(4),t.test.stimColor(1),t.test.stimColor(3),t.test.stimColor(1),t.test.stimColor(3)];
    elseif x.randOrder(subID) == 0
        t.test.stimOrder = "increasing";
        t.test.condOrder = [1,2,1,3,1,4,1,3,1,3];
        t.test.freqOrder = [0,50,0,100,0,150,0,100,0,100];
        t.test.VASOrder  = [70,55,70,40,70,25,70,40,70,40];
        t.test.tempOrder = [t.test.tVAS(4),t.test.tVAS(3),t.test.tVAS(4),t.test.tVAS(2),t.test.tVAS(4),t.test.tVAS(1),t.test.tVAS(4),t.test.tVAS(2),t.test.tVAS(4),t.test.tVAS(2)];
        t.test.colOrder  = [t.test.stimColor(1),t.test.stimColor(2),t.test.stimColor(1),t.test.stimColor(3),t.test.stimColor(1),t.test.stimColor(4),t.test.stimColor(1),t.test.stimColor(3),t.test.stimColor(1),t.test.stimColor(3)];
    end
    
    % s is loaded later because of typing before
    t = ImportScreenvars(t,toggleDebug,hostname);
    
    %save struct to save all variables
    save(fullfile(t.save.filePath,fileName), 't');
else
    load(fullfile(savePath,fileName),'t');
end

%define file name for saving results
fileNameRun     = [sprintf('Sub%02.2d_TreatOrd_Exp_Run%d_',subID,nRun) datestr(now,30)];
t.save.fileName = fullfile(t.save.filePath,fileNameRun);

if ismember(nRun,t.test.chTherm)
    ind = find(t.test.chTherm==nRun);
    input(sprintf('Change thermode to skin patch %d and press enter when ready.',t.test.skinPatch(ind+1)));
end

% instantiate serial object for thermoino control
if t.com.thermoino == 1
    UseThermoino('kill');
    UseThermoino('Init',t.com.thermoPort,t.com.thermoBaud,t.test.baseTemp,t.test.riseSpeed); % returns handle of serial object
end

% Open a graphics window using PTB
if toggleDebug == 1
    [t.disp.wHandle, t.disp.rect] = Screen('OpenWindow', t.disp.screenNumber, t.disp.backgr, t.disp.window);
else
    [t.disp.wHandle, t.disp.rect] = Screen('OpenWindow', t.disp.screenNumber, t.disp.backgr);
end
Screen('Flip',t.disp.wHandle);
t.disp.slack = Screen('GetFlipInterval',t.disp.wHandle)./2;


%% Experiment

t.log.eventCount = 0;
t.log.rating = [];
t.log.cond = [];

fprintf('\n=======Experiment starts=======\n\n');

%log starting time
t.log.tIntroExp = GetSecs; %timing
t = LogEvents(t,t.log.tIntroExp, 'Intro Start');

fprintf('\n======= Run %d =======\n',nRun);

%check if thermode was changed for this run to apply preexposure and TENS
if ismember(nRun,t.test.chTherm)
    
    if preExp == 1
        ShowInstruction(t,2,1);  %"PreExposure"
        PreExposure(t);
    end
    
    if TENS == 1
        [abort] = ShowInstruction(t,1,1); %"TENS calibration"
        if t.com.thermoino == 1
            WaitSecs(2);
            if t.com.SCR == 1
                SendTrigger(t.com.SCRaddress,t.com.lpt.Digi,t.com.SCRduration);
            end
            fprintf('Applying electrical stimulation\n');
            UseThermoino('Shock',1,2000);
            WaitSecs(2);
            if t.com.SCR == 1
                SendTrigger(t.com.SCRaddress,t.com.lpt.Digi,t.com.SCRduration);
            end
            fprintf('Applying electrical stimulation\n');
            UseThermoino('Shock',1,2000);
            WaitSecs(2);
        end
        
        WaitSecs(0.2);
        Screen('Flip',t.disp.wHandle);
    end
end

if nRun == 1
    %show instructions
    ShowInstruction(t,3,1); %Instruction Experiment
    WaitSecs(1);
    ShowInstruction(t,4,1); %Instruction Rating
else
    ShowInstruction(t,6,1); %Gleich geht es los
    WaitSecs(1);
end 

%log exp start time
t.log.expStartTime = GetSecs;
t = LogEvents(t,t.log.expStartTime, 'Experiment Start');
if t.com.SCR == 1
    SendTrigger(t.com.SCRaddress,t.com.lpt.expStart,t.com.SCRduration);
end

% Wait for Dummy Scans
firstPulseTime = WaitPulse(t,t.keys.name.trigger,t.mri.dummy);
t.mri.expStartTime = firstPulseTime(end);
LogEvents(t,t.mri.expStartTime, 'FirstMRPulse_ExpStart');

KbQueueCreate;
KbQueueStart;

%show run image
t = ShowImage(t,1,nRun,[],t.test.cueDur); %1 = block image; 2 = freq image
WaitSecs(1);

for condRun = 1:t.test.condsRun
    
    nCond = (nRun*2)-(2-condRun);
    disp(nCond);
    fprintf('\n====== Condition %d ======\n',condRun);
    
    %show TENS frequency image
    t = ShowImage(t,2,nRun,nCond,t.test.cueDur);
    WaitSecs(1);
    
    %calculate and shuffle ITI and Cue durations
    c = DetermineITIandCue(t.test.nTrials,t.test.ITI,t.test.cue);
    t.test.Timings.ITI(:,condRun) = c.ITI';
    t.test.Timings.cue(:,condRun) = c.cue';
    
    t = RunStim(t,t.test.tempOrder(nCond),t.test.Timings,condRun,nCond);
    
    %save struct to save all results
    save(t.save.fileName, 't');
    
end

fprintf('=================\n=================\nWait for last scanner pulse of experiment!...\n');

KbQueueStop;
KbQueueRelease;

lastPulseTime = KbTriggerWait(t.keys.name.trigger);
LogEvents(t,lastPulseTime, 'LastMRPulse_ExpStop');
LogEvents(t,GetSecs, 'ExpEnd');

if nCond == t.test.nRuns*t.test.condsRun
    ShowInstruction(t,8,1); %Ende des Experiments
elseif nRun == t.test.chTherm(2)-1
    ShowInstruction(t,5,1); %change thermode
else
    %show wait screen
    ShowInstruction(t,7,1); %Gleich geht's weiter...
end
WaitSecs(0.2);


%% End

tEndExp = GetSecs; %timing

durationTotal = tEndExp - tStartScript;

fprintf('\n--\n');
fprintf('Total minutes since script start: %1.1f\n',round(durationTotal/60,1));

QuickCleanup(t.com.thermoino);

%%%%%%%%%%%%%%%%%%%%%%%
% END
%%%%%%%%%%%%%%%%%%%%%%%


end