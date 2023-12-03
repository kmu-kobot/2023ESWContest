# from Actuator.Motion import Motion
# from Sensor.Camera import Camera
# from Brain.Robot import Robot

import cv2
import numpy

def mouse_callback(event, x, y, flags, param):
    if event == cv2.EVENT_LBUTTONDOWN:
        print(f'({x}, {y})')

# Robot = Robot()
# Motion = Motion()
# Camera = Camera()

# Motion.initial()
# Motion.init(True)
# Motion.neckup(75)
# Motion.view(90)
    
cv2.namedWindow('frame')
cv2.setMouseCallback('frame', mouse_callback)

while True:
    img = numpy.zeros(shape=(480, 640, 3), dtype="uint8")

    cv2.line(img, (315,0), (522,480), (0,0,255), 1)
    cv2.line(img, (340,0), (522,480), (255,0,0), 1)
    cv2.line(img, (253,0), (470,480), (255,0,0), 1)
    
    # 5 degree
    #cv2.line(img, (360,0), (522,480), (200,200,0), 1)
    #cv2.line(img, (295,0), (522,480), (200,200,0), 1)
    
    # 10 degree
    cv2.line(img, (430,0), (522,480), (0,200,200), 1)
    # cv2.line(img, (253,0), (522,480), (0,200,200), 1)
    
    # 20 degree
    cv2.line(img, (500,0), (522,480), (200,0,200), 1)
    cv2.line(img, (150,0), (522,480), (200,0,200), 1)
    cv2.imshow('frame', img)

    key = cv2.waitKey(1)
    if key == 27:
        break

cv2.destroyAllWindows()
