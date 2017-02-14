function sassinput =exclude_small_events(sassinput,hmaxcutoff)
%% Count swash events and find small events

h = sassinput.H;
t = sassinput.T;
dry = sassinput.H<0.01; %Find dry points

evstart = find(diff(dry)== -1);%Start of swash event
evend = find(diff(dry) == 1);%End of swash event


numev = length(evstart);%number of swash events

% fprintf('Number of swash events: %u\n',numev);

ev_maxh = nan(1,numev);
px2 = false(size(sassinput.sheet.t));
px3 = false(size(sassinput.sheet.t));

for i=1:(numev);
    ev_maxh(i) = max(sassinput.H(evstart(i):evend(i)));
end
for i=1:(numev-1);
    if ev_maxh(i)<hmaxcutoff;
        px2(sassinput.sheet.t>=sassinput.T(evstart(i))-0.5 & sassinput.sheet.t<=(sassinput.T(evstart(i+1))-1))=true;
    end
    if ev_maxh(i)<hmaxcutoff & ev_maxh(i+1)<hmaxcutoff;
        px2(sassinput.sheet.t>=sassinput.T(evstart(i))-0.5 & sassinput.sheet.t<=(sassinput.T(evstart(i+1))))=true;
    end
end

sassinput.sheet.ds(px2)=nan;