################################################################################
################ Code to combine AMASS data into a single file #################
################################################################################

# packages
rm(list = ls()) 
packages <- c("dplyr","openxlsx")
new_packages <- packages[!(packages %in% installed.packages()[,"Package"])]
if(length(new_packages)) install.packages(new_packages)
lapply(packages, require, character.only = TRUE)

# import each file
  # names of hospitals (i.e., folder names)
  main_dir <- "C:/Users/wcuningh/Documents/ADILA_Data_Cleaning/AMASS"
  dir_list <- list.dirs(main_dir, full.names = FALSE, recursive = FALSE)
  dir_list <- dir_list[dir_list != "combined"]
  # load each csv within each folder
  for (dir in dir_list) {
    path = paste0(main_dir, "/", dir)
    setwd(path)
    file_names = list.files(pattern="*.csv")
    list2env(lapply(setNames(file_names, make.names(gsub("*.csv$", dir, file_names))), read.csv), envir = .GlobalEnv)
    #files <- lapply(file_names, read.delim)
    #assign(dir, files)
  }
  # add a column to identify the hospital
  hosp_names <- c("Amnatcharoen Hospital", "Angkor Hospital for Children", "Kantharalak Hospital", "Mahosot Hospital", "Mukdahan Hospital", 
                  "Nakhonphanom Hospital", "North Okkalapa General and Teaching Hospital", "Patan Hospital", "Phatthalung Hospital", 
                  "St Thomas’ Hospital", "Sunpasitthiprasong Hospital", "Sunpasitthiprasong Hospital (Allabis)", "Sunpasitthiprasong Hospital (Mlab)", 
                  "Hospital for Tropical Diseases")
  for (i in 1:length(dir_list)) {
    files <- mget(ls(pattern=paste0("*", dir_list[i])))
    for (j in 1:length(files)) {
      files[[j]] <- cbind(files[[j]], hospital = hosp_names[i])
    }
    rm(list=ls(pattern=paste0("*", dir_list[i])))
    for (k in seq(files)) {
      assign(paste0(names(files)[k]), files[[k]])
    }
    rm(files)
  }
  
# append like files from each hospital
  # NOT SURE WHY THESE FOUR DON'T WORK TOGETHER (to do with string matching), SO DOING SEPARATELY AND REMOVING ORIGINALS AFTER
  reports <- list("Summary_stratified_gender_age_origin_of_infection_es", "Summary_stratified_gender_age_origin_of_infection_ss")
  for (i in 1:length(reports)) {
    append <- bind_rows(mget(grep(pattern = reports[[i]], x = ls(), value = TRUE)))
    #rm(list=ls(pattern=paste0(reports[[i]], "*")))
    assign(reports[[i]], append)
    rm(append)
  }
  reports <- list("Summary_stratified_gender_age_origin_of_infection_ec", "Summary_stratified_gender_age_origin_of_infection_sa")
  for (i in 1:length(reports)) {
    append <- bind_rows(mget(grep(pattern = reports[[i]], x = ls(), value = TRUE)))
    #rm(list=ls(pattern=paste0(reports[[i]], "*")))
    assign(reports[[i]], append)
    rm(append)
  }
  Keep_Summary_stratified_gender_age_origin_of_infection_es <- Summary_stratified_gender_age_origin_of_infection_es
  Keep_Summary_stratified_gender_age_origin_of_infection_ss <- Summary_stratified_gender_age_origin_of_infection_ss
  Keep_Summary_stratified_gender_age_origin_of_infection_ec <- Summary_stratified_gender_age_origin_of_infection_ec
  Keep_Summary_stratified_gender_age_origin_of_infection_sa <- Summary_stratified_gender_age_origin_of_infection_sa
  rm(list=ls(pattern=paste0("^Summary_stratified_gender_age_origin_of_infection_es","*")))
  rm(list=ls(pattern=paste0("^Summary_stratified_gender_age_origin_of_infection_ss","*")))
  rm(list=ls(pattern=paste0("^Summary_stratified_gender_age_origin_of_infection_ec","*")))
  rm(list=ls(pattern=paste0("^Summary_stratified_gender_age_origin_of_infection_sa","*")))
  # now the rest...
  reports <- list("Report1_page_4_counts_by_month", "Report2_AMR_proportion_table",
                  "Report2_page6_counts_by_organism", "Report2_page6_patients_under_this_surveillance_by_organism",
                  "Report3_page13_counts_by_origin", "Report3_table", "Report4_frequency_blood_samples",
                  "Report4_frequency_priority_pathogen", "Report5_incidence_blood_samples_community_origin",
                  "Report5_incidence_blood_samples_hospital_origin", "Report6_mortality_table",
                  "Report7_page_38_positive_specimens", "Report7_page_39_patients_with_positive_specimens",
                  "Report7_page_40_mortlity_table", "Summary_stratified_gender_age_origin_of_infection_as",
                  "Summary_stratified_gender_age_origin_of_infection_kp", "Summary_stratified_gender_age_origin_of_infection_pa")
  for (i in 1:length(reports)) {
    append <- bind_rows(mget(grep(pattern = reports[[i]], x = ls(), value = TRUE)))
    rm(list=ls(pattern=paste0(reports[[i]], "*")))
    assign(reports[[i]], append)
    rm(append)
  }
  Summary_stratified_gender_age_origin_of_infection_es <- Keep_Summary_stratified_gender_age_origin_of_infection_es
  Summary_stratified_gender_age_origin_of_infection_ss <- Keep_Summary_stratified_gender_age_origin_of_infection_ss
  Summary_stratified_gender_age_origin_of_infection_ec <- Keep_Summary_stratified_gender_age_origin_of_infection_ec
  Summary_stratified_gender_age_origin_of_infection_sa <- Keep_Summary_stratified_gender_age_origin_of_infection_sa
  rm(list=ls(pattern=paste0("^Keep","*")))
  rm(reports)
  
# export each data.frame into a separate sheet of a single file
  # truncate names
  R1_p4_counts_by_month <- Report1_page_4_counts_by_month
  R2_AMR_proportion_table <- Report2_AMR_proportion_table
  R2_p6_counts_by_organism <- Report2_page6_counts_by_organism
  R2_p6_patnts_under_surv_by_org <- Report2_page6_patients_under_this_surveillance_by_organism
  R3_p13_counts_by_origin <- Report3_page13_counts_by_origin
  R3_table <- Report3_table
  R4_frequency_blood_samples <- Report4_frequency_blood_samples
  R4_freq_priority_pathogen <- Report4_frequency_priority_pathogen
  R5_inc_blood_samp_comm_orgn <- Report5_incidence_blood_samples_community_origin
  R5_inc_blood_samp_hosp_orgn <- Report5_incidence_blood_samples_hospital_origin
  R6_mortality_table <- Report6_mortality_table
  R7_p38_positive_specimens <- Report7_page_38_positive_specimens
  R7_p39_patnts_w_positive_spec <- Report7_page_39_patients_with_positive_specimens
  R7_p40_mortlity_table <- Report7_page_40_mortlity_table
  Smmary_by_gen_age_inf_orgn_as <- Summary_stratified_gender_age_origin_of_infection_as
  Smmary_by_gen_age_inf_orgn_kp <- Summary_stratified_gender_age_origin_of_infection_kp
  Smmary_by_gen_age_inf_orgn_pa <- Summary_stratified_gender_age_origin_of_infection_pa
  Smmary_by_gen_age_inf_orgn_es <- Summary_stratified_gender_age_origin_of_infection_es
  Smmary_by_gen_age_inf_orgn_ss <- Summary_stratified_gender_age_origin_of_infection_ss
  Smmary_by_gen_age_inf_orgn_ec <- Summary_stratified_gender_age_origin_of_infection_ec
  Smmary_by_gen_age_inf_orgn_sa <- Summary_stratified_gender_age_origin_of_infection_sa
  # save  
  setwd("../combined")
  save <- createWorkbook()
  reports <- list("R1_p4_counts_by_month", "R2_AMR_proportion_table",
                  "R2_p6_counts_by_organism", "R2_p6_patnts_under_surv_by_org",
                  "R3_p13_counts_by_origin", "R3_table", "R4_frequency_blood_samples",
                  "R4_freq_priority_pathogen", "R5_inc_blood_samp_comm_orgn",
                  "R5_inc_blood_samp_hosp_orgn", "R6_mortality_table",
                  "R7_p38_positive_specimens", "R7_p39_patnts_w_positive_spec",
                  "R7_p40_mortlity_table", "Smmary_by_gen_age_inf_orgn_as",
                  "Smmary_by_gen_age_inf_orgn_kp", "Smmary_by_gen_age_inf_orgn_pa",
                  "Smmary_by_gen_age_inf_orgn_es", "Smmary_by_gen_age_inf_orgn_ss",
                  "Smmary_by_gen_age_inf_orgn_ec", "Smmary_by_gen_age_inf_orgn_sa")
  for (i in 1:length(reports)) {
    addWorksheet(save, reports[[i]])
    writeData(save, sheet = reports[[i]], x = get(reports[[i]]))
  }
  saveWorkbook(save, "AMASS_combined.xlsx",  overwrite = TRUE)
  
  
  
  
  
