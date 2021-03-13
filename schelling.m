%% Schelling Segregation Model
% A model which recreates the emergence of segregated neighbourhoods

%% Author: Diego Ciccia


%% Segregation

% The model proposed by Thomas Schelling deals with the problem of how
% segregation emerges in a society without any decision form above which
% imposes such division. The Nobel winning economist started from the idea
% that society in general is composed by groups which are characterized by
% polar opposite features (blacks and whites, catholics and jews, rich and
% poor,...). It is safe to assume that the social pressure on each
% individual will make him feel safe around people of the same group, so
% that, if surrounded by too many people of the opposite group, the agent
% will feel the urge to move to a different location. This implies that, by
% moving somewhere else, he will influence the social composition of the
% neighbourhood in which he decides to settle, so that other agents, because 
% of the changed structure of their surroundings, may decide to move.
% By means of such decisions, each agent influences the resting place of
% the others: the resulting pattern will allow the emergence of segregated
% neighbourhoods in which there is an extremely high concentration of one
% of the social groups and none of the other. 
% Starting from a random assignment of the houses, we denote with green/red
% the two groups, while black spots will be empty houses which will be
% filled by moving agents and which will be created as soon as one agent
% moves.
% The objective of the script is to show visually how it is possible to
% obtain segregation from the uncoordinated activities of the individuals,
% which is, what connects micro-motives to the macro-behaviour.

T=10; %Periods of time
N=10; %Size of Society
Society = zeros(N,N,T); %3D Array 

for i=1:N
    for j=1:N
        n = rand();%Random assignment of the houses to the social groups
        if n > 0.5 %Expected Majority (Green)
            Society(i,j,1) = 1;
        elseif n > 0.2 && n <= 0.5 %Expected Minority (Red)
            Society(i,j,1) = -1;
        end
    end
end

for t=2:T
    [i_zeros,j_zeros] = find(~Society(:,:,t-1));
    vacancies = [i_zeros,j_zeros]; %Coordinates for the vacant houses
    
    for i=1:N        
        if i==1
            hi=1;
        else
            hi=i-1;
        end
        if i==N
            li=N;
        else
            li=i+1;
        end        
        for j=1:N            
            if j==1
                hj=1;
            else
                hj=j-1;
            end
            if j==N
                lj=N;
            else
                lj=j+1;
            end
            %Motion of the agents
            if Society(i,j,t-1)==1
                Neigbh = Society(hi:li,hj:lj, t-1);
                if sum(sum(Neigbh)) - 1 > 0
                   Society(i,j,t)=1;
                else
                   if length(vacancies) > 1
                       Society(i,j,t)=0;
                       new = vacancies(1,:);
                       Society(new(1),new(2),t)=1;
                       vacancies(1,:)=[];
                       vacancies=flipud(vacancies);
                   end
                end
                
            elseif Society(i,j,t-1)== -1
                Neigbh = Society(hi:li,hj:lj, t-1);
                if sum(sum(Neigbh)) + 1 < 0
                   Society(i,j,t)=-1;
                else
                   if length(vacancies) > 1
                       Society(i,j,t)=0;
                       new = vacancies(1,:);
                       Society(new(1),new(2),t)=-1;
                       vacancies(1,:)=[];
                       vacancies=flipud(vacancies);
                   end
                end
            end
        end
    end
end

sz=200;
for t=1:T
    M = Society(:,:,t);
    for i=1:N
        for j=1:N
            if M(i,j)== 1
                scatter(i,j,sz,'filled', 'g')
                hold on
                grid on
            elseif M(i,j)==-1
                scatter(i,j,sz,'filled','r')
                hold on
                grid on
            else
                scatter(i,j,sz,'filled','k')
                hold on
                grid on
            end
        end
    end
    
    title('Schelling Segregation model')
    ylim([-1 N+2])
    xlim([-1 N+2])
    xt = text(-0.5,N+1.5, ['t = ', num2str(t)]);
    drawnow
    if t ~= T
        delete(xt)
    end
end

                 

