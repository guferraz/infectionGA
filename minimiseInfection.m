function [genscore,step] = minimiseInfection(Nframes,Nsets,Ngens,boundary,pos,infec,rectime)


% Initial set of velocities
bv = 0.1; % base velocity
for ni = 1:Nsets
    stp = bv*randi([-1 1],size(pos));
    stp = bv*(-1 + 2*rand(size(pos)));
    %stp(stp==0) = bv;
    step{ni} = stp;
    posi{ni} = pos;
end

%
figure('color','w'),

for g = 1:Ngens
    subplot(121), cla
    % simulate and score each set
    for ni = 1:Nsets
        [~,I,~,~] = runInfection(Nframes,boundary,pos,step{ni},'Infected',1:10,'Recovery time',rectime);
        score(ni) = max(I); 
        %score(ni) = 1/R(end).^6; 
        subplot(121), plot(I), hold on
        xlabel('frames'), ylabel('infected');
        title([g ni])
        drawnow
    end
    % rank sets and perform crossover to make next gend
        [score,rank] = sort(score);
        step = step(rank);
        step = step(1:end/2);
        [step ~] = crossOver(step);
        genscore(g) = score(1);
        subplot(122),plot(1:g,genscore,'-o')
        xlabel('generation'), ylabel('Max. infected')
        drawnow
end