import csv
inputfile = 'flower_data.txt'
flowerlist = []

with open(inputfile) as newinputfile:
    flowerlist = list(csv.reader(newinputfile))
    #return flowerlist
newinputfile.close()
#flowerlist=[]
#
#flowerText = open('Documents/flower_data.txt')
#
#for row in flowerText.readlines():
#
#    flowerlist.append(row.split(',')) 
#
#for i in range(len(flowerlist)):
#
#    flowerlist[i][4] = flowerlist[i][4].rstrip('\n')     
    
for k in range(len(flowerlist)):

    if flowerlist[k][4] == 'Iris-setosa':
    
        flowerlist[k].append('1')
    
    if flowerlist[k][4] == 'Iris-versicolor':
    
        flowerlist[k].append('0')
    
    if flowerlist[k][4] == 'Iris-virginica':
    
        flowerlist[k].append('0')
    
        #flowerText.close()
def calculate_net(w,x):
    net = 0
    for h in range(numinput):
    #net = w[0]*x[0] + w[1]*x[1]
        net = net + w[h]*x[h] 
    return net

def phi(net):

    if net > 0:

        return 1

    else:

        return -1
        
def changeweights(Y, Yhat, x, w):
    new_w = w
    for u in range(numinput):
        
        delta_w[u] = eta*(Y- Yhat) * x[u]
        new_w[u] = new_w[u] + delta_w[u]
    return new_w
#Here we have the number of input columns we'll be using for this dataset. 

numinput = int(len(flowerlist[0])-2)
w = [0.1]*(numinput)

x = [0.0]*(numinput)

delta_w = [0.0]*(numinput)

eta = 0.01

N_epochs = 50

for j in range(N_epochs):

    for i in range(len(flowerlist)):

        Y = int(flowerlist[i][5])
#Here is the loop that generalizes the perceptron for any number of input columns. 
#The last two columns are the flower type in string and int form, respectively.

        for m in range(numinput):
            
            x[m] = float(flowerlist[i][m])
            
            #x[0] = float(flowerlist[i][0])
            #
            #x[1] = float(flowerlist[i][1])
            
        net = calculate_net(w,x)
            
        Yhat = phi(net)
        w = changeweights(Y,Yhat,x,w)  
        
            
            #delta_w[0] = eta*(Y- Yhat) * x[0]
            #
            #delta_w[1] = eta*(Y- Yhat) * x[1]
            
       
            #w[0] = w[0] + delta_w[0]
            #
            #w[1] = w[1] + delta_w[1]
    
    print w 