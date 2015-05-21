all: run_analysis

run_analysis: getdata-projectfiles-UCIHARDataset.zip
	./run_analysis.R

getdata-projectfiles-UCIHARDataset.zip: 
	./get_data.R

clean:
	rm -rf getdata-projectfiles-UCIHARDataset.zip "UCI HAR Dataset" ucihar-tidy-subject-activity*.txt
