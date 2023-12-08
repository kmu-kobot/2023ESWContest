from Actuator.Motion import Motion
from Sensor.Camera import Camera
from Brain.Robot import Robot

import cv2
import numpy as np


Robot = Robot()
Motion = Motion()
Camera = Camera()

Motion.initial()
Motion.wait_unlock()
Motion.init(True)
Motion.wait_unlock()
Motion.neckup(70)
Motion.wait_unlock()
Motion.view(-90)
Motion.wait_unlock()

def empty_callback(x):
    pass


cv2.namedWindow('Video')

h_min, s_min, v_min = 0, 0, 0
h_max, s_max, v_max = 179, 255, 255

cv2.createTrackbar('Hue Min', 'Video', h_min, 179, empty_callback)
cv2.createTrackbar('Saturation Min', 'Video', s_min, 255, empty_callback)
cv2.createTrackbar('Value Min', 'Video', v_min, 255, empty_callback)
cv2.createTrackbar('Hue Max', 'Video', h_max, 179, empty_callback)
cv2.createTrackbar('Saturation Max', 'Video', s_max, 255, empty_callback)
cv2.createTrackbar('Value Max', 'Video', v_max, 255, empty_callback)

while True:
    frame = Camera.get_image()

    h_min = cv2.getTrackbarPos('Hue Min', 'Video')
    s_min = cv2.getTrackbarPos('Saturation Min', 'Video')
    v_min = cv2.getTrackbarPos('Value Min', 'Video')
    h_max = cv2.getTrackbarPos('Hue Max', 'Video')
    s_max = cv2.getTrackbarPos('Saturation Max', 'Video')
    v_max = cv2.getTrackbarPos('Value Max', 'Video')

    hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV)

    lower_bound = np.array([h_min, s_min, v_min])
    upper_bound = np.array([h_max, s_max, v_max])
    mask = cv2.inRange(hsv, lower_bound, upper_bound)

    filtered_frame = cv2.bitwise_and(frame, frame, mask=mask)
    cv2.line(frame, (344,0), (520,480), (0,0,255), 1)
    cv2.line(frame, (350,0), (560,480), (255,0,0), 1)
    cv2.line(frame, (338,0), (480,480), (255,0,0), 1)
    
    # 5 degree
    cv2.line(frame, (374,0), (520,480), (200,200,0), 1)
    #cv2.line(frame, (314,0), (520,480), (200,200,0), 1)
    
    # 10 degree
    cv2.line(frame, (430,0), (520,480), (0,200,200), 1)
    cv2.line(frame, (250,0), (520,480), (0,200,200), 1)
    
    # 20 degree
    cv2.line(frame, (510,0), (520,480), (200,0,200), 1)
    cv2.line(frame, (140,0), (520,480), (200,0,200), 1)

    cv2.imshow('Frame', filtered_frame)

    if cv2.waitKey(1) & 0xFF == 27:
        break

cap.release()
cv2.destroyAllWindows()
