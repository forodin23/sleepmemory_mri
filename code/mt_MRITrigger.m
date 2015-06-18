function timeStartExp = mt_MRITrigger()
    % Listen to keyboard event ENTER
    KeyEventMRITrigger  = KbName('w');
    keyVector = zeros(256,1);
    keyVector(KeyEventMRITrigger) = 1;
    KbQueueCreate;
    KbQueueStart;
    timeStartExp = '';
    
    while isempty(timeStartExp)
        % abort if ENTER was pressed in between
        [~, ~, ~, lastPress, ~]=KbQueueCheck;
        if lastPress(KeyEventMRITrigger)
            timeStartExp = {datestr(now, 'HH:MM:SS.FFF')}; % TODO: save to log
            break;
        end
    end
end