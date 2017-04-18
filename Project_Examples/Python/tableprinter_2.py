tableData = [['apples', 'oranges', 'cherries', 'banana'],
             ['Alice', 'Bob', 'Carol', 'David'],
             ['dogs', 'cats', 'moose', 'goose']]

def printTable(Data):

    colWidths= [0] * len(Data)
 
    for k in range(0,len(Data)):
            
        colWidths[k] = len(max(tableData[k]))
    return colWidths
    i = 0
    for r in range(0,len(Data[1])):
        print(tableData[i][r].rjust.colWidths[i] + 
        tableData[i+1][r].rjust.colWidths[i+1] +
        tableData[i+2][r].rjust.colWidths[i+2] + 
        tableData[i+3][r].rjust.colWidths[i+3])#create each correctly spaced line
            
    print('\n')#join all lines up
    #print colWidths
    
    #rjust()


printTable(tableData)
