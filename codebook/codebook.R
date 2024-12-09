# -----------------------------------------------------------------------------
# Codebook: Data Analysis and Visualization for Stroke Incidence and Outcomes
# -----------------------------------------------------------------------------

# The objective of this project is to develop a visualization that explores stroke incidence across different age groups among males and females, utilizing data from the Women’s Imaging of Stroke Hemodynamics Study. This analysis seeks to identify trends and patterns in stroke incidence by age and biological sex, as documented in existing literature.
# The raw data for this visualization project comes from the Lone Star Stroke Research Consortium as part of the Women’s Imaging of Stroke Hemodynamics Study (WISHeS), led by Principal Investigator Dr. Adrienne N. Dula at The University of Texas at Austin. Permission to use this dataset for this project was kindly granted by Dr. Dula. The dataset includes a comprehensive range of clinical information—such as demographics, medical history, and behavioral risk factors—alongside detailed imaging data, including vascular territories, Circle of Willis variations, and ischemic volumes.
# Data Source: Women’s Imaging of Stroke Hemodynamics Study (WISHeS). Led by Principal Investigator Dr. Adrienne N. Dula, The University of Texas at Austin. Supported by the Lone Star Stroke Research Consortium, 2022-2024.

# --------------------------------
# Installing and Loading Libraries
# --------------------------------

# Function to install and load multiple packages
# Purpose: Ensures all required libraries are installed and loaded automatically.
install_and_load <- function(packages) {
  for (package in packages) {
    if (!require(package, character.only = TRUE)) {
      install.packages(package, dependencies = TRUE) # Ensure dependencies are installed
      library(package, character.only = TRUE)  # Load the package
    }
  }
}

# List of packages
packages <- c("tidyverse", "patchwork", "ggplot2", "bslib", "kableExtra", "dplyr")

# Call the function to install and load packages
install_and_load(packages)

# --------------------------
# Description of Libraries
# --------------------------

# tidyverse: A collection of R packages for data manipulation and visualization.
library(tidyverse)

# patchwork: Combines multiple ggplot objects into layouts for multi-panel visualization.
library(patchwork)

# ggplot2: A foundational package for creating customizable data visualizations.
library(ggplot2)

# bslib: Provides theming tools for Shiny web applications.
library(bslib)

# kableExtra: Enhances table formatting in RMarkdown documents.
library(kableExtra)

# dplyr: Core tidyverse package for efficient data manipulation.
library(dplyr)

# ----------------
# Dataset 1: data 
# ----------------

# Dataset Overview
# - Purpose: Contains detailed patient data related to stroke incidence and outcomes from Women’s Imaging of Stroke Hemodynamics Study (WISHeS), led by Dr. Adrienne N. Dula.
# - Source: wishes_pro_data_current.csv

# Key Dataset Details
# - Number of Rows: 220
# - Number of Columns: 237

# Key Variables:
# 1. patient_id: Unique identifier for each patient (numeric).
# 2. jc_gender: Biological sex (1 = Male, 2 = Female).
# 3. gs_age: Patient's age (numeric).
# 4. pregnancy_number: Total number of pregnancies (for applicable patients).
# 5. miscarriage_num: Number of miscarriages (for applicable patients).
# 6. nihss_discharge: NIHSS score at discharge (stroke severity).
# 7. fu_mrs_90day: Functional outcome at 90 days post-stroke.
# 8. treatment_recvd: Treatment status (categorical/binary).
# 9. gs_stroketype: Stroke type (e.g., ischemic, hemorrhagic).
# 10. lvo_m1: M1 segment involvement in large vessel occlusion.

# Notes:
# - Missing Data: Some columns (e.g., pregnancy-related variables) have missing values for inapplicable participants.
# - Variable Types: Numeric and categorical
# - Refer to the `wishes_readcapvariables_datadictionary` in the /data folder for additional details.

# --------------------------------
# Dataset 2: reduced_Wishes_data
# --------------------------------

# Dataset Overview
# - Purpose: Focuses on stroke incidence across sex and age groups.
# - Source: Derived from the 'data' dataset.

# Key Variables and Their Types:
# 1. patient_id: 
#    - Type: Numeric
#    - Description: A unique identifier for each patient.
# 2. jc_gender: 
#    - Type: Categorical
#    - Description: Gender of the patient (1 = Male, 2 = Female).
# 3. gs_age: 
#    - Type: Numeric
#    - Description: Age of the patient in years.
# 4. age_group: 
#    - Type: Categorical
#    - Description: Age categories created using `cut()` (e.g., "0-19", "20-25", ..., "100+").

# participant_table: A sample table displaying key information from the reduced_Wishes_data dataset.
# The table shows the first 10 rows of the filtered data for a concise overview.

#-----------------------
# Key Variables Overview
#-----------------------

# age_gender_counts: A summarized dataset that counts the number of occurrences (e.g., stroke incidences or individuals) for each combination of age group and sex.
# This dataset is grouped by `age_group` and `gender`, providing a detailed breakdown of how the data is distributed across these categories.

# gender_counts: A summarized dataset that provides the total count of occurrences (e.g., stroke incidences or individuals) for each gender across all age groups. 
# This dataset offers a high-level overview of gender-specific trends in the dataset.

# max_age: The maximum age present in the dataset, representing the oldest individual. This value is used to determine the upper boundary for age-related analyses or visualizations.

# min_age: The minimum age present in the dataset, representing the youngest individual. This value helps establish the lower boundary for age-related analyses or visualizations.

# summary_data: A wide-format dataset summarizing the number of occurrences (e.g., stroke incidences or individuals) by age group and gender. 
# It includes separate columns for male and female counts, with male counts converted to negative values for mirrored visualizations. 
# This dataset is specifically structured for use in creating gender comparison plots.

# total_counts: A summarized table providing the total counts of males and females from the final visualization dataset (`summary_data`).
# This table serves as a sanity check to verify the overall gender distribution in the dataset.

# --------------------------------
# Data Reduction and Visualization
# --------------------------------

# Step 1: Data Reduction
# - Focus on key variables: patient_id, jc_gender, gs_age.
# - Create age groups using the `cut()` function for meaningful ranges.

# Step 2: Visualizations

# 1. Bar Plot: Gender and Age Group
# - Side-by-side bar plot (geom_bar) shows counts of males and females in each age group.
# - Purpose: Provides an overview of gender distribution by age.

# 2. Mirrored Bar Plot: Gender Comparison
# - Counts of males (negative x-axis) and females (positive x-axis) are plotted by age group.
# - Purpose: Highlights gender-specific trends in stroke incidence.

# 3. Combined Plot
# - Male Plot: Horizontal bars for males (green, #1C3A04).
# - Female Plot: Horizontal bars for females (light green, #7eb200).
# - Age Group Labels: Centralized for clarity.

# Step 3: Final Visualization
# - Combined plot compares stroke incidences across sex and age groups.
# - Purpose: Intuitive overview of demographic patterns in stroke incidence.

# ----------------------------
# Notes
# ----------------------------

# - The data and visualizations focus on biological sex and age as key factors in stroke incidence.
