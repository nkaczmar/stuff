library(tidyverse)
library(janitor)


zonal_files_dir <- "H:/GIS_projects/2016_P1/dataFiles/zonal_stats/G2F 2016 Flyterra Drew"
g2f_data_file <- "H:/GIS_projects/2016_P1/dataFiles/2016_g2f_NYH3_curated_data.csv"
nick_key_file <- "H:/GIS_projects/2016_P1/dataFiles/keyfiles/2016_NYH3_Drew_Flyterra_out_adj.csv"

combined_zonal_output_file <- paste0(zonal_files_dir,"/2016_NYH3_Flyterra_Drew_combined_zonal_files.tsv")
combined_g2f_drone_output_file <- "./2016_NYH3_Flyterra_Drew_combined.tsv"

# using list.files read all files in the dir recursively and store full path
zonal_data <- list.files(path = zonal_files_dir, pattern = "*.csv", full.names = TRUE, recursive = TRUE) %>%  
    set_names() %>%                                                                    # label each list element with file path
    map_dfr(read_csv, .id="filepath") %>%                                              # read all files and combine in a dataframe
    clean_names() %>%                                                                  # standardize column names (uses "janitor" library)
    rename(range_zonal = range) %>%                                                    # rename "range" to not conflict with g2f column
    mutate(filename = sub("^.+\\/", "", filepath)) %>%                                 # extract file name from path
    mutate(sensor = sub("_.+$", "", filename)) %>%                                     # extract sensor name from filename (separator = "_", take first chunk)
    mutate(date = sub("_.+$", "", sub("^[^_]+_[^_]+_[^_]+_", "", filename))) %>%       # extract flight date from filename (separator = "_", take 4th chunk)
    separate(plot, c("p_row", "p_col"), sep = "_", remove = FALSE) %>%                 # split the plot id into row & col separate cols; NOTE: we did not use "separate" for sensor and date as the file names have variable number of chunks after the date
    mutate(p_row = sub("^p", "", p_row)) %>%                                           # remove the "p" from row id and make both numeric
    mutate(p_row = as.numeric(p_row)) %>%
    mutate(p_col = as.numeric(p_col)) %>%
    write_tsv(combined_zonal_output_file)                                              # save combined data to file

drone_new_names <- names(zonal_data) %>%
    sub("^", "drone_", .)
zonal_data <- zonal_data %>%
    set_names(drone_new_names)
    

g2f_data <- read_csv(g2f_data_file) %>%
    clean_names()                                # standardize column names (uses "janitor" library)


nick_key <- read_csv(nick_key_file) %>%
    clean_names() %>%                            # standardize column names (uses "janitor" library)
    rename(qgis_plot_id = plot_id) %>%
    mutate(plot_num = as.numeric(plot_num)) %>%  # plot number is expected to be numeric
    filter(!is.na(plot_num))                     # remove all the non-numeric plots not expected to exist in the g2f file

key_new_names <- names(nick_key) %>%
    sub("^", "planting_map_", .)
nick_key <- nick_key %>%
    set_names(key_new_names)


g2f_drone_combined_data <- g2f_data %>%                          # start with the g2f data to add to
    left_join(nick_key, by = c("plot" = "planting_map_plot_num")) %>%         # add all relevant entries from the key file for all g2f entries
    left_join(zonal_data, by = c("planting_map_qgis_plot_id" = "drone_plot")) %>%  # add all relevant entries from the zonal file for all g2f entries
    write_tsv(combined_g2f_drone_output_file)


