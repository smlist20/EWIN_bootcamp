# Play a little MadLib Game

#read in text files from certain folder
#make a copy of a certain file_libbed

#open text file
#read places that say ADJECTIVE, ADVERB, VERB, NOUN (MadLib Tags)
#Ask for user input at each occurance of ""
#Put user input into place where the "" was listed
#Print out entire text file
#Close file and move to next one

import re, shutil, os

#make a copy of all mad libs files where answers are stored
source = '/Users/slist/Documents/MadTest'
destination_madlibs ='/Users/slist/Documents/MadTestAnswer'

shutil.copytree(source,destination_madlibs)


madlibNumRegex = re.compile(r'[A-Z]{2,}')
for folderName, subfolders, filenames in os.walk(destination_madlibs):
    print('The current folder is ' + folderName)
    for filename in filenames:
    #read places that say ADJECTIVE, ADVERB, VERB, NOUN 
        
        currentFile = open(folderName + '/' + filename,'r')
        content = currentFile.read()
        currentFile.close()
  #      print(content)
        mo = madlibNumRegex.findall(content)
    #Skip files with Mac weird file
        if filename == '.DS_Store':
            continue
    #Skip files without MadLib Tags 
        elif mo==None:
            continue
        r= 0
        #for r in range (0,len(mo)):
        while r<(len(mo)):
            digiterr = None
    #Ask for user input at each occurance of ADJECTIVE, ADVERB, VERB, NOUN
            print('Enter the ' + mo[r].lower() + ":")
            grammar = str(raw_input())
    #Check for any digits in the input
            gramcheckRegex = re.compile(r'\d')
            digiterr = gramcheckRegex.search(grammar)
            if digiterr != None:
                print('\nError. Input must be characters.\n')
                r = r-1
            
    #Put user input into place where the ADJECTIVE, ADVERB, VERB, NOUN was listed
            content = content.replace(mo[r],grammar,1)
            r = r + 1
        currentFile = open(folderName + '/' + filename,'w')
    #Re-write file and close answered madlib file
        currentFile.write(content)
        currentFile.close()
    #Print out entire text file
        print('\n' + content+'\n')
    #Ask user input to continue the game or not when it isn't the last Madlib file
        if filenames.index(filename) + 1 < len(filenames): 
            print('Well, that was fun. Would you like to continue? (y or n)')
            response = str(raw_input())
            if response == 'n':
                break
    #Move to next Madlib file
print('')