function t = ImportCOM(t,hostname,thermoino,SCR)


%% ARDUINO
if thermoino == 1

    if strcmp(hostname,'stimpc1')
        
        t.com.thermoPort    = 'COM11';
        t.com.thermoBaud    = 115200;
        
    elseif strcmp(hostname,'isn0068ebea3a78')
        addpath('C:\Users\alexandra\Documents\MATLAB\toolbox\Thermoino');
        t.com.thermoPort    = 'COM5';
        t.com.thermoBaud    = 115200;
        
    else
        addpath('C:\Users\Mari Feldhaus\Documents\MATLAB\thermoino');
        t.com.thermoPort    = 'COM5';
        t.com.thermoBaud    = 115200;
        
    end
    
elseif thermoino == 2
    
    t.com.CEDport     = 255; % Trigger bits for thermode
    t.com.CEDaddress  = 888;
    t.com.CEDduration = 0.005;
    
    addpath('C:\Users\Mari Feldhaus\Documents\MATLAB\IO_64bit');
    config_io;
    outp(t.com.CEDaddress,0);
    
end

t.com.thermoino     = thermoino;

%% SCR

if SCR == 1
    t.com.SCR             = 1;
    t.com.SCRaddress      = 888; %hex2dec('E800') = 59392
%     com.CEDaddress      = 59392; %hex2dec('E800') = 59392
   
    t.com.SCRduration     = 0.005;
    
    addpath('C:\Users\Mari Feldhaus\Documents\MATLAB\IO_64bit');
    
    config_io;
%     outp(com.CEDaddress,0);
    outp(t.com.SCRaddress,0);
    
    t.com.lpt.expStart             = 1;  % start of each run after intro text (Brainvision Recorder "S1")
    t.com.lpt.Digi                 = 2;  % Digitimer (trigger Digitimer & Brainvision Recorder "S2") 
    t.com.lpt.Heat                 = 3;  % thermode heat (Brainvision Recorder "S3")
else 
    t.com.SCR             = 0;
end
