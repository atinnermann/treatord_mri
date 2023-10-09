function t = ImportScreenvars(t,debug)

t.disp.screens                = Screen('Screens');                  % Find the number of the screen to be opened
t.disp.screenNumber           = max(t.disp.screens);                     % The maximum is the second monitor
t.disp.screenRes              = Screen('resolution',t.disp.screenNumber);

if debug == 1
    commandwindow;
    PsychDebugWindowConfiguration(0,0.5);                             % Make everything transparent for debugging purposes.
    t.disp.window             = [0 0 t.disp.screenRes.width*0.6 t.disp.screenRes.height*0.6];
else
%     ListenChar(2);
    HideCursor(t.disp.screenNumber);
    t.disp.window             = [0 0 t.disp.screenRes.width t.disp.screenRes.height];
end
%  
t.disp.midpoint               = [t.disp.window(3)/2 t.disp.window(4)/2];   % Find the mid position on the screen.
t.disp.startY                 = t.disp.window(4)/2;

t.disp.fontname               = 'Verdana';
t.disp.fontsize               = 28; %30; %18;
t.disp.linespace              = 8;
t.disp.lineheight             = t.disp.fontsize + t.disp.linespace;
t.disp.backgr                 = [90 90 90];
t.disp.widthCross             = 3;
t.disp.sizeCross              = 20;
t.disp.white                  = [255 255 255];
t.disp.red                    = [255 0 0];

t.disp.fix1                   = [t.disp.midpoint(1)-t.disp.sizeCross t.disp.startY-t.disp.widthCross t.disp.midpoint(1)+t.disp.sizeCross t.disp.startY+t.disp.widthCross];
t.disp.fix2                   = [t.disp.midpoint(1)-t.disp.widthCross t.disp.startY-t.disp.sizeCross t.disp.midpoint(1)+t.disp.widthCross t.disp.startY+t.disp.sizeCross];

%%%%%%%%%%%%%%%%%%%%%%%%%%% Default parameters

Screen('Preference', 'Verbosity', 0);
Screen('Preference', 'SyncTestSettings',0.005,50,0.2,10);
Screen('Preference', 'SkipSyncTests', 1); %was toggleDebug
Screen('Preference', 'DefaultFontSize', t.disp.fontsize);
Screen('Preference', 'DefaultFontName', t.disp.fontname);
%Screen('Preference', 'TextAntiAliasing',2);                       % Enable textantialiasing high quality
Screen('Preference', 'VisualDebuglevel', 0);                       % 0 disable all visual alerts
%Screen('Preference', 'SuppressAllWarnings', 0);


