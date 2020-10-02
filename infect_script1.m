clear all
boundary = [0 10]; % box boundaries (square)
pos = boundary(1) + boundary(2)*rand(1000,2); %position of balls
Nframes = 500; % number of frames
infec = 1:10; % initial infection (use rate for random)
rectime = 100;% number of frames to recover

Nsets = 6; % number of sets for GA
Ngens = 2; %number of gens for GA

% GA to minimse infection
[~,step] = minimiseInfection(Nframes,Nsets,Ngens,boundary,pos,infec,rectime);

% Show animation of best result
[H,I,C,R] = runInfection(Nframes,boundary,pos,step{1},'Plot',true,'Infected',infec,'Recovery time',rectime);