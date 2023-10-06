import os

loop = True
k = 100
for i in os.listdir('./train/'):
    path = './train/' + i
    
    newName = './train/' + f"{k}" + i[-4:]
    os.rename(path, newName)
    
    loop = not(loop)
    if loop == True:
        k+=1