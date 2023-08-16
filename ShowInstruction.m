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
    [~, heightText]=DrawFormattedText(t.disp.wHandle,'Sie werden gar nichts oder ein leichtes Kribbeln sp�ren.','center',heightText+t.disp.lineheight,t.disp.white);
    [~, heightText]=DrawFormattedText(t.disp.wHandle,' ','center',heightText+t.disp.lineheight,t.disp.white);
    [~, heightText]=DrawFormattedText(t.disp.wHandle,'Bitte haben Sie einen Moment Geduld.','center',heightText+t.disp.lineheight,t.disp.white);
elseif section == 2
    fprintf('Ready PREEXPOSURE protocol.\n');
    heightText = t.disp.startY-t.disp.lineheight*2;
    [~, heightText]=DrawFormattedText(t.disp.wHandle,'Gleich erhalten Sie �ber die Thermode einen','center',heightText,t.disp.white);
    [~, heightText]=DrawFormattedText(t.disp.wHandle,'langen Hitzereizen, der leicht schmerzhaft sein kann.','center',heightText+t.disp.lineheight,t.disp.white);
    [~, heightText]=DrawFormattedText(t.disp.wHandle,' ','center',heightText+t.disp.lineheight,t.disp.white);
%     [~, heightText]=DrawFormattedText(t.disp.wHandle,'Wir melden uns gleich, falls Sie noch Fragen haben,','center',heightText+t.disp.lineheight,t.disp.white);
    [~, heightText]=DrawFormattedText(t.disp.wHandle,'Danach geht es los!','center',heightText+t.disp.lineheight,t.disp.white);
elseif section == 3
    heightText = t.disp.startY-t.disp.lineheight*3;
    [~, heightText]=DrawFormattedText(t.disp.wHandle,'Wir testen nun den Einfluss verschiedener','center',heightText,t.disp.white);
    [~, heightText]=DrawFormattedText(t.disp.wHandle,'TENS-Frequenzen auf Ihr Schmerzempfinden.','center',heightText+t.disp.lineheight,t.disp.white);
    [~, heightText]=DrawFormattedText(t.disp.wHandle,' ','center', heightText+t.disp.lineheight,t.disp.white);
    [~, heightText]=DrawFormattedText(t.disp.wHandle,'Sie werden vor jedem Block dar�ber informiert,','center',heightText+t.disp.lineheight,t.disp.white);
    [~, heightText]=DrawFormattedText(t.disp.wHandle,'welche Intensit�t der Behandlung Sie erhalten.','center',heightText+t.disp.lineheight,t.disp.white);
    [~, heightText]=DrawFormattedText(t.disp.wHandle,' ', 'center', heightText+t.disp.lineheight, t.disp.white);
    [~, heightText]=DrawFormattedText(t.disp.wHandle,'Ein Block besteht jeweils aus:','center', heightText+t.disp.lineheight,t.disp.white);
    [~, heightText]=DrawFormattedText(t.disp.wHandle,'8 Reize TENS AUS','center',heightText+t.disp.lineheight,t.disp.white);
    [~, heightText]=DrawFormattedText(t.disp.wHandle,'8 Reize TENS EIN','center',heightText+t.disp.lineheight,t.disp.white);
elseif section == 4
    if strcmp(t.disp.hostname,'stimpc1')
        keyMoreLessPainful = 'des linken/rechten Knopfes';
        keyConfirm = 'dem mittleren oberen Knopf';
    else
        keyMoreLessPainful = 'der linken/rechten Pfeiltaste';
        keyConfirm = 'der Eingabetaste';
    end
    heightText = t.disp.startY-t.disp.lineheight;
    [~, heightText]=DrawFormattedText(t.disp.wHandle,['Bitte bewerten Sie jeden Reiz mithilfe ' keyMoreLessPainful], 'center',heightText,t.disp.white);
    [~, heightText]=DrawFormattedText(t.disp.wHandle,['und best�tigen mit ' keyConfirm '.'],'center', heightText+t.disp.lineheight,t.disp.white);
    [~, heightText]=DrawFormattedText(t.disp.wHandle,' ', 'center', heightText+t.disp.lineheight, t.disp.white);
    [~, heightText]=DrawFormattedText(t.disp.wHandle,'Es ist SEHR WICHTIG, dass Sie JEDEN der Reize bewerten!','center',heightText+t.disp.lineheight, t.disp.white);
elseif section == 5
    fprintf('Ready CHANGE THERMODE POSITION protocol.\n');
    heightText = t.disp.startY-t.disp.lineheight;
    [~, heightText]=DrawFormattedText(t.disp.wHandle,'Die Thermode wird nun umgesetzt','center',heightText,t.disp.white);
    [~, heightText]=DrawFormattedText(t.disp.wHandle,' ','center', heightText+t.disp.lineheight,t.disp.white);
    [~, heightText]=DrawFormattedText(t.disp.wHandle,'Danach testen wir noch einmal in einem Block die','center',heightText+t.disp.lineheight,t.disp.white);
    [~, heightText]=DrawFormattedText(t.disp.wHandle,'mittelstarke Behandlung','center', heightText+t.disp.lineheight,t.disp.white);
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

introTextTime = Screen('Flip',t.disp.wHandle);

fprintf('Displaying instructions...');
countedDown = 1;

while 1
    [keyIsDown, ~, keyCode] = KbCheck();
    if keyIsDown
        if find(keyCode) == t.keys.name.confirm
                break
        elseif find(keyCode) == t.keys.name.esc
            abort=1;
            break
        end
    end
    
    if displayDuration == 1
        [countedDown] = CountDown(GetSecs-introTextTime,countedDown,'.');
    end
end

if displayDuration == 1
    fprintf('\nInstructions were displayed for %d seconds.\n',round(GetSecs-introTextTime,0));
    Screen('Flip',t.disp.wHandle);
end

if abort
    QuickCleanup(t.com.thermoino);
    return;
end

end