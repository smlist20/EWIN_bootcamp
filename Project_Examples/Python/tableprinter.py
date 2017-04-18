tableData = [['apples', 'oranges', 'cherries', 'banana'],
             ['Alice', 'Bob', 'Carol', 'David'],
             ['dogs', 'cats', 'moose', 'goose']]

def printTable(Data):
  #  i = 0
    colWidths = [0]

    for r in range(0,len(Data[1])):
        colWidths= [0] * len(Data)
        i = 0
        for k in range(0,len(Data)):
            
            colWidths[i] = len(Data[k][r])
            
        #print colWidths
        print max(colWidths)
        
        i = i + 1
        print(Data[k][r].rjust(max(colWidths)))
    #rjust()


printTable(tableData)