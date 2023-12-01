from Actuator.Motion import Motion
from Sensor.Camera import Camera
from Brain.Robot import Robot

import cv2
import numpy

def mouse_callback(event, x, y, flags, param):
    if event == cv2.EVENT_LBUTTONDOWN:
        print(f'({x}, {y})')

Robot = Robot()
Motion = Motion()
Camera = Camera()

Motion.initial()
Motion.init(True)
Motion.neckup(80)
Motion.view(-90)
    
cv2.namedWindow('frame')
cv2.setMouseCallback('frame', mouse_callback)

while True:
    img = Camera.get_image()

    cv2.line(img, (350,0), (120,480), (0,0,255), 1)
    cv2.line(img, (360,0), (150,480), (255,0,0), 1)
    cv2.line(img, (340,0), (90,480), (255,0,0), 1)
    # 5 degree
    cv2.line(img, (390,0), (120,480), (200,200,0), 1)
    cv2.line(img, (310,0), (120,480), (200,200,0), 1)
    # 10 degree
    cv2.line(img, (460,0), (120,480), (0,200,200), 1)
    cv2.line(img, (240,0), (120,480), (0,200,200), 1)
    # 20 degree
    cv2.line(img, (520,0), (120,480), (200,0,200), 1)
    cv2.line(img, (180,0), (120,480), (200,0,200), 1)
        
    cv2.imshow('frame', img)

    key = cv2.waitKey(1)
    if key == 27:
        break

cv2.destroyAllWindows()
