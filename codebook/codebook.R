# Codebook

# Description of data: wishes_pro_data.csv
# Number of Rows: 220
# Number of Columns: 237
# Purpose: This dataset contains detailed information about patients, focusing on factors related to stroke incidence and outcomes.
# Source: Women’s Imaging of Stroke Hemodynamics Study (WISHeS). Led by Principal Investigator Dr. Adrienne N. Dula, The University of Texas at Austin. Supported by the Lone Star Stroke Research Consortium, 2022-2024.

# Key Variables Description of data
# 1. patient_id: Unique identifier for each patient.
# 2. jc_gender: Gender of the patient (coded numerically, e.g., 1 = Male, 2 = Female).
# 3. gs_age: Patient's age at the time of data collection.
# 4. pregnancy_number: Total number of pregnancies (for applicable patients).
# 5. miscarriage_num: Number of miscarriages (for applicable patients).
# 6. nihss_discharge: NIHSS score at discharge, measuring stroke severity.
# 7. fu_mrs_90day: Functional outcome (Modified Rankin Scale) at 90 days post-stroke.
# 8. treatment_recvd: Indicates if the patient received treatment (categorical or binary).
# 9. gs_stroketype: Type of stroke experienced by the patient (e.g., ischemic, hemorrhagic).
# 10. lvo_m1: Indicates involvement of the M1 segment in large vessel occlusion.

# Variable Types and Data Summary
# Numeric Variables: Measures like age, NIHSS scores, and various clinical values.
# Categorical Variables: Coded values representing characteristics such as gender, treatment type, and race.
# Missing Values: Some columns (e.g., pregnancy-related variables) have missing or NaN values for inapplicable participants.

# Example Data (First 5 Rows)
# | patient_id | jc_gender | pregnancy_number | miscarriage_num | gs_age | ... |
# |------------|-----------|------------------|-----------------|--------|-----|
# | 1          | 2         | 2.0              | 1.0             | 35     | ... |
# | 2          | 1         | NaN              | NaN             | 45     | ... |
# | 3          | 1         | NaN              | NaN             | 50     | ... |
# | 4          | 1         | NaN              | NaN             | 60     | ... |
# | 5          | 1         | NaN              | NaN             | 55     | ... |

# Notes
# Data Structure: The dataset has a mix of demographic, clinical, and outcome variables.
# Missing Data: Certain variables, especially related to pregnancy or gender-specific factors, have missing values for inapplicable participants.
# Column Naming: Many columns use shorthand or coded names (e.g., gs_nihss1a, lvo_m1), which may require further explanation for clarity. Refer to wishes_readcapvariables_datadictionary in \data folder for more details.

# Description of reduced_Wishes_data

# Dataset Overview
# - Dataset Name: reduced_Wishes_data
# - Purpose: Analyzing stroke incidence across genders and age groups.
# - Source: Derived from a larger WISHeS dataset (data) by selecting relevant variables and transforming them for analysis and visualization.

# Variables in reduced_Wishes_data
# 1. patient_id
#    - Description: A unique identifier for each patient.
#    - Type: Numeric
#    - Purpose: Links records to individual patients.

# 2. jc_gender
#    - Description: Gender of the patient.
#    - Type: Categorical (1 = Male, 2 = Female)
#    - Purpose: Allows comparison of stroke incidence across genders.

# 3. gs_age
#    - Description: Age of the patient.
#    - Type: Numeric
#    - Purpose: Used to group patients into age categories for analysis.

# 4. age_group (created variable)
#    - Description: Age groups derived from gs_age using specified ranges.
#    - Type: Categorical (e.g., "0-19", "20-25", ..., "100+").
#    - Purpose: Facilitates comparison of stroke incidence by age ranges.

# Code Summary

# Step 1: Data Reduction
# - The dataset is reduced to focus on three primary variables: patient_id, jc_gender, and gs_age.
# - Age groups are created using the cut() function with meaningful ranges for age intervals (e.g., 5-year spans).

# Step 2: Visualizations
# 1. Bar Plot for Gender and Age Group: Initial 
#    - A side-by-side bar plot (geom_bar) shows counts of males and females in each age group, 
#      with distinct colors for gender (blue for males, pink for females).
#    - X-axis labels are rotated for clarity.
#    - Purpose: Provides an overview of gender distribution across age groups.

# 2. Mirrored Bar Plot for Gender Comparison: Initial
#    - Counts of males (negative x-axis) and females (positive x-axis) are plotted by age group, 
#      creating a mirrored effect. 
#    - Purpose: Highlights gender-specific trends in stroke incidence within age groups.

# 3. Combined Plot: Final
#    - Three subplots are created:
#       - Male Plot: Displays stroke incidences for males using horizontal bars, colored green (#1C3A04).
#       - Female Plot: Displays stroke incidences for females with a lighter green color (#7eb200).
#       - Age Group Labels: Centralizes age group labels for easy identification.
#    - The plots are combined side-by-side with titles, captions, and custom themes.

# Step 3: Final Visualization
# - The combined plot compares stroke incidences across genders and age groups.
# - It integrates mirrored plots for males and females, centered by age group labels, providing an intuitive overview of demographic patterns in stroke incidence.

