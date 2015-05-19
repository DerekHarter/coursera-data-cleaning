DATA_ARCHIVE=getdata-projectfiles-UCIHARDataset.zip

all:
	echo "All"

get_data: 
	./get_data.R

clean:
	rm -rf ${DATA_ARCHIVE} "UCI HAR Dataset"
