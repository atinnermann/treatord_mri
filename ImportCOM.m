function t = ImportCOM(t,thermoino)


%% ARDUINO
if thermoino == 1
    
    if strcmp(t.log.hostname,'stimpc1')
        addpath(fullfile(t.save.toolboxPath,'Thermoino'));
        t.com.thermoPort    = 'COM16';
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

t.com.CEDaddress      = 36912; %spike port, digitimer port, brainvision port: 888
t.com.CEDduration     = 0.005;
t.com.shockDuration   = 0.2;   %duration correct???

config_io;
outp(t.com.CEDaddress,0);

t.com.lpt.shock                = 8;       % port for sending shock trigger to digitimer, 8 means right digitimer (left 4)
t.com.lpt.expStart             = 32;      % Start (spike channel 4)
t.com.lpt.digi                 = 64;      % Shock (spike channel 5)
t.com.lpt.heat                 = 128;     % Heat  (spike channel 6)

