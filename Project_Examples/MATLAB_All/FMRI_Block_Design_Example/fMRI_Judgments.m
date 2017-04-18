

% written for Psychtoolbox 3  by Sara List 01/17/2017

% Pilot_Spacetime_fMRI_block_2(2,1,1, 0.5, 0.5, 52, 1)
function fMRI_Judgments(test, subj_id, run)

%Input numbers
%Test = 1 is testing mode
%Any other number is debugging mode with smaller screen

try
    
% Running on PTB-3? Abort otherwise.
AssertOpenGL;
    %UNCOMMENT the following line FOR TESTING SUBJECTS
% Screen('Preference', 'SkipSyncTests', 0);

% Use the following lines to see when the trials started
% a = subj_data.probe_onset;
% b = subj_data.start_time;
% c = a - subj_data.start_time;
% d = c - (subj_data.delay);
% e = subj_data.fix_onsets-b;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%STUFF to change

screenNum = 0; % Which screen you want to use.
my_key = '1!'; % What key gives a response. Corresponds to the response buttons blue, yellow, green, red (1,2,3,4 from index to pinky using right hand)
my_key_2 = '2@';
my_key_3 = '3#';
my_key_4 = '4$';
my_key_5 = '5%';
my_key_6 = '6^';
my_key_7 = '7&';
my_trigger = 't'; % What key triggers the script from the scanner.
% my_continue = 'x'; %What key is pressed to end the practice.
do_suppress_warnings = 1; % You don't need to do this but I don't like the warning screen at the beginning.
DATA_DIR = [pwd filesep 'data']; % Where the subj_data will be saved.

stim_font_size = 100; % We started at 150, but that was too large on the 13" monitor.

isMac =1;



%Acquisition time will be the time the scanner is acquiring volumes
Acq_Time = 2.00;  %8/15/16 Kate set the protocol to have a 3.110 s acquisition time
%3/8/17 We are now continuous sampling as of 2/21/17, so Acq_Time = the TR

%How long is the longest sound? Not critical, can be fudged for this
%experiment
stim_duration = 0.6;

%How long after aquisition ends will we wait for the scanner to become
%quiet so we can play the sound?
hush_scan = 0.250;

%Delay after the beginning of a trial before the sound will play
% delay = Acq_Time + hush_scan;
delay = hush_scan;
%How much time do you have to tweak for your particular machine to display
%things when you want it to?

flex_time = 0.032;

%Makes the data processing go faster for image loading
filtermode = 0;

% 
% function [key, rt] = WaitLookingForKeys(keys, timeOut, start)
% 
%    % Initialize variables
%    rt = 0;
%    key = 0;
%    qKey = KbName('q');
%    
%    % Wait for the key until timeOut
%    while (GetSecs < timeOut)
% 		[keyIsDown, secs, keyCode] = KbCheckM;
%         if any(keyCode(keys))
%             rt = secs - start;
%             key = find(keyCode ~= 0, 1);
% 			key = find(keys == key);
% 		end
% 		if keyCode(qKey)
% 			sca;
% 			error('User quit');
% 		end
%    end





%% Some checks to perform


time = clock; %Current date and time as date vector. [year month day hour minute seconds]




file_to_save = ['Judgments_Kete_Teke_Multi_subj_' num2str(subj_id) '_run_' num2str(run)  '_data.mat']; 

% Error message if data file already exists.
if exist([DATA_DIR filesep file_to_save],'file');
    
    error('The data file already exists for this subject!');
end



clear subj_data

subj_data.time = time;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Which device are you seeking responses from? I may need to change this
%somehow for the response box....
deviceIndex = 1;

%3/8/17 :: As of 2/21/17, we are now continuous sampling, so T_R = stimulus
%repetition time
T_R = Acq_Time + 1.250;
STIM_DIR = [pwd filesep 'Kete_Teke']; % Where all the stimuli are.
Sound_DIR = [STIM_DIR filesep 'Sounds_Judge'];
Image_DIR = [STIM_DIR filesep 'Images_Judge'];
Run_DIR = [pwd filesep 'Judgments_Runs.mat'];
Rest_DIR = [pwd filesep 'Judgments_Blanks.mat'];
% Choose run TR
% 
%%%Attend auditory runs are indexed below:
attend_aud_vis = [1,3];
%%%Attend visual runs are 2 and 4.
if ismember(run,attend_aud_vis)
        subj_data.attend_which = 'Auditory';
else
        subj_data.attend_which = 'Visual';
end
% switch run
%     case 1;
%         T_R = 6;
%         STIM_DIR = [pwd filesep 'Words_for_block' filesep 'Run_1']; % Where all the stimuli are.
%         
%         nfiles = 14;
%         no_repeats = ones(nfiles,1)*3;  %Matrix for the number of repeats per sound
%         no_repeats(3) = 1;
%         no_repeats(4) = 2;
%         no_repeats(5) = 2;
%         no_repeats(6) = 1;
%         
%     case 2;
%         T_R = 7;
%         STIM_DIR = [pwd filesep 'Words_for_block' filesep 'Run_2']; % Where all the stimuli are.
%        
%         nfiles = 15;
%         no_repeats = ones(nfiles,1)*3;  %Matrix for the number of repeats per sound
%         no_repeats(3) = 1;
%         no_repeats(4) = 1;
%         no_repeats(5) = 1;
%         no_repeats(14) = 2;
%         no_repeats(15) = 1;
%       
%     case 3;
%         T_R = 8;
%         STIM_DIR = [pwd filesep 'Words_for_block' filesep 'Run_3']; % Where all the stimuli are.
%         

%         no_repeats(1) = 1;
%         no_repeats(2) = 2;
        
%         
% end




rest_duration = T_R/2 ;



%True/False; did the subject respond?
did_subj_respond = 0;

%Index for responses
r_count = 1;


subj_data.id = subj_id;

%Which run is it? Corresponds to the TR..See Switch/case above
subj_data.run = run;

%Design matrix of the trials
% [mixtr, trmat, mixtr_block] = design_matrix_Kete_Teke();
%Now we have set runs!
mixtr_keep = load(Run_DIR);
mixtr_keep = mixtr_keep.mixtr_keep_3;
mixtr = mixtr_keep(:,:,run);

subj_data.trials_presented = mixtr;
% subj_data.trials_unsorted = trmat;

num_of_fix = 2;

total_vols = size(find(mixtr(:,1)~=0),1)+num_of_fix;

num_of_trials = total_vols;


subj_data.did_respond = zeros(num_of_trials,1);
%Onset of the stimulus (here a sound) to which subjects should respond
subj_data.probe_onset = zeros(num_of_trials,1);
%Response time of the subject to that stimulus
subj_data.probe_response = zeros(num_of_trials,1);
%Onset of the active trial 
subj_data.trial_onsets = zeros(num_of_trials,1);
%Onset of the rest/fixation block
subj_data.fix_onsets = zeros(num_of_fix,1);

        
%         no_repeats = (subj_data.trials_presented(:,);  %Matrix for the number of repeats per sound

%Which indices are going to be rest/fixation blocks?
% rest_trial_num = ones((num_of_fix-1),1)*4;
% rest_trial_num = vertcat(1,rest_trial_num);
% rest_trial_num = cumsum(rest_trial_num);
rest_trial_num = load(Rest_DIR);
rest_trial_num = rest_trial_num.blanks;
rest_trial_num = rest_trial_num(:,run);


subj_data.rest_trials = rest_trial_num;

%Which sounds played at each active trial?
subj_data.which_sound = [];

%When will each active trial and each rest trial begin?
trial_onset = zeros(num_of_trials,1);
% for i = 2:size(trial_onset,1)
% trial_onset(i) = T_R + trial_onset(i-1);
% if ismember(i,(subj_data.rest_trials+1))
%     %USE the line below for fMRI and set rest_duration to T_R*2
% trial_onset(i) = trial_onset(i) + T_R;
% % USE this line if doing psychophysics and set rest_duration to T_R/3
% % trial_onset(i) = trial_onset(i)- 2*(T_R/3);
% end
% end
num_vol = 0;
for i = 1:size(trial_onset,1)

            trial_onset(i) = num_vol + delay;%Acq_Time
            num_vol = num_vol + T_R;
end 


run_time_total = T_R * total_vols;
trial_onset(num_of_trials +1) = run_time_total;
trial_onset = trial_onset - flex_time;
subj_data.trial_onsets = trial_onset;

subj_data.start_time = 0;
subj_data.end_time = 0;
subj_data.run_time_total = 0;

subj_data.flex_time = flex_time;


% Save all data to current folder.
save([DATA_DIR filesep file_to_save], 'subj_data');




% Enable unified mode of KbName, so KbName accepts identical key names on
% all operating systems:


% Setting this preference to 1 suppresses the printout of warnings.
oldEnableFlag = Screen('Preference', 'SuppressAllWarnings', do_suppress_warnings);

    KbName('UnifyKeyNames'); %used for cross-platform compatibility of keynaming

colBG = [0 0 0]; % color of the background is black
scrAll = Screen('Screens');
scrNum = max(scrAll);
if test ==1
[wPtr, rect]=Screen('OpenWindow',scrNum, colBG);  % open screen in testing mode
else
[wPtr, rect]=Screen('OpenWindow',scrAll, colBG, [0 0 640 480]);  % open screen in debugging mode
end


%Hide the cursor during testing
HideCursor();




%Screen('FillRect', wPtr, colBG)

FlipInt=Screen('GetFlipInterval',wPtr); %Gets Flip Interval
subj_data.Flip_Interval = FlipInt;
FlipInt_flex_time = FlipInt;

priorityLevel = MaxPriority(wPtr);Priority(priorityLevel);


fixation = '+';
textcolor = [255 255 255]; %color of the text is white
attn_color = [0 255 0]; %color of the fixation cross is green during attention trials


%Y and X text positions, can be left, right, center, or a pixel number
xtextpos = 'center';
ytextpos = 'center';


%Load the list of images

img_filenames = [];
img_filenames = getAllFileNames(Image_DIR); 


%Remove spurious .DS_Store file from output if it's a Mac
   if isMac ==1
%        Analyzed_files_list = Analyzed_files_list(2:end,:);
img_filenames = img_filenames(cellfun('isempty', strfind(img_filenames,'.DS_Store'))) ;
   end



% Pre-draw the images
% if run == 2|| run == 5|| run == 6
%Only 2 images here
    which_image = rot90(fullfact([2 3]),2) ;
    nfiles_img = size(img_filenames,1);
% else
% which_image = rot90(fullfact([2 3]),2) ; %Puts the 4 images into indices 1-4, since design matrix calls coordinate pairs
% which_image(7:8,:) = which_image(1:2,:);
% which_image = which_image(3:8,:);
% nfiles_img = size(img_filenames,1);
% end

for g = 1:nfiles_img
img{g}=imread([Image_DIR filesep img_filenames{g,1}], 'BMP');
y = which_image(g,:);
% eval(sprintf('ImageIndex_%d = []', g));
ImageIndex(y(1), y(2)) = Screen('MakeTexture', wPtr,(img{1,g}), [], 32);

end

center=[rect(3)/2 rect(4)/2];

imgheight =  size (img{1,2}, 1); % first dimension; scale the image down to 1/2 size = /2
imgwidth = size (img{1,2}, 2); % second dimension; scale the image down to 1/2 size = /2

%Number of pixels to off-center the stim in the x and y direction
x = 188 - (imgwidth/2);
y = 0;

Image_names = cell(size(find(mixtr(:,1)~=0),1));

for c  = 1:size(find(mixtr(:,1)~=0),1)
    
 t = mixtr(c,4)==which_image(:,1) & mixtr(c,5)==which_image(:,2);
Image_names{c,1} = img_filenames{t,1};
end

ImRect = [center(1)-imgwidth/2, center(2)-imgheight/2+y,  center(1)+imgwidth/2,  center(2)+imgheight/2+y] ;

subj_data.Images_presented = Image_names;

% Load the list of sounds

wavfilenames = [];
wavfilenames = getAllFileNames(Sound_DIR); 

%Remove spurious .DS_Store file from output if it's a Mac
   if isMac ==1
%        Analyzed_files_list = Analyzed_files_list(2:end,:);
wavfilenames = wavfilenames(cellfun('isempty', strfind(wavfilenames,'.DS_Store'))) ;
   end
    
    
nfiles = size(find(mixtr(:,1)~=0),1);%length(wavfilenames);%Nfiles is the number of sound files you want presented
which_wav = rot90(fullfact([2 3]),2) ; %Puts the 4 wavefiles into indices 1-4, since design matrix calls coordinate pairs

%If you only have two sounds...
% which_wav = which_wav([1,3],:);


% Always init to 2 channels, for the sake of simplicity:
nrchannels = 2;

% Does a function for resampling exist?
if exist('resample') %#ok<EXIST>
    % Yes: Select a target sampling rate of 44100 Hz, resample if
    % neccessary:
    freq = 44100;
    doresample = 1;
else
    % No. We will choose the frequency of the wav file with the highest
    % frequency for actual playback. Wav files with deviating frequencies
    % will play too fast or too slow, b'cause we can't resample:
    % Init freq:
    freq = 0;
    doresample = 0;
end 
    
    

 InitializePsychSound(1); %inidializes sound driver...the 1 pushes for low latency
 
 
 % Read all sound files and create & fill one dynamic audiobuffer for
% each read soundfile:
buffer = [];
j = 0;
sound = 1;

% pract_data_all = cell(1,4);
% for k = 1:length(wavfilenames)
%         file = wavfilenames(k,:);
%         [pract_data, infreq] = psychwavread(char((file)));
%            pract_data = resample(pract_data, freq, infreq);
%         [samplecount, ninchannels] = size(pract_data);
%         pract_data = repmat(transpose(pract_data), nrchannels / ninchannels, 1);
%         pract_data_all{k} = pract_data(:,:);
% 
% end






for i=1:nfiles
    try
        % Make sure we don't abort if we encounter an unreadable sound
        % file. This is achieved by the try-catch clauses...
        file = find(mixtr(i,2)==which_wav(:,1) & (mixtr(i,3)==which_wav(:,2)));
        [audiodata, infreq] = psychwavread(char(wavfilenames(file)));
        dontskip = 1;
    catch
        fprintf('Failed to read and add file %s. Skipped.\n', char(wavfilenames(file)));
        dontskip = 0;
        psychlasterror
        psychlasterror('reset');
    end

    if dontskip
        j = j + 1;

        if doresample
            % Resampling supported. Check if needed:
            if infreq ~= freq
                % Need to resample this to target frequency 'freq':
                fprintf('Resampling from %i Hz to %i Hz... ', infreq, freq);
                audiodata = resample(audiodata, freq, infreq);
            end
        else
            % Resampling not supported by Matlab/Octave version:
            % Adapt final playout frequency to maximum frequency found, and
            % hope that all files match...
            freq = max(infreq, freq);
        end

        [samplecount, ninchannels] = size(audiodata);
        audiodata = repmat(transpose(audiodata), nrchannels / ninchannels, 1);
%         for repeat = 1:no_repeats(j)
        buffer(end+1) = PsychPortAudio('CreateBuffer', [], audiodata); %#ok<AGROW>
        [fpath, fname] = fileparts(char(wavfilenames(file)));
        fprintf('Filling audiobuffer handle %i with soundfile %s ...\n', buffer(j), fname);
        subj_data.which_sound{sound,1} = fname;
        sound = sound + 1;
%         end
    end
end

% Recompute number of available sounds:
nfiles = length(buffer);


% pahandle = PsychPortAudio('Open', [], [], 1, freq, nrchannels);


%%%%%%%%%%%%%%PRACTICE!!!!%%%%%%%%%%%%%%%%%%%%%%%

% Screen('TextFont',wPtr,'Courier New');
%  
% Screen('TextStyle', wPtr, 1);
% Screen('TextSize', wPtr , 100);
% DrawFormattedText(wPtr,'Practice',xtextpos,100, textcolor);
% Screen(wPtr, 'Flip');


% Get practice


% while 1,
% %     PsychPortAudio('Stop', pahandle); %starts sound immediately
% 
% %Skeleton
% for prac_no = 1:no_prac
%     %play the sound/image 1:4
%     %then play 1:4 2 more times
%     %give chance to respond and move forward
%     %correct or no?
%     %Feedback = good/oops
% end
% 
% 
%         practice= getKeyResponse(my_key, my_key_2, my_key_3, my_key_4, my_continue, r_count);
%         if practice == 5
%             break
%         elseif practice~=0
%             DrawFormattedText(wPtr, fixation, xtextpos, ytextpos, textcolor);
%             play = (pract_data_all{1,practice});
%             practice = 0;
%             PsychPortAudio('FillBuffer', pahandle, play); % loads data into buffer
% % repetitions=5; % how many repititions of the sound 
% 
% PsychPortAudio('Start', pahandle); %starts sound immediately
% Screen('Flip',wPtr); %swaps backbuffer to frontbuffer
% WaitSecs(0.5);
% PsychPortAudio('Stop', pahandle); %stops sound immediately
%         end
    
%     % Wait for yieldInterval to prevent system overload.
%     WaitSecs('YieldSecs', 0.0001);
% end



% PsychPortAudio('Close', pahandle);





%       KbQueueFlush(deviceIndex);
fix = 1;
fixation_trial_ind = 1;      
sound_stim = 1;


% Open the default audio device [], with default mode [] (==Only playback),
% and a required latencyclass of 1 == standard low-latency mode, as well as
% a playback frequency of 'freq' and 'nrchannels' sound output channels.
% This returns a handle 'pahandle' to the audio device:
pahandle = PsychPortAudio('Open', [], [],[], freq, nrchannels);

PsychPortAudio('DirectInputMonitoring', pahandle, 1);


% Enable use of sound schedules: We create a schedule of default size,
% currently 128 slots by default. From now on, the driver will not play
% back the sounds stored via PsychPortAudio('FillBuffer') anymore. Instead
% you'll have to define a "playlist" or schedule via subsequent calls to
% PsychPortAudio('AddToSchedule'). Then the driver will process that
% schedule by playing all defined sounds in the schedule, one after each
% other, until the end of the schedule is reached. You can add new items to
% the schedule while the schedule is already playing.
PsychPortAudio('UseSchedule', pahandle, 1);

%%%%%%%%%%%%%%Pull the TRIGGER%%%%%%%%%%%%%%%%%%%%%%%
Screen('TextFont',wPtr,'Courier New');
 
Screen('TextStyle', wPtr, 1);
Screen('TextSize', wPtr , 100);
DrawFormattedText(wPtr,'Waiting to begin...',xtextpos,ytextpos, textcolor);
Screen(wPtr, 'Flip');





% Get trigger from scanner.
DrawFormattedText(wPtr,fixation,xtextpos,ytextpos, textcolor); %Fixation cross
while 1,
    [keyIsDown,d,keyCode]=KbCheck;
    if keyIsDown
        response=find(keyCode);
        if response==KbName(my_trigger);
            break;
        end
    end
    % Wait for yieldInterval to prevent system overload.
    WaitSecs(0.0001);
end


subj_data.run_onset = GetSecs;
% starttime = subj_data.run_onset;

%%%%%%%%%%%%%%Pulled the TRIGGER and begin Experiment NOW %%%%%%%%%%%%%%%%%%%%%%%





    for trial=1:num_of_trials %runs through trials

             if trial ~= 1,
         r_count = r_count + 1;
        starttime = subj_data.start_time+ subj_data.trial_onsets(trial);
             else
                 %Set the starttime base
         subj_data.start_time = GetSecs; 
         Screen('Flip', wPtr, subj_data.start_time-FlipInt_flex_time,1);
         
         starttime = GetSecs + subj_data.trial_onsets(trial);
         
             end
             
          
          
    did_subj_respond = 0;
    
                if trial == subj_data.rest_trials(fixation_trial_ind)
                    
           %Rest Block Here

                DrawFormattedText(wPtr,fixation,xtextpos,ytextpos, textcolor); %Rest block turns green
           starttime = Screen('Flip', wPtr, starttime-FlipInt_flex_time,1);
           subj_data.fix_onsets(fix)= starttime;
           fix = fix +1;
           fixation_trial_ind = fixation_trial_ind +1;
           next_trial_time = subj_data.start_time + subj_data.trial_onsets(trial+1);
           
           while GetSecs <  next_trial_time %%%%%%%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            %Wait here until the Rest Block has ended
            WaitSecs(0.001);
           end
        

%         vbl =  Screen('Flip',wPtr,starttime-FlipInt_flex_time + rest_duration); %swaps backbuffer to frontbuffer; gets rid of "REST"
                Screen('Close');
            vbl=Screen('Flip',wPtr, (next_trial_time) - FlipInt_flex_time); %erases the stimulus
                 subj_data.end_time = vbl;
         

         
       else      %If the index of the trial is not a fixation trial/rest block, then it's an active trial in an active block
        
  


           next_trial_time = subj_data.start_time + subj_data.trial_onsets(trial+1);
            % Schedule finished from the last trial. Before adding new
                % slots we first must delete the old ones, ie., reset the
                % schedule:
             
            PsychPortAudio('UseSchedule', pahandle, 2);

            PsychPortAudio('AddToSchedule', pahandle, buffer(sound_stim), 1, 0.0, stim_duration, 1);
            
            %Add a unisensory visual block type; silence potential sound
            if mixtr(sound_stim,1) ~=5
 
            PsychPortAudio('Volume',pahandle,0.5,[]);
            else
            PsychPortAudio('Volume',pahandle,0.0,[]);
            end
            
            
            


                        %Present the fixation cross:


                 DrawFormattedText(wPtr, fixation, xtextpos, ytextpos, textcolor);
                 starttime =  Screen('Flip',wPtr, starttime-FlipInt_flex_time); %swaps backbuffer to frontbuffer
                PsychPortAudio('Start', pahandle,1,inf); %starts sound at infinity so it's ready to play
                timedstart = starttime + delay;
                
                %Present image
                %Make unisensory auditory blocks by presenting the fixation
                %instead of the image...
                if mixtr(sound_stim, 1) ~=6
     Screen('DrawTexture', wPtr, ImageIndex(mixtr(sound_stim, 4),mixtr(sound_stim, 5)), [], ImRect, [], filtermode);
                else
               DrawFormattedText(wPtr, fixation, xtextpos, ytextpos, textcolor);
                end
            timedstart = Screen('Flip',wPtr, timedstart - FlipInt_flex_time); %swaps backbuffer to frontbuffer
            DrawFormattedText(wPtr, fixation,xtextpos, ytextpos, textcolor);
%                 WaitSecs(0.001);
    PsychPortAudio('RescheduleStart', pahandle, timedstart , 0); %reschedules startime to the desired time
    
    
    subj_data.probe_onset(trial) = timedstart;
           sound_stim = sound_stim + 1;
        
        
        Flipped_it = 0;
        while GetSecs < (next_trial_time)

        endtime = GetSecs;



        if endtime >(timedstart + 0.0001) %Don't record responses until the sound has at least started playing

        if did_subj_respond == 0,
            did_subj_respond = getKeyResponse(my_key, my_key_2, my_key_3, my_key_4,my_key_5, my_key_6, my_key_7, r_count);
        else
            if Flipped_it==0
            Screen('Flip',wPtr, (timedstart + stim_duration - FlipInt_flex_time)); %erases the stimulus
             Flipped_it = 1;
            end
            break
        end
%         WaitSecs( 0.001);
        

        end
           if Flipped_it ==0 && endtime >= (timedstart + stim_duration - FlipInt_flex_time)
                       Screen('Flip',wPtr, (timedstart + stim_duration - FlipInt_flex_time)); %erases the stimulus
                       Flipped_it = 1;
           end
%         
        end
       
                          %Mark the response of the participant
                    subj_data.did_respond(r_count) = did_subj_respond;
                  DrawFormattedText(wPtr, fixation,xtextpos, ytextpos, textcolor);
                   vbl=Screen('Flip',wPtr, (next_trial_time) - FlipInt_flex_time); %erases the stimulus
                   
        PsychPortAudio('Stop',pahandle, [],[],[],(timedstart+stim_duration));
        Screen('Close');
        
    end %End of REST or Active Trials Loop    

% Save all data to current folder.
save([DATA_DIR filesep file_to_save], 'subj_data');

    end
    
    
    
    
    
  PsychPortAudio('Stop', pahandle);
  PsychPortAudio('Close', pahandle);
  Screen('Flip', wPtr);  
  Screen('TextSize',wPtr, 35);
   DrawFormattedText(wPtr, 'Congratulations, you are done!', xtextpos, ...
    ytextpos, textcolor);
    Screen('Flip', wPtr);
    WaitSecs(2);


% Get reaction time.
subj_data.rt = zeros(num_of_trials,1);
responses = find(subj_data.did_respond);
subj_data.rt(responses) = subj_data.probe_response(responses) - subj_data.probe_onset(responses);
subj_data.run_time_total =  subj_data.end_time - subj_data.start_time;

%Save additional variables
subj_data.delay = delay;
subj_data.Acq_Time = Acq_Time;
subj_data.hush_scan = hush_scan;


subj_data.realtime_stim_onsets = subj_data.probe_onset - subj_data.start_time;
subj_data.realtime_trial_onsets = subj_data.realtime_stim_onsets - subj_data.delay;
subj_data.realtime_fix_onsets = subj_data.fix_onsets - subj_data.start_time;

% Save all data to current folder.
save([DATA_DIR filesep file_to_save], 'subj_data');


ShowCursor(); %shows the cursor
ListenChar(0); %makes it so characters typed do show up in the command window 
Screen('CloseAll'); %Closes Screen
% clear all
% clear mex

catch error
%     PsychPortAudio('Close', pahandle);
    Screen('CloseAll')
       ShowCursor
%     KbQueueRelease(deviceIndex);
    rethrow(error)
    
        subj_data.did_respond(r_count) = did_subj_respond;
    
   
 
    % Get reaction time.
    subj_data.rt = zeros(num_of_trials,1);
    responses = find(subj_data.did_respond);
    subj_data.rt(responses) = subj_data.probe_response(responses) - subj_data.probe_onset(responses);
    subj_data.run_time_total = subj_data.start_time - subj_data.end_time;
    % Save all data to current folder.
    save([DATA_DIR filesep file_to_save], 'subj_data','error');
    
    
end

% Setting this preference to 1 suppresses the printout of warnings.
Screen('Preference', 'SuppressAllWarnings', oldEnableFlag);

%%
% % % % % % % %
% SUBFUNCTION %
% % % % % % % %

    function out = getKeyResponse(my_key, my_key_2, my_key_3, my_key_4,my_key_5, my_key_6, my_key_7, r_count)
        KEY1=KbName(my_key);
        KEY2 = KbName(my_key_2);
        KEY3 = KbName(my_key_3);
        KEY4 = KbName(my_key_4);
        KEY5 = KbName(my_key_5);
        KEY6 = KbName(my_key_6);
        KEY7 = KbName(my_key_7);
%         KEY5 = KbName(my_continue);
%         key = 0;
        [keyIsDown,d,keyCode]=KbCheck;
        if keyIsDown
            response=find(keyCode);
            if response==KEY1
                out = 1;
                subj_data.probe_response(r_count) = d;
            elseif response==KEY2
                out = 2;
                subj_data.probe_response(r_count) = d;
            elseif response==KEY3
                out = 3;
                subj_data.probe_response(r_count) = d;
            elseif response==KEY4
                out = 4;
                subj_data.probe_response(r_count) = d;
            elseif response==KEY5
                out = 5;
                subj_data.probe_response(r_count) = d;
            elseif response==KEY6
                out = 6;
                subj_data.probe_response(r_count) = d;
            elseif response==KEY7
                out = 7;
                subj_data.probe_response(r_count) = d;

            else
                out = 0;
            end
        else
            out = 0;
        end
    end





end

%%%%%%%%%%%  Want more Psychtoolbox resources?  %%%%%%%%%%%
%  Borrowed from https://github.com/Psychtoolbox-3/Psychtoolbox-3/wiki/Cookbook%3A-Seitz-Tutorial-Experiments
%  and from http://www.martinszinte.net/Martin_Szinte/Teaching_files/Prog_c4.pdf
%  and from Dr. Ev Fedorenko's language localizer : https://evlab.mit.edu/alice
%For later, code to detect a trigger from fMRI:
% ftp://ftp.tuebingen.mpg.de/pub/pub_dahl/stmdev10_D/Matlab6/Toolboxes/Psychtoolbox/PsychDocumentation/KbQueue.html
%Detecting your button box
%http://cbs.fas.harvard.edu/science/core-facilities/neuroimaging/information-investigators/matlabfaq#device_num
%http://bradylab.ucsd.edu/matlab.html

%Other demos
%Cookbook Psychtoolbox and stuff from this website:
%http://peterscarfe.com/accuratetimingdemo.html

% Here is some great advice in how to think about timing for coding
% http://lindeloev.net/?page_id=50

