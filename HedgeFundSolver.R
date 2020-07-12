#INCOMPLETE

#This is a tool I quickly programmed in order to associate Anonymized Hedge Funds on WRDS
#There are 4 different Hedge Fund Databases offered by WRDS.
#   Morningstar CISDM
#   Thomson TASS
#   HFR
#   and EurekaHedge
#While there exist fancier subscriptions that allow for access to Identifiers,HFR and Thomson TASS do not make this information available to everyone.
#To clarify,
#   All Morningstar CISDM subscriptions seem to identify every fund.
#     HFR and Thomason TASS do not. As far as I know, TASS doesn't seem to offer identifiers at any subscription-level
#     I've never worked with Eurekahedge, so I know very little about it.

#First, connect to WRDS using dbConnect

wrds1 <- DBI::dbConnect(RPostgres::Postgres(),
host='wrds-pgdata.wharton.upenn.edu',
port=9737,
dbname='wrds',
user="",
password="",
sslmode='require')

#I'm going to import Morningstar CISDM data first
mstar_pp<-RPostgres::dbGetQuery(wrds1,"SELECT * FROM cisdm.active_returns_assets")

#Now, I'm going to import Thomson TASS
tass_pp<-RPostgres::dbGetQuery(wrds1,"SELECT * FROM tass.productperformance")

#TASS modifications
#Since TASS dates reflect End-of-Month and Morningstar reflects the first of the month, I convert the TASS date to First-of-Month for simplicity sake
tass_pp$date<-as.Date(paste0(substr(tass_pp$date,1,7),"-01"))
#t1 just stores the most recent date of TASS coverage; I use it to reduce the 30,000+ Funds to only Funds that have data within the past 2 years.
t1<-tapply(tass_pp$date3,tass_pp$productreference,max)
t1<-names(t1[which(t1>18000)])

tass_pp1<-tass_pp[which(tass_pp$productreference %in% t1),]
tass_pp1<-split(tass_pp1,tass_pp1$productreference)

#Morningstar Modifications
Mror1<-mstar_pp[which(mstar_pp$return<1000),]
Mror1<-data.table::data.table(Mror1)
Mror1$date<-as.Date(Mror1$date,origin="1960-01-01")
d1<-rev(sort(table(Mror1$date)))
Mror1<-split(Mror1,Mror1$secid)

for(j in 1:length(Mror1)){
  
  #datelist1 will be a list with each list index representing commong dates between current Morningstar Fund and all TASS funds.
datelist1<-lapply(tass_pp1,function(x) intersect(x$date,Mror1[[j]]$date))
  
  #med1 represents median absolute difference between MStar fund and TASS fund for all common dates.
  #While I originally used other metrics, such as pearson correlation coefficient, this proved ineffective because a single outlier can lead to false negative results
med1<-unlist(mapply(function(m,n) median(abs(m-n)),m=mapply(function(z,a) z$rateofreturn[a],z=tass_pp1,a=mapply(function(x,y) match(x,y$date),x=datelist1,y=tass_pp1)),n=map(map(datelist1,function(x) match(x,Mror1[[j]]$date)),function(y) Mror1[[j]]$return[y])))


nDate<-unlist(map(datelist1,length))
tass_names<-names(tass_pp1)
SubTh<-unlist(mapply(function(m,n) sum(abs(m-n)<0.001),m=mapply(function(z,a) z$rateofreturn[a],z=tass_pp1,a=mapply(function(x,y) match(x,y$date),x=datelist1,y=tass_pp1)),n=map(map(datelist1,function(x) match(x,Mror1[[j]]$date)),function(y) Mror1[[j]]$return[y])))
SubHund<-unlist(mapply(function(m,n) sum(abs(m-n)<0.01),m=mapply(function(z,a) z$rateofreturn[a],z=tass_pp3,a=mapply(function(x,y) match(x,y$date2),x=ll1,y=tass_pp3)),n=map(map(ll1,function(x) match(x,Mror3[[j]]$date)),function(y) Mror3[[j]]$return[y])))
df1<-data.frame(tass_names=tass_names,med1=med1,nDate=nDate,SubTh=SubTh,SubHund=SubHund)
df1<-df1[which(df1$med1<0.2),]
df1<-df1[which(df1$nDate>median(df1$nDate)),]

lm1[[j]]<-c(num=j,secid=names(Mror3)[j],df1[head(rev(order(df1$SubHund)),1),])
}
FundIDmetrics1<-data.table::rbindlist(lm1)
FundIDmetrics1<-FundIDmetrics1[!is.na(FundIDmetrics1$tass_names),]
View(FundIDmetrics1)
