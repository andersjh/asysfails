library(dplyr)
library(lubridate)
library(ggplot2)

machines = read.table("agents.csv", sep=",")
colnames(machines) = c("machine", "opsys")
bad.runs = read.table("cmdfails.csv", sep=",")
colnames(bad.runs) = 
  c("job.name", "job.group", "sn.assignment","machine", "joid",
    "run.num","try.number","start.epoc","start.date", "end.epoc",
    "end.date","seconds.ran","status", "exit.code", "incident",
    "process.date")
bad.runs = inner_join(bad.runs, machines)
bad.runs = bad.runs %>%
  mutate(
    end.month = factor(substr(end.date,1,7)),
    end.dom = factor(substr(end.date,1,10)),
    end.day = factor(substr(end.date,9,10)),
    end.hour = factor(substr(end.date,12,13)),
    end.wday = factor(wday(end.date, label=T))
  )

term.runs = bad.runs %>% filter(status == "TERMINATED")
fail.runs = bad.runs %>% filter(status == "FAILURE")

mon.fails = fail.runs %>%
  filter(as.character(end.month) >= "2018-07" & job.group != "EST") 

prior.fails = mon.fails %>%
  filter(end.day == '26')
  
fails.job = mon.fails %>%
  select(job.name) %>%
  group_by(job.name) %>%
  summarize(total.fails = n()) %>%
  filter(total.fails > 10) %>%
  arrange(desc(total.fails))


fails.machine = mon.fails %>%
  select(machine) %>%
  group_by(machine) %>%
  summarize(total.fails = n()) %>%
  filter(total.fails > 10) %>%
  arrange(desc(total.fails))

fails.code = mon.fails %>%
  select(exit.code) %>%
  group_by(exit.code) %>%
  summarize(total.fails = n()) %>%
  filter(total.fails > 10) %>%
  arrange(desc(total.fails))

fails.hour = mon.fails %>%
  select(end.hour) %>%
  group_by(end.hour) %>%
  summarize(total.fails = n()) %>%
  arrange(end.hour)

fails.wday.hour = mon.fails %>%
  select(end.wday, end.hour) %>%
  group_by(end.wday, end.hour) %>%
  summarize(total.fails = n())

fails.opsys = mon.fails %>%
  select(opsys) %>%
  group_by(opsys) %>%
  summarize(total.fails = n()) %>%
  filter(total.fails > 10) %>%
  arrange(desc(total.fails))

fails.group = mon.fails %>%
  select(job.group) %>%
  group_by(job.group) %>%
  summarize(total.fails = n()) %>%
  filter(total.fails > 10) %>%
  arrange(desc(total.fails))

fails.group.day = mon.fails %>%
  select(end.date, job.group) %>%
  group_by(end.date, job.group) %>%
  summarize(total.fails = n()) %>%
  filter(total.fails > 10) %>%
  arrange(desc(total.fails))

fails.pior.group = prior.fails %>%
  select(job.group) %>%
  group_by(job.group) %>%
  summarize(total.fails = n()) %>%
  arrange(desc(total.fails))
  

