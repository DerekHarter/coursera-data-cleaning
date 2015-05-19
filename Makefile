DATA_ARCHIVE=getdata-projectfiles-UCIHARDataset.zip

all: run_analysis

run_analysis:
	echo "run_analysis"

get_data: 
	./get_data.R

clean:
	rm -rf ${DATA_ARCHIVE} "UCI HAR Dataset"
