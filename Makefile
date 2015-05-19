all: run_analysis

run_analysis:
	./run_analysis.R

get_data:
	./get_data.R

clean:
	rm -rf getdata-projectfiles-UCIHARDataset.zip "UCI HAR Dataset" ucihar-tidy-subject-activity*.txt
