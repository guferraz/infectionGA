function [H,I,C,R] = runInfection(N,boundary,pos,step,varargin)

I = zeros(1,N);
H = zeros(1,N);
C = zeros(1,N);  


for j= 1:2:length(varargin)
    switch varargin{j}
		case 'Rate'
			% randon infection seed
            rate = varargin{j+1};
            seed = randi(length(pos),round(rate*length(pos)),1);
        case 'Infected'
            % fixed infection seed
            seed = varargin{j+1};
        case 'Recovery time'
            trec = varargin{j+1};
        case 'ColourMap'
            cmap = varargin{j+1};
        case 'Plot'
            doplot = varargin{j+1}; 
        case 'Output file'
            filename = varargin{j+1};
        otherwise
			error('Unknown parameter name');
    end
end

if(~exist('cmap')),     cmap = lines(4);          end
if(~exist('filename')), filename = 'results.gif'; end
if(~exist('doplot')),   doplot = 0;               end
if(~exist('trec')),     trec = 100;               end
if(~exist('seed')),     seed = 1:10;              end


sz = 40*ones(length(pos),1); % Size distribution for scatter plot (not in use) but also used as identifier for infection
key = repmat(cmap(1,:),length(pos),1);

key(seed,:) = repmat(cmap(2,:),length(seed),1);
sz(seed) = 41;

% Royal option
%royal = randi(length(pos),100,1);
%key(royal,:) = repmat(cmap(4,:),length(royal),1);
%sz(royal) = 39;

tinf = 0*sz; % time since infection

if doplot
    f = figure('color','w','Position',[500 40 400 450]);
    ax1 = subplot(3,1,[1 2],'Parent',f,'Color','w');
    ax2 = subplot(313,'Parent',f,'Color','w');    
end

for i=1:N 
    if doplot
        cla(ax1)
        scatter(ax1,pos(:,1),pos(:,2),60,key,'filled','MarkerFaceAlpha',0.6),  hold(ax1,'on')
        scatter(ax1,pos(:,1),pos(:,2),5,'k','filled'),
        set(ax1,'Color','w','visible','off')
        axis(ax1,[0 boundary(2) 0 boundary(2)],'square')         
    end
    
    % out of bounds
    out = find(pos(:) >= boundary(2) | pos(:) <= boundary(1));
    step(out) = -step(out);   
    pos = pos + step;
    
    % check distances and change velocity/infection status if two have met
    for n = 1:length(pos)
        dx = abs(pos(n,1) - pos(:,1));
        dy = abs(pos(n,2) - pos(:,2)); 
        dx(n) = NaN; dy(n) = NaN;
        met = find(dx < .2 & dy < .2);
        
        if (~isempty(met) &&...
           (~isempty(find(sz(met) == 41)) || sz(n) == 41))% &&...
           %(isempty(find(sz(met) == 42)) || sz(n) ~= 42))
            step(met,:) = -step(met,:); 
            %step(met,:) = 0; 
            key(met,:) = repmat(cmap(2,:),length(met),1);
            sz(met) = 41;           
            %tinf(met) = 0;
        else
            step(met,:) = -step(met,:);
        end
           
    end
    
    % update time since infection for each infected
    tinf(sz == 41) = tinf(sz==41) + 1;
    cur = find(tinf > trec);
    sz(cur) = 42;
    key(cur,:) = repmat(cmap(3,:),length(cur),1);
    
    % get stats (based on size variable)
    I(i) = sum(sz == 41);
    H(i) = sum(sz == 40);
    C(i) = sum(sz == 42);
    R(i) = sum(sz == 39); % only for royals case
    
    
    if doplot
        if nargin >=10
            cla(ax2)
            area(ax2, 1:i,H(1:i),'FaceAlpha',0.6,'EdgeColor','none'), hold(ax2,'on')
            area(ax2, 1:i,I(1:i),'FaceAlpha',0.6,'EdgeColor','none')
            area(ax2, 1:i,C(1:i),'FaceAlpha',0.6,'EdgeColor','none')
            xlim(ax2,[0 N])
            set(ax2,'Color','w','visible','off')
            ylabel(ax2,'% of individuals')
            xlabel(ax2,'Time')            
            axis(ax2,[0 N 0 length(pos)])
        end
        
      % get frame
      drawnow
      frame = getframe(f); 
      im = frame2im(frame); 
      [imind,cm] = rgb2ind(im,256); 
      % write to GIF File 
      if i == 1 
          imwrite(imind,cm,filename,'gif', 'Loopcount',inf,'DelayTime',0); 
      else 
          imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',0); 
      end
      
    end
   
end