
import cv2
 
img = cv2.imread("Images\pipe_stripes.png") 
f = open("MIF files\pipe.txt", "w")


f.write("-- Welcome Text Displaying Using MIF\n")
f.write("WIDTH=" + str(img.shape[1]) + ";\n") # HOW LONG IS THE DATA
f.write("DEPTH=" + str(img.shape[0]) + ";\n") # HOW MANY ADDRESSES
f.write("ADDRESS_RADIX=UNS;\n")
f.write("DATA_RADIX=BIN;\n")
f.write("CONTENT BEGIN\n")

# Generating Data for the alpha channel 
for i in range(img.shape[0]): # Looping through the rows
        
    newData = ''
    for j in reversed(range(img.shape[1])): # Looping through the cols

        if img[i][j][0] == 255 and img[i][j][1] == 255 and img[i][j][2] == 255:
            newData = newData + "0"
        else:
            newData = newData + "1"
        
    newData = newData + ';\n'
    f.write("\t\t"+ str(i) + "\t:\t" + newData)
f.write("END;")
f.close()