from Actuator.Motion import Motion
from Sensor.Camera import Camera
from Brain.Robot import Robot
from Brain.Robot_ball_distance import ball_distance

import cv2
import numpy as np
import time

CONFIDENCE_THRESHOLD = 0.8
GREEN = (0, 255, 0)

shot_count = 0

if __name__ == "__main__":
    
    Robot = Robot()
    Motion = Motion()
    Camera = Camera()
    
    direction = "CENTER"

    Motion.initial()
    Motion.init(True)
    
    cap = cv2.VideoCapture(0)
    while(True):
        frame = cap.read()
        detect = Camera.hsvDetect(frame)
        cv2.imshow("detect", detect)
        if cv2.waitKey(16) == ord("q"):
            break
    cv2.destroyAllWindows()