library(tidyverse)

# Pig data
# http://www.statistikbanken.dk/10472
pigs = read_csv2("data/2018127155550212913919HDYR0757355584683.csv", skip=2, col_names=F)[4:8,3:6]
names(pigs) = c("Region", "Sows", "Svin", "Slagtesvin")
pigs[2, 1] = "Region Sjælland"

pigs = mutate_at(pigs, vars(-Region), funs(as.numeric)) %>%
    mutate(Pigs = Sows + Svin + Slagtesvin)


# people data
# https://www.statistikbanken.dk/10022
people = data.frame(Region = c("Region Hovedstaden",
                               "Region Sjælland",
                               "Region Syddanmark",
                               "Region Midtjylland",
                               "Region Nordjylland"),
                    People = c(1789174,	827499,	1211770, 1293309, 585499))

full_join(pigs, people) %>%
    mutate(Pigs_rate = Pigs / People) %>%
    select(Region, Pigs, People, Pigs_rate) %>%
    write_csv("data/clean_data.csv")


