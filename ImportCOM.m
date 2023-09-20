function t = ImportCOM(t,thermoino)


%% ARDUINO
if thermoino == 1

    if strcmp(t.log.hostname,'stimpc1')
        addpath(fullfile(t.save.toolboxPath,'Thermoino'));
        t.com.thermoPort    = 'COM11';
        t.com.thermoBaud    = 115200;
        
    elseif strcmp(t.log.hostname,'isn0068ebea3a78')
        addpath(fullfile(t.save.toolboxPath,'Thermoino'));
        t.com.thermoPort    = 'COM5';
        t.com.thermoBaud    = 115200;
        
    else
        addpath(fullfile(t.save.toolboxPath,'thermoino'));
        t.com.thermoPort    = 'COM5';
        t.com.thermoBaud    = 115200;
        
    end
    
elseif thermoino == 2
    
    t.com.CEDport     = 255; % Trigger bits for thermode
    t.com.CEDaddress  = 888;
    t.com.CEDduration = 0.005;
    
    addpath(fullfile(t.toolboxPath,'IO_64bit'));
    config_io;
    outp(t.com.CEDaddress,0);
    
end

t.com.thermoino     = thermoino;

%% trigger for spike software (physio and SCR)
    addpath(fullfile(t.save.toolboxPath,'IO_64bit'));
    
    t.com.CEDaddress      = 888; 
%     t.com.CEDaddress      = 59392; %hex2dec('E800') = 59392
    t.com.CEDduration     = 0.005;
    
    config_io;
    outp(com.CEDaddress,0);
    
    t.com.lpt.expStart             = 32;      % Start (spike channel 4)
    t.com.lpt.Digi                 = 64;      % Shock (spike channel 5) 
    t.com.lpt.Heat                 = 128;     % Heat  (spike channel 6)
   
% if SCR == 1
%     t.com.SCR             = 1;
%     t.com.SCRaddress      = 888; %hex2dec('E800') = 59392
% %     com.CEDaddress      = 59392; %hex2dec('E800') = 59392
%    
%     t.com.SCRduration     = 0.005;
%     
%     addpath(fullfile(t.save.toolboxPath,'IO_64bit'));
%     
%     config_io;
% %     outp(com.CEDaddress,0);
%     outp(t.com.SCRaddress,0);
%     
%     if strcmp(t.log.hostname,'stimpc1')
%         t.com.lpt.expStart             = 1;  % start of each run after intro text (Brainvision Recorder "S1")
%     t.com.lpt.Digi                 = 2;  % Digitimer (trigger Digitimer & Brainvision Recorder "S2") 
%     t.com.lpt.Heat                 = 3;  % thermode heat (Brainvision Recorder "S3")
%     else
%     t.com.lpt.expStart             = 1;  % start of each run after intro text (Brainvision Recorder "S1")
%     t.com.lpt.Digi                 = 2;  % Digitimer (trigger Digitimer & Brainvision Recorder "S2") 
%     t.com.lpt.Heat                 = 3;  % thermode heat (Brainvision Recorder "S3")
%     end
% else 
%     t.com.SCR             = 0;
% end
