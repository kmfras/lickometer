    
%to look at all sessions, 1:length(Data)
%to look at 1 session, just put "session=2" or whichever session
%for session=1:length(Data)
for session=13
    name=Data{session,1};
    
    figure;
    for i=1:length(Data{session,2})
        licks(i,1)=length(Data{session,2}{i,1});
        licks(i,2)=length(Data{session,2}{i,2});

    end

    subplot(1,2,1)
    hold on;
    plot(1:2,licks(1:10,:));
    xticks(1:2);
    xticklabels({'Control','Laser'});
    axis([0.5 2.5 0 max(max(licks))+200]);
    ylabel('Licks');
    title('ChR2 rats');
    text(1,max(max(licks)),name);


    
    data1=licks(:,1);
    data2=licks(:,2);
    group=cat(1,ones(10,1),zeros(6,1));
    tbl=table(data1,data2,group,'variablenames',{'control','laser','ChR2'});
    rm = fitrm(tbl,'control-laser~ChR2');
    stats=ranova(rm);
    LaserChR2Int.F(session,1)=stats.F(2);
    LaserChR2Int.PVal(session,1)=stats.pValue(2);
    
    text(1.2,max(max(licks))-100,['p = ' num2str(LaserChR2Int.PVal(session,1))]);
    
    subplot(1,2,2)
    hold on;
    plot(1:2,licks(11:16,:));
    xticks(1:2);
    xticklabels({'Control','Laser'});
    axis([0.5 2.5 0 max(max(licks))]);
    ylabel('Licks');
    title('YFP rats');
end

%% number of bursts
plotting=0;
clustercutoff=1000;
burstcutoff=250;
lickcutoff=3;
for session=1:length(Data)
    for rat=1:length(Data{session,2})
        
        %lick clusters
        for licktype=1:2
            typelicks=Data{session,2}{rat,licktype};
            typediff=diff(typelicks);
            lickswithincluster=find(typediff<clustercutoff);
            if length(lickswithincluster>0)
                firstinclust=lickswithincluster(1);
                for i=2:length(lickswithincluster)
                    if (lickswithincluster(i)-lickswithincluster(i-1))>1
                        firstinclust=cat(1,firstinclust,lickswithincluster(i));
                    end
                end

                numclustlicks=[];
                for lick=1:length(firstinclust)
                    if lick==length(firstinclust)
                        numclustlicks(lick,1)=sum(lickswithincluster>=firstinclust(end));
                        if sum(lickswithincluster>=firstinclust(end))<lickcutoff
                            firstinclust(end)=NaN;
                        end

                    else
                        thislick=firstinclust(lick);
                        nextlick=firstinclust(lick+1);
                        lastlickofthisbout=lickswithincluster(find(lickswithincluster==nextlick)-1);
                        numclustlicks(lick,1)=lastlickofthisbout-thislick+1;
                        if numclustlicks(lick,1)<lickcutoff
                           firstinclust(lick)=NaN;
                        end
                    end
                end
                clusterlicks{session,1}{rat,licktype}=numclustlicks(isnan(firstinclust)==0);
                clusters{session,1}(rat,licktype)=sum(isnan(firstinclust)==0);
                clusterlickmedian{session,1}(rat,licktype)=median(clusterlicks{session,1}{rat,licktype});
                clusterlickmean{session,1}(rat,licktype)=mean(clusterlicks{session,1}{rat,licktype});
            else
                clusterlicks{session,1}{rat,licktype}=NaN;
                clusters{session,1}(rat,licktype)=NaN;
                clusterlickmedian{session,1}(rat,licktype)=NaN;
                clusterlickmean{session,1}(rat,licktype)=NaN;
            end
        end

        %lick bursts
        for licktype=1:2
            typelicks=Data{session,2}{rat,licktype};
            typediff=diff(typelicks);
            lickswithinburst=find(typediff<burstcutoff);
            if length(lickswithinburst)>0
                firstinburst=lickswithinburst(1);
                for i=2:length(lickswithinburst)
                    if (lickswithinburst(i)-lickswithinburst(i-1))>1
                        firstinburst=cat(1,firstinburst,lickswithinburst(i));
                    end
                end

                numburstlicks=[];
                for lick=1:length(firstinburst)
                    if lick==length(firstinburst)
                        numburstlicks(lick,1)=sum(lickswithinburst>=firstinburst(end));
                        if sum(lickswithinburst>=firstinburst(end))<lickcutoff
                            firstinburst(end)=NaN;
                        end

                    else
                        thislick=firstinburst(lick);
                        nextlick=firstinburst(lick+1);
                        lastlickofthisbout=lickswithinburst(find(lickswithinburst==nextlick)-1);
                        numburstlicks(lick,1)=lastlickofthisbout-thislick+1;
                        if numburstlicks(lick,1)<lickcutoff
                           firstinburst(lick)=NaN;
                        end
                    end
                end
                burstlicks{session,1}{rat,licktype}=numburstlicks(isnan(firstinburst)==0);
                burstlickmedian{session,1}(rat,licktype)=median(burstlicks{session,1}{rat,licktype});
                burstlickmean{session,1}(rat,licktype)=mean(burstlicks{session,1}{rat,licktype});
                bursts{session,1}(rat,licktype)=sum(isnan(firstinburst)==0);
            else
                
                burstlicks{session,1}{rat,licktype}=NaN;
                burstlickmedian{session,1}(rat,licktype)=NaN;
                burstlickmean{session,1}(rat,licktype)=NaN;
                bursts{session,1}(rat,licktype)=NaN;
            end
        end
    end
    
    name=Data{session,1};
    if plotting
        figure;

        subplot(1,2,1)
        hold on;
        plot(1:2,burstlickmedian{session,1}(1:10,:));
        xticks(1:2);
        xticklabels({'Control','Laser'});
        axis([0.5 2.5 0 max(max(burstlickmedian{session,1}))+5]);
        ylabel('Bursts');
        title('ChR2 rats');
        text(1,max(max(burstlickmedian{session,1})),name);



        data1=burstlickmedian{session,1}(:,1);
        data2=burstlickmedian{session,1}(:,2);
        group=cat(1,ones(10,1),zeros(6,1));
        tbl=table(data1,data2,group,'variablenames',{'control','laser','ChR2'});
        rm = fitrm(tbl,'control-laser~ChR2');
        stats=ranova(rm);
        LaserChR2Int.F(session,1)=stats.F(2);
        LaserChR2Int.PVal(session,1)=stats.pValue(2);

        text(1.2,max(max(burstlickmedian{session,1}))-7,['p = ' num2str(LaserChR2Int.PVal(session,1))]);

        subplot(1,2,2)
        hold on;
        plot(1:2,burstlickmedian{session,1}(11:16,:));
        xticks(1:2);
        xticklabels({'Control','Laser'});
        axis([0.5 2.5 0 max(max(burstlickmedian{session,1}))+5]);
        ylabel('Bursts');
        title('YFP rats');
    end
    
end
        
