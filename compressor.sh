# Shell script to automatically compress huge amounts of PDF's on a Linux server.
# After you added the script in your desired directory, it will loop through all existing direcrories and 
# find all PDF files. The Script will then loop through all of the files and compress them. 
# After the compression was successful, the script will delete the older large files so your file names don't change.
# Also every step of the script will be logged in a seperate file in the same directory to give you all the information you need.

# Variables and preparation
{
  count=0
  success=0
  successlog=./success.tmp
  gain=0
  gainlog=./gain.tmp
  pdfs=$(find ./ -type f -name "*.pdf")
  total=$(echo "$pdfs" | wc -l)
  log=./log
  verbose="-dQUIET"
  mode="prepress"
  echo "0" | tee $successlog $gainlog > /dev/null
}

# Are there any PDFs?
if [ "$total" -gt 0 ]; then

    #Parameter Handling & Logging
    {
        echo "-- Debugging for Log START --"
        echo "Number of Parameters: $#"
        echo "Parameters are: $*"
        echo "-- Debugging for Log END   --"
    } >> $log

    # Only compression-mode set
    if [ $# -eq 1 ]; then
        mode="$1"
    fi

    # Also Verbose Level Set
    if [ $# -eq 2 ]; then
        mode="$1"
        verbose=""
    fi

    echo "$pdfs" | while read -r file
    do
        ((count++))
        echo "Processing File #$count of $total Files" | tee -a $log
        echo "Current File: $file "| tee -a $log
        gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS="/$mode" -dNOPAUSE \
                -dBATCH $verbose -sOutputFile="$file-new" "$file" | tee -a $log
    
        sizeold=$(wc -c "$file"     | cut -d' ' -f1)
        sizenew=$(wc -c "$file-new" | cut -d' ' -f1)
        difference=$((sizenew-sizeold))

        # Check if new filesize is smaller
        if [ $difference -lt 0 ]
        then
            rm "$file"
            mv "$file-new" "$file"
            printf "Compression was successful. New File is %'.f Bytes smaller\n" \
                    $((-difference)) | tee -a $log
            ((success++)) 
            echo $success > $successlog
            ((gain-=difference))
            echo $gain > $gainlog
        else
            rm "$file-new"
            echo "Compression was not necessary" | tee -a $log
        fi

    done

    # Print Statistics
    printf "Successfully compressed %'.f of %'.f files\n" $(cat $successlog) $total | tee -a $log
    printf "Saved a total of %'.f Bytes\n" $(cat $gainlog) | tee -a $log

    rm $successlog $gainlog

else
    echo "No PDF File in Directory"
fi
