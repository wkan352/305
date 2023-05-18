
import cv2
 
img = cv2.imread("Images\menu_btns.png")

for i in range(img.shape[0]):
    f = open("MIF files\welcome_menu.txt", "a")
    newData = '"'
    for j in range(img.shape[1]):

        if img[i][j][0] == 255 and img[i][j][1] == 255 and img[i][j][2] == 255:
            newData = newData + "0"
        else:
            newData = newData + "1"
    
    newData = newData + '",\n'
    f.write(newData)
    f.close()
