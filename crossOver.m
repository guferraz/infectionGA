function [newstep, newpos] = crossOver(step,pos)

for i=1:length(step)
    %child{i} = 2*(step{i}.*step{end-i+1})./((step{i}+step{end-i+1}));
    parents = randi(length(step),2,1);
    childstep{i} = 10*(step{parents(1)}.*step{parents(2)});
end

newstep = [step childstep];

if nargin > 1
    for i=1:length(pos)
    %child{i} = 2*(step{i}.*step{end-i+1})./((step{i}+step{end-i+1}));
    parents = randi(length(pos),2,1);
    childpos{i} = 10*(pos{parents(1)}.*pos{parents(2)});
    end
    newpos = [pos childpos];
else
    newpos = [];
end