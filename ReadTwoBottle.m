%import licks and stimulations recorded by the arduino
clear all;



SessName={'AlcL AlcC';'AlcL AlcQC'; 'AlcL SucC'; 'AlcQL AlcC'; 'AlcQL AlcQC'; 'AlcQL SucC'; 'EmptyL EmptyC'; 'MaltL MaltC'; 'MaltL SucC'; 'SucL AlcC'; 'SucL AlcQC'; 'SucL MaltC'; 'SucL SucC'; 'WaterL WaterC'};

for session=1:length(SessName)
    address=append('Z:\Kurt\CeA Alcohol Consumption\Optogenetic Experiments Spring 2019\Data\Two Bottle 7Hz\',SessName{session});
    AF=dir([address,'\\*.TXT']);
    for a=1:length(AF)
        %start fresh
        clear X Y licktimesL licktimesC lasertimes;

        %get file
        myfile=AF(a).name;
        rat=str2num(myfile(3:4));

        %get the data from the file
        filename = fullfile(address,myfile);
        file = fopen(filename);
        X = textscan(file,'%s','Delimiter',',');
        fclose(file);

         %find laser bottle licks, get times
        licksL=strcmp('lickL',X{1,1});
        if sum(licksL)>0
            index1=find(licksL);
            for i=1:length(index1)
                licktimesL(i,1)=str2num(cell2mat(X{1,1}(index1(i)-1,1)));
            end
        else
            licktimesL=[];
        end


        %find control bottle licks, get times
        licksC=strcmp('lickC',X{1,1});
        if sum(licksC)>0
            index2=find(licksC);
            for i=1:length(index2)
                licktimesC(i,1)=str2num(cell2mat(X{1,1}(index2(i)-1,1)));
            end
        else
            licktimesC=[];
        end
        %find laser triggers, get times
        laser=strcmp('laser',X{1,1});
        if sum(laser)>0
            index3=find(laser);
            for i=1:length(index3)
                lasertimes(i,1)=str2num(cell2mat(X{1,1}(index3(i)-1,1)));
            end
        else
            lasertimes=[];
        end

        %first column is control licks, second column is laser licks, third column is laser
        %stims
        Data{session,2}{rat,1}=licktimesC;
        Data{session,2}{rat,2}=licktimesL;
        Data{session,2}{rat,3}=lasertimes;
        
        Data{session,1}=SessName(session);



    fprintf('Session # %d\n',a);
    end
end
