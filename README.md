# PDF Compressor Script

A shell script to automatically compress huge amounts of PDF's on a Linux server. After you added the script in your desired directory, it will loop through all 
existing direcrories and find all files with a ".pdf extension". 
The Script will then loop through all of the files and compress them.
After the compression was successful, the script will delete the old larger files so your file names won't change.
Also every step of the script will be logged in a seperate file in the same directory to give you all the information you need.

## Requirements
1. Functional installation of [Ghostscript](https://www.ghostscript.com/)

## Usage

1. Create a new ".sh" script in the same directory that you would like to be compressed.
2. Open the file with your desired editor.
3. Paste the script in the file and set your desired compression mode in the variables section.
    - <b>screen</b> selects low-resolution output similar to the Acrobat Distiller “Screen Optimized”
    - <b>ebook</b> selects medium-resolution output similar to the Acrobat Distiller “eBook” setting.
    - <b>printer</b> selects output similar to the Acrobat Distiller “Print Optimized” setting.
    - <b>prepress</b> selects output similar to Acrobat Distiller “Prepress Optimized” setting.
4. Make the file executable

```sudo chmod +x {filename}.sh```

5. Before you run the script you should backup your files first.
6. Run the script and 

```sudo ./{filename}.sh```

