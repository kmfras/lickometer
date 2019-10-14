%% find number of bursts and clusters made for each bottle type with cluster and burst cutoff criteria
clustercutoff=1000;
burstcutoff=250;
lickcutoff=3;
for session=1:length(Data)
    for rat=1:length(Data{session,2})
        
        %find number of lick clusters
        %licktype 1 for laser bottle and 2 for control bottle
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
                %find number of licks per cluster
                clusterlicks{session,1}{rat,licktype}=numclustlicks(isnan(firstinclust)==0);
                %find total number of clusters
                clusters{session,1}(rat,licktype)=sum(isnan(firstinclust)==0);
                %find mean and median number of clusters
                clusterlickmedian{session,1}(rat,licktype)=median(clusterlicks{session,1}{rat,licktype});
                clusterlickmean{session,1}(rat,licktype)=mean(clusterlicks{session,1}{rat,licktype});
            else
                clusterlicks{session,1}{rat,licktype}=NaN;
                clusters{session,1}(rat,licktype)=NaN;
                clusterlickmedian{session,1}(rat,licktype)=NaN;
                clusterlickmean{session,1}(rat,licktype)=NaN;
            end
        end

        %find number of lick bursts
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
end
        
