trainfileset<-read_feather("./data/trainset.feather")
telemetry <- read_feather("./data/telemetry_train.feather")
assets <- read_feather("./data/assets.feather")
fail<- read_feather("./data/failures_train.feather")
maint <- read_feather("./data/maint_train.feather")
error<- read_feather("./data/error_train.feather")
pred.table<-read_feather("./data/predtable.feather")
resultcox <- read_feather("./data/resultcox.feather")

timeseriesdata<-
trainfileset%>%
  mutate(datetime=floor_date(datetime,unit = "month"))%>%
  group_by(datetime)%>%
  summarise(failures=sum(failure), total= n())%>%
  ungroup()%>%
  mutate(replacements=total-failures)%>%
  pivot_longer(c(2:4))%>%
  group_by(name)%>%
  mutate(avgval=cummean(value), cumval=cumsum(value))

repgaps<-trainfileset%>%
  group_by(comp)%>%
  summarise(rep_gap=median(rep_gap))

modfairep<-trainfileset%>%
  group_by(model,comp)%>%
  summarise(avgfailure=round(sum(failure)/length(unique(machineID)),2),
            avgrepl=round(n()/length(unique(machineID)),2))

