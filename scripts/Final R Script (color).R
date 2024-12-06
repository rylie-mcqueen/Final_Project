######## FINAL SCRIPT #############
# This script analyzes stroke incidence data using visualizations and data manipulation.

# ---------------------------
# Install Necessary Packages
# ---------------------------
# Install packages required for data manipulation, visualization, and table formatting.
# Function to install and load multiple packages
install_and_load <- function(packages) {
  for (package in packages) {
    if (!require(package, character.only = TRUE)) {
      install.packages(package)
      library(package, character.only = TRUE)
    }
  }
}

# List of packages
packages <- c("tidyverse", "patchwork", "ggplot2", "bslib", "kableExtra", "dplyr")

# ------------------------
# Load Necessary Libraries
# ------------------------

library(tidyverse) # Loads the entire tidyverse suite for data manipulation and visualization
library(patchwork) # Enables combining multiple ggplot objects
library(ggplot2)   # Core package for creating plots
library(bslib)     # Provides tools for theming Shiny applications
library(kableExtra) # Enhances the appearance of tables on RMarkdown
library(dplyr)     # Part of tidyverse but loaded explicitly for clarity

# --------------------------
# Load and Inspect Raw Data
# --------------------------

# Load the raw dataset
# Replace 'data/wishes_pro_data_current.csv' with the actual path to your CSV file
data <- read.csv("data/wishes_pro_data_current.csv") 

# Quick inspection of the dataset
head(data)  # Displays the first few rows of the dataset for an overview
# Note: The dataset is large, containing 239 variables. We will filter and select variables of interest in subsequent steps.

# ---------------------------
# Data Preparation
# ---------------------------

# Sanity Check: Count the number of males and females in the dataset
# 'jc_gender': 1 = male, 2 = female
gender_counts <- data %>%
  count(jc_gender)
print(gender_counts) # Display gender counts for verification

# Sanity Check: Determine the min and max age in the dataset
max_age <- data %>%
  summarise(max_age = max(gs_age, na.rm = TRUE)) # Calculate maximum age, ignoring NA values
print(max_age) # Display maximum age (expected max = 97)

min_age <- data %>%
  summarise(min_age = min(gs_age, na.rm = TRUE)) # Calculate minimum age, ignoring NA values
print(min_age) # Display maximum age (expected min = 21)

# Reduce the dataset to variables of interest
# Retain only patient ID, gender, and age columns
reduced_Wishes_data <- data %>%
  select(patient_id, jc_gender, gs_age) # Select relevant columns

# Add a derived variable for age groups
reduced_Wishes_data <- reduced_Wishes_data %>%
  mutate(age_group = cut(gs_age, 
                         breaks = c(0, 19, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100, Inf),  # Define 5-year age group ranges
                         labels = c("0-19", "20-25", "26-30", "31-35", "36-40", "41-45", "46-50", "51-55", "56-60", "61-65", "66-70", "71-75", "76-80", "81-85", "86-90", "91-95", "96-100", "100+"),   # Corresponding labels
                         right = TRUE))  # Include the upper bound in the range

# --------------------------------------------------
# First Visualization: Stroke Incidence by Age Group
# ---------------------------------------------------

# Simple bar plot comparing the incidence of strokes in males vs females across age groups
ggplot(reduced_Wishes_data, aes(x = age_group, fill = factor(jc_gender))) +
  geom_bar(position = "dodge") +  # Display bars side-by-side for easy comparison
  labs(
    title = "Comparison of Stroke Incidence in Male vs Female by Age Group",
    x = "Age Group",  # Label for x-axis
    y = "Count",      # Label for y-axis
    fill = "Gender"   # Legend label
  ) +
  scale_fill_manual(values = c("#1C3A04", "#7eb200")) +  # Assign custom colors to genderss
  theme_minimal() +  # Use a clean, minimal theme for the plot
  theme(axis.text.x = element_text(angle = 45, hjust = 1))  # Rotate x-axis labels for better readability

# Save the first visualization
ggsave("first_initial_visualization.png", width = 10, height = 8)

# ---------------------------------------
# Second Visualization: Mirrored Bar Plot
# ---------------------------------------

# Count males and females in each age group
age_gender_count <- reduced_Wishes_data %>%
  group_by(age_group, jc_gender) %>%
  summarise(count = n(), .groups = "drop")  # Count the number of cases and remove grouping after summarization

# Create a mirrored bar plot to visualize stroke incidence by age group and gender
ggplot(age_gender_count, aes(x = count, y = age_group, fill = factor(jc_gender))) +
  geom_bar(data = subset(age_gender_count, jc_gender == 1), # Filter data for males
           aes(x = -count),  # Plot males on the left (negative x-axis)
           stat = "identity", 
           position = "dodge") +  # Side-by-side bars for males and females
  geom_bar(data = subset(age_gender_count, jc_gender == 2), # Filter data for females
           stat = "identity", 
           position = "dodge") +   # Plot females on the right (positive x-axis)
  scale_fill_manual(values = c("#1C3A04", "#7eb200"), # Assign custom colors for genders
                    labels = c("Male", "Female")) +   # Label the legend entries
  labs(
    title = "Stroke Incidence by Age Group and Gender",
    x = "Number of Stroke Cases",  # Label for x-axis
    y = "Age Group",               # Label for y-axis
    fill = "Gender"                # Legend label
  ) +
  theme_minimal() +    # Apply a clean, minimalistic theme
  theme(axis.text.x = element_text(angle = 45, hjust = 1))  # Rotate x-axis labels for readability

# Save the second visualization
ggsave("second_initial_visualization.png", width = 10, height = 8)

# ----------------------------
# Final Combined Visualization
# ----------------------------

# Transform the dataset by adding derived variables and filtering missing data
data <- data %>%
  mutate(    # Create an 'age_group' variable by cutting 'gs_age' into predefined intervals
    age_group = cut(
      gs_age,
      breaks = c(0, 20, seq(25, 100, by = 5)),   # Define age intervals: 0-20 and increments of 5 years from 25 to 100
      labels = c("0-19", "20-24", "25-29", "30-34", "35-39", "40-44", 
                 "45-49", "50-54", "55-59", "60-64", "65-69", "70-74", 
                 "75-79", "80-84", "85-89", "90-94", "95-99"),  # Assign corresponding labels to each interval
      right = FALSE   # Exclude the upper bound of each interval (e.g., 20 belongs to the next group)
    ),
    gender = recode(jc_gender, `1` = "Male", `2` = "Female")  # Recode the gender variable ('jc_gender') into a more descriptive format
  ) %>%
  drop_na(age_group, gender) # Remove rows with missing values in 'age_group' or 'gender'

# Summarize data to prepare it for visualization
summary_data <- data %>%
  group_by(age_group, gender) %>%  # Group data by age group and gender
  summarise(count = n(), .groups = 'drop') %>%  # Count the number of rows in each group, dropping extra grouping
  pivot_wider(names_from = gender, values_from = count, values_fill = 0) %>%   # Reshape data to have separate columns for Male and Female, populate the reshaped table with counts, fill missing values with 0  
  mutate(Male = -Male) # Make male counts negative for mirrored visualization

# Create a bar plot for males
plot_male <- ggplot(summary_data, aes(x = Male, y = age_group)) +
  geom_col(fill = "#1C3A04") + # Use a dark green color for male bars
  scale_x_continuous(labels = abs, breaks = seq(min(summary_data$Male, na.rm = TRUE), 0, by = 2)) + # Set x-axis breaks for males
  labs(x = "Number of Stroke Incidences", y = NULL) +  # Add x-axis label and suppress y-axis label
  theme_minimal() +   # Use a minimalistic theme
  theme(
    axis.text.y = element_blank(),  # Hide y-axis text
    axis.ticks.y = element_blank(), # Remove y-axis ticks
    panel.grid.major.y = element_blank(), # Remove horizontal grid lines
    plot.title = element_text(hjust = 0.5, size = 12, color = "#1C3A04") # Center and style the plot title
  ) +
  ggtitle("Male")  # Add a title for the male plot

# Create the female plot
plot_female <- ggplot(summary_data, aes(x = Female, y = age_group)) +
  geom_col(fill = "#7eb200") +  # Use a light green color for female bars
  scale_x_continuous(breaks = seq(0, max(summary_data$Female, na.rm = TRUE), by = 2)) +  # Set x-axis breaks for females
  labs(x = "Number of Stroke Incidences", y = NULL) +  # Add x-axis label and suppress y-axis label
  theme_minimal() +    # Use a minimalistic theme
  theme(
    axis.text.y = element_blank(),  # Hide y-axis text
    axis.ticks.y = element_blank(), # Remove y-axis ticks
    panel.grid.major.y = element_blank(),  # Remove horizontal grid lines
    plot.title = element_text(hjust = 0.5, size = 12, color = "#7eb200") # Center and style the plot title
  ) +
  ggtitle("Female")  # Add a title for the female plot

# Create a plot to display age group labels in the center
plot_labels <- ggplot(summary_data, aes(x = 1, y = age_group, label = age_group)) +
  geom_text() +  # Add text labels for each age group
  theme_void() + # Remove all default plot elements
  theme(
    plot.title = element_text(hjust = 0.5, size = 12, face = "bold") # Center and bold the plot title
  ) +
  ggtitle("Age Group")  # Add a title for the age group plot

# Combine the male, female, and label plots into a final visualization
combined_plot <- plot_male + plot_labels + plot_female +
  plot_layout(widths = c(4, 1, 4)) +  # Set relative widths for the three components
  plot_annotation(
    title = "Comparing Stroke Incidence Between Males and Females Across Age Groups",  # Add an overall title
    caption = "Data Source: WISHeS Study",  # Add a caption for the reference 
    theme = theme(
      plot.title = element_text(hjust = 0.5, size = 13, face = "bold"),   # Style the overall title
      plot.caption = element_text(hjust = 0, size = 10, face = "italic")  # Style the caption
    )
  )

# Save the combined plot
ggsave("combined_plot.png", plot = combined_plot, width = 10, height = 8)  # Save the plot as a PNG file with specified dimensions 
