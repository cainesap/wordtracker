#!/bin/bash
## Extract plain text and selected metadata from XML files
## Run from BNC root directory, assuming you've not changed file structure from the standard distribution

## create output directory if needed
mkdir -p Texts/plaintext

## load all XML files
FILES=( Texts/[A-K]/??/*.xml )

## initiate metadata file with header
META="Texts/plaintext/metadata.csv"
echo '"fileID","textClass","title","date"' > $META
TMP="tmp.txt"

# loop thru array
for FILE in "${FILES[@]}"
do
    ## parse filename
    echo $FILE
    FILENAMEFULL=$(basename "$FILE")
    FILENAMESHORT="${FILENAMEFULL%.*}"
    TEXTFILE="Texts/plaintext/"$FILENAMESHORT".txt"

    ## extract basic metadata
    xsltproc XML/Scripts/getMetadata.xsl $FILE >> $TMP
    grep $FILENAMESHORT $TMP

    ## extract the text and remove empty lines
    xsltproc XML/Scripts/justTheWords.xsl $FILE > $TEXTFILE
    sed -i '' '/^\s*$/d' $TEXTFILE
    echo "Plain text saved to $TEXTFILE"
done

## delete empty lines and save to metadata file
cat $TMP | sed '/^[^\"]/d' >> $META
sed -i ''  '/^\s*$/d' $META
rm $TMP
echo "Metadata file @ $META"
