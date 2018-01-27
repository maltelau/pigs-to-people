library(tidyverse)
library(rgdal)
library(sf)
library(scales)
library(cowplot)
library(glue)



# map data from kortforsyningen.dk
dk <- st_read("data/DAGIREF_SHAPE_UTM32-EUREF89/ADM/", layer = "REGION")
data = read_csv("data/clean_data.csv")

colour_fun = seq_gradient_pal(low = "#FEF0D9", high = "#B30000") 
pig_colour = colour_fun(data$Pigs_rate / max(data$Pigs_rate))
# pig_labs = str_c(round(data$Pigs_rate, 2),
#                  c(" PIGS PER PERSON"))
pig_labs = sprintf("%.1f", round(data$Pigs_rate, 1))


(left_join(dk, data, by = c("REGIONNAVN" = "Region")) %>%
    mutate(Pigs_rate = as.character(Pigs_rate)) %>%
    ggplot() +
    geom_sf(aes(fill = Pigs_rate)) +
    theme_map() +
    scale_fill_manual(values = pig_colour, 
                      guide = guide_legend(title = "PIGS PER PERSON",
                                           label.position="right"),
                      labels = pig_labs) +
    labs(title = "Pigs per Person in Denmark", subtitle = "Pig & People data: statistikbanken.dk/ \nMap data: download.kortforsyningen.dk") +
    theme(legend.position = c(.65,.82))) %>%
    save_plot(plot =., filename = "pigs_denmark.png", 
              # base_width = 10, 
              base_height = 7)
