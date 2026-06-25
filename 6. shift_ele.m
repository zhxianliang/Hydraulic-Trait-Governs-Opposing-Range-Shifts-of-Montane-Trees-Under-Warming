   idx=shiftlon(:,1);
for i=1:102
    spp=spec(i);
    specc=shift(2:end,1);
   [m,n]= find(strcmp(spp,specc));

   idx(m)=1;
end

mmm=find(idx==1);
lll=shiftlon(mmm,3:7);
sppp=specc(mmm);
sp=unique(sppp);
elee=shiftlon(:,7);
elee(elee<0)=nan;
el=elee(mmm);
for ss=1:99
    ll=sp(ss);
    [m,n]= find(strcmp(ll,sppp));
    elsp=el(m);
    el_m(ss)=nanmean(elsp);
    el_sd(ss)=nanstd(elsp);
end


