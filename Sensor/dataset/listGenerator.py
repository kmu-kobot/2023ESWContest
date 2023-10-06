import os

f = open("./val.txt", "w")

skip = True

for i in os.listdir('./val/'):
    skip = not(skip)
    if skip == True:
        continue
    
    path = "/content/dataset/val/" + i + "\n"
    f.write(path)

f.close()
