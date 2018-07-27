library(dplyr)
library(lubridate)

bad.runs = read.table("cmdfails.csv", sep=",", stringsAsFactors = F)
colnames(bad.runs) = 
  c("job.name", "job.group", "sn.assignment","machine", "joid",
    "run.num","try.number","start.epoc","start.date", "end.epoc",
    "end.date","seconds.ran","status", "exit.code", "incident",
    "process.date")

term.runs = bad.runs %>% filter(status == "TERMINATED")
fail.runs = bad.runs %>% filter(status == "FAILURE")

term.runs.group = table(term.runs$job.group)
fail.runs.group = table(fail.runs$job.group)

fail.runs.code = table(fail.runs$exit.code)
fail.runs.group.code = table(fail.runs$job.group,  fail.runs$exit.code )

fail.job = table(fail.runs$job.name)
fail.job.code = table(fail.runs$job.name, fail.runs$exit.code)

fail.machine = table(fail.runs$machine)