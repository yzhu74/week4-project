The run_analysis.R script followed the 5 steps that were described in the definition:

1. Download the dataset and name it as UCI HAR Dataset
2. Assign variable names to each data, e.g. feature.txt was named features, subject_test.txt was named subject_test
3. Merging the training and the test datasets by using rbind()
4. Turn activities and subjects into factors and extract means and sds
5. Get our tidy_data.txt by writing another table from step 4
