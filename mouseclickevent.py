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
Motion.neckup(70)
Motion.view(-90)
    
cv2.namedWindow('frame')
cv2.setMouseCallback('frame', mouse_callback)

while True:
    frame = Camera.get_image()

    cv2.line(frame, (325,0), (522,480), (0,0,255), 1)
    cv2.line(frame, (333,0), (580,480), (255,0,0), 1)
    cv2.line(frame, (253,0), (470,480), (255,0,0), 1)
        
    # 5 degree
    cv2.line(frame, (360,0), (522,480), (200,200,0), 1)
    cv2.line(frame, (295,0), (522,480), (200,200,0), 1)
        
    # 10 degree
    cv2.line(frame, (430,0), (522,480), (0,200,200), 1)
    cv2.line(frame, (253,0), (522,480), (0,200,200), 1)
        
    # 20 degree
    cv2.line(frame, (500,0), (522,480), (200,0,200), 1)
    cv2.line(frame, (150,0), (522,480), (200,0,200), 1)
        
    cv2.imshow('frame', frame)

    key = cv2.waitKey(1)
    if key == 27:
        break

cv2.destroyAllWindows()
