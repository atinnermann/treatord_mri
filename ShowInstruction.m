function [abort] = ShowInstruction(t,section,displayDuration)
%show instructions

if nargin == 5
    displayDuration = 0; %0 for wait, 1 requires input
end

abort = 0;
Screen('TextSize',t.disp.wHandle,t.disp.fontsize);

if section == 1
    fprintf('Ready SKIN CONDUCTANCE MEASUREMENT protocol.\n');
    heightText = t.disp.startY-t.disp.lineheight*2;
    [~, heightText]=DrawFormattedText(t.disp.wHandle,'Jetzt folgt gleich eine kurze Widerstandsmessung des Elektrostimulators','center',heightText,t.disp.white);
    [~, heightText]=DrawFormattedText(t.disp.wHandle,'Sie werden gar nichts oder ein leichtes Kribbeln spüren.','center',heightText+t.disp.lineheight,t.disp.white);
elseif section == 2
    fprintf('Ready PREEXPOSURE protocol.\n');
    heightText = t.disp.startY-t.disp.lineheight*2;
    [~, heightText]=DrawFormattedText(t.disp.wHandle,'Gleich erhalten Sie über die Thermode einige','center',heightText,t.disp.white);
    [~, heightText]=DrawFormattedText(t.disp.wHandle,'Hitzereize, die leicht schmerzhaft sein können.','center',heightText+t.disp.lineheight,t.disp.white);
elseif section == 3
    heightText = t.disp.startY-t.disp.lineheight*3;
    [~, heightText]=DrawFormattedText(t.disp.wHandle,'Wir testen nun den Einfluss verschiedener','center',heightText,t.disp.white);
    [~, heightText]=DrawFormattedText(t.disp.wHandle,'TENS-Frequenzen auf Ihr Schmerzempfinden.','center',heightText+t.disp.lineheight,t.disp.white);
    [~, heightText]=DrawFormattedText(t.disp.wHandle,' ','center', heightText+t.disp.lineheight,t.disp.white);
    [~, heightText]=DrawFormattedText(t.disp.wHandle,'Sie werden vor jedem Block darüber informiert,','center',heightText+t.disp.lineheight,t.disp.white);
    [~, heightText]=DrawFormattedText(t.disp.wHandle,'welche Intensität der Behandlung Sie erhalten.','center',heightText+t.disp.lineheight,t.disp.white);
    [~, heightText]=DrawFormattedText(t.disp.wHandle,' ', 'center', heightText+t.disp.lineheight, t.disp.white);
    [~, heightText]=DrawFormattedText(t.disp.wHandle,'Ein Block besteht jeweils aus:','center', heightText+t.disp.lineheight,t.disp.white);
    [~, heightText]=DrawFormattedText(t.disp.wHandle,'8 Reize TENS AUS','center',heightText+t.disp.lineheight,t.disp.white);
    [~, heightText]=DrawFormattedText(t.disp.wHandle,'8 Reize TENS EIN','center',heightText+t.disp.lineheight,t.disp.white);
elseif section == 4
    if strcmp(t.log.hostname,'stimpc1')
        keyMoreLessPainful = 'des linken/rechten Knopfes';
        keyConfirm = 'dem oberen Knopf';
    else
        keyMoreLessPainful = 'der linken/rechten Pfeiltaste';
        keyConfirm = 'der Eingabetaste';
    end
    heightText = t.disp.startY-t.disp.lineheight;
    [~, heightText]=DrawFormattedText(t.disp.wHandle,['Bitte bewerten Sie jeden Reiz mithilfe ' keyMoreLessPainful], 'center',heightText,t.disp.white);
    [~, heightText]=DrawFormattedText(t.disp.wHandle,['und bestätigen mit ' keyConfirm '.'],'center', heightText+t.disp.lineheight,t.disp.white);
    [~, heightText]=DrawFormattedText(t.disp.wHandle,' ', 'center', heightText+t.disp.lineheight, t.disp.white);
    [~, heightText]=DrawFormattedText(t.disp.wHandle,'Es ist SEHR WICHTIG, dass Sie JEDEN der Reize bewerten!','center',heightText+t.disp.lineheight, t.disp.white);
elseif section == 5
    fprintf('Ready CHANGE THERMODE POSITION protocol.\n');
    heightText = t.disp.startY-t.disp.lineheight;
    [~, heightText]=DrawFormattedText(t.disp.wHandle,'Die Thermode wird nun umgesetzt.','center',heightText,t.disp.white);
    [~, heightText]=DrawFormattedText(t.disp.wHandle,' ','center', heightText+t.disp.lineheight,t.disp.white);
    [~, heightText]=DrawFormattedText(t.disp.wHandle,'Bitte ganz ruhig liegen bleiben!','center',heightText+t.disp.lineheight,t.disp.white);
elseif section == 6
    heightText = t.disp.startY;
    [~, heightText]=DrawFormattedText(t.disp.wHandle,'Gleich geht es los...','center',heightText,t.disp.white);
elseif section == 7
    heightText = t.disp.startY;
    [~, heightText]=DrawFormattedText(t.disp.wHandle,'Gleich geht es weiter...','center',heightText,t.disp.white);
elseif section == 8
    heightText = t.disp.startY;
    [~, heightText]=DrawFormattedText(t.disp.wHandle,'Ende des Experiments','center',heightText,t.disp.white);
end

tIntroText = Screen('Flip',t.disp.wHandle);

fprintf('Displaying instructions...');
countedDown = 1;

t = LogEvents(t,tIntroText, ['IntroTextOn' num2str(section)]);
 
while 1
    [keyIsDown, ~, keyCode] = KbCheck();
    if keyIsDown 
        if section < 5 && (find(keyCode) == t.keys.name.confirm || find(keyCode) == t.keys.name.resume)
                break
        elseif section > 4 && find(keyCode) == t.keys.name.resume
                break
        elseif find(keyCode) == t.keys.name.esc
            abort=1;
            break
        end
    end
    
    if displayDuration == 1
        [countedDown] = CountDown(GetSecs-tIntroText,countedDown,'.');
    end
end

if displayDuration == 1
    fprintf('\nInstructions were displayed for %d seconds.\n',round(GetSecs-tIntroText,0));
    Screen('Flip',t.disp.wHandle);
end

if abort
    QuickCleanup(t.com.thermoino);
    return;
end

end