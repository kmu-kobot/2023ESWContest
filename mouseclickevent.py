from Actuator.Motion import Motion
from Sensor.Camera import Camera
from Brain.Robot import Robot

import cv2

def mouse_callback(event, x, y, flags, param):
    if event == cv2.EVENT_LBUTTONDOWN:
        print(f'({x}, {y})')

Robot = Robot()
Motion = Motion()
Camera = Camera()
    
cv2.namedWindow('frame')
cv2.setMouseCallback('frame', mouse_callback)

while True:
    frame = Camera.get_image()

    cv2.line(frame, (325,0), (522,480), (0,0,255), 2)
    cv2.line(frame, (335,0), (595,480), (255,0,0), 2)
    cv2.line(frame, (313,0), (447,480), (255,0,0), 2)
        
    cv2.imshow('frame', frame)

    key = cv2.waitKey(1)
    if key == 27:
        break

cv2.destroyAllWindows()
