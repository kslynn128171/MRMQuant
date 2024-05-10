function [sdata,LOC]=smoothing_and_find_peaks(prt,pint,pbg,pidx,method,sn_ratio,min_peak_width,smooth_win,ratiothres)
    if nargin < 7
        errordlg('Not enough parameter for data smoothing!');
        return;
    elseif nargin < 8
        smooth_win=-1;
        ratiothres=1.12;
    elseif nargin < 9
        ratiothres=1.12;
    elseif nargin > 9
        errordlg('Too many parameters for data smoothing!');
        return;
    end
    sdata=pint;
    % Define the scale of interest range to be how many time of the RT tolerance
    % The signals are smoothed and the peaks are detected in this range
    % This range is larger than the RT tolerance so that neighboring peaks 
    % can be also detected, which can be useful in deconvolution
    multi=1.5; 
    dlen=length(prt);
    % interest range is a binary vector indicating whether to find peaks in a certain RT range
    % true values indicate the locations of designated compound RT +/- multi * rt_tol
    interest_range=false(1,dlen);
    for i=1:length(method.rt{pidx})
        interest_range((prt>=(method.rt{pidx}(i)-multi*method.rt_diff{pidx}(i))) & (prt<=(method.rt{pidx}(i))+multi*method.rt_diff{pidx}(i))) = true;
    end
    sdiff=prt(2:end)-prt(1:end-1); % compute the differences between neighboring signals
    diffratio=sdiff(2:end)./sdiff(1:end-1); % compute the ratio of neighboring differences
    % find intervals that exhibit an obviously different sampling rate 
    % (neighboring sampling rate ratio > ratiothres or < 1/ratiothres)
    % from its previous interval and identify the corresponding ending indices
    eidx=find((diffratio<(1/ratiothres))|(diffratio>ratiothres))+2; % find the end index of the intervals
    eidx=eidx(eidx>ceil(dlen/10)); % avoid a short starting interval
    if isempty(eidx) % if no change of sampling rate is found, use the entire signal for smoothing
        eidx=dlen;
    elseif eidx(end) < (dlen-ceil(dlen/10)) % append the ending interval
        eidx=[eidx;dlen];
    elseif (eidx(end) >= (dlen-ceil(dlen/10))) && (eidx(end) ~= dlen) % avoid a short ending interval
        eidx(end)=dlen;
    end
    % remove small intervals
    kidx=true(1,length(eidx)); % whether the ith section is kept
    for i=1:(length(eidx)-2)
        if eidx(i+1)-eidx(i) < 15 % small interval with less than 15 points
            kidx(i+1)=false;
        end
    end
    eidx=eidx(kidx); % update the end indices of the intervals
    sidx=[1;(eidx(1:end-1)+1)]; % generate the starting indices of the intervals
    % adjust the intervals so that the starting/ending points are connected at the
    % valleies (1.2*background intensity)
    if length(sidx)>1
        for i=2:length(sidx)
            if pint(sidx(i)) > 1.2*pbg(sidx(i)) % the starting point is higher than twice the background
                neighbor=10;
                acceptable=false;
                while ~acceptable
                    [smin,smid]=min(pint(max(1,(sidx(i)-neighbor)):min((sidx(i)+neighbor),dlen))); % find min in the neighboring (+/-10points) region
                    if smin <= 1.2*pbg(sidx(i)) || (neighbor>30) % the min is higher than twice the background
                        sidx(i)=max(1,(sidx(i)-neighbor))+smid-1;                           
                        eidx(i-1)=sidx(i)-1;
                        acceptable=true;
                    else
                        neighbor=neighbor+5;
                    end
                end
            end
        end
        if eidx(1) == 0 % the first interval is covered by the 2nd one. Remove it!
            sidx=sidx(2:end);
            eidx=eidx(2:end);
        end
        % remove small (<15 points) intervals
        skidx=true(1,length(sidx)); % whether the ith section is kept
        ekidx=true(1,length(eidx)); % whether the ith section is kept
        for i=1:(length(eidx)-1)
            if eidx(i)-sidx(i) < 15 % small interval with less than 15 points
                skidx(i+1)=false;
                ekidx(i)=false;
            end
        end
        if eidx(end)-sidx(end) < 15 % small interval with less than 15 points
            skidx(end)=false;
            ekidx(end-1)=false;
        end
        eidx=eidx(ekidx); % update the end indices of the intervals
        sidx=sidx(skidx); % update the starting indices of the intervals
    end
    % interval by interval smoothed the signals by a gaussian curve
    local_LOC=cell(length(sidx),1);
    for i=1:length(sidx)
        idx=sidx(i):eidx(i);
        % perform peak detection only in the interest RT ranges
        is_interst=interest_range(idx);
        if any(is_interst)           
            if smooth_win==-1 % if the smoothing window is to be determined automatically
                % check whether the peak is a noisy peak
                useid=find(is_interst); % indices in the interest RT range
                [maxv,maxidx]=max(pint(idx(useid))); % find the highest signal location
                midx=useid(maxidx);
                mvint=movmean(pint(idx),5); % compute the averaged signal
                s1=midx-1:-1:1; % indices of left side of the peak
                s2=midx+1:length(mvint); % indices of right side of the peak
                lbidx=find(mvint(s1)<=max(maxv/20,min(mvint(s1))),1,"first"); % index of left bound of the peak
                rbidx=find(mvint(s2)<=max(maxv/20,min(mvint(s2))),1,"first"); % index of right bound of the peak
                % sign changes in the left side of the peak
                lsigchg=0;
                lnegmax=0;lposmax=0;rnegmax=0;rposmax=0;
                if ~isempty(lbidx)
                    if ((lbidx-1)>0) && ((midx-1)>0)
                        ldiff=pint(idx(midx:-1:s1(lbidx-1)))-pint(idx((midx-1):-1:s1(lbidx)));
                        lsigchg=numel(find(diff(sign(ldiff))));
                        lsign=ldiff>0;
                        lneg=find(lsign==0);
                        lpos=setdiff(1:length(lsign),lneg);
                        lnegdiff=lneg(2:end)-lneg(1:end-1);
                        lnegmax=max(lnegdiff);
                        lposdiff=lpos(2:end)-lpos(1:end-1);
                        lposmax=max(lposdiff);
                    end
                end
                % sign changes in the left side of the peak
                rsigchg=0;
                if ~isempty(rbidx)
                    if ((rbidx-1)>0) && ((midx+1)<=length(idx))
                        rdiff=pint(idx(midx:s2(rbidx-1)))-pint(idx((midx+1):s2(rbidx)));
                        rsigchg=numel(find(diff(sign(rdiff))));
                        rsign=rdiff>0;
                        rneg=find(rsign==0);
                        rpos=setdiff(1:length(rsign),rneg);
                        rnegdiff=rneg(2:end)-rneg(1:end-1);
                        rnegmax=max(rnegdiff);
                        rposdiff=rpos(2:end)-rpos(1:end-1);
                        rposmax=max(rposdiff);
                    end
                end
                % find the length of the longest monotonic increasing/decreasing
                % subsequence
                monomax=max([lnegmax,lposmax,rnegmax,rposmax]);
                is_peak_noisy=(min(lsigchg,rsigchg) > 5) & ...
                    ((prt(idx(midx))-prt(idx(s1(lbidx))) < 0.25) | ...
                    (prt(idx(s2(rbidx)))-prt(idx(midx)) < 0.25));
                if is_peak_noisy % this is a noisy peak
                    %figure;stem(prt(idx),pint(idx),'markersize',1)
                    if monomax < 5 % the signal does not contain 5 consecutive increases/decreases;
                        winlen=ceil(min(midx-s1(lbidx),s2(rbidx)-midx)/1.5);
                    else 
                        winlen=ceil(min(midx-s1(lbidx),s2(rbidx)-midx)/3.0);
                    end
                else % use a regression rule to determine the smoothing window
                    temprt=prt(sidx(i):eidx(i));
                    templen=length(temprt);
                    avgintv=mean(temprt(2:end)-temprt(1:end-1));
                    winlen=min(max(4,1/(0.4359*avgintv^(-0.4808))),floor(templen/3));
                end
            else
                winlen=smooth_win;
            end
            % use gaussian curve to smooth each interval
            try
                sdata(sidx(i):eidx(i))=smoothdata(pint(sidx(i):eidx(i)),'gaussian',winlen);
            catch
                errordlg('smoothdata error','error','modal');
                continue;
            end
            % recompute the peak locations using designated mim peak width
            try
            [~,local_LOC{i}] = findpeaks(sdata(sidx(i):eidx(i)),prt(sidx(i):eidx(i)),...
                'MinPeakHeight',sn_ratio*max(pbg(sidx(i):eidx(i))),...
                'MinPeakWidth',0.4*min_peak_width);
            catch
                errordlg('findpeak error','error','modal');
            end
        end
    end
    LOC=cell2mat(local_LOC); % convert the peaks found in each section to a single peak list
    % if isempty(LOC)
    %     errordlg('smoothing_and_find_peaks error!','Error','modal');
    % end
end