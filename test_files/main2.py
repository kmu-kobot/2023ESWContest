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

    # 시리얼 연결 확인 동작
    Motion.initial()
    # 초기 자세
    Motion.init()

    # 미션 수행 함수 실행 - 반복 한 번에 동작 한 가지만 실행
    while True:
        frame = Camera.get_image()
		output = Camera.yoloDetect_master(frame)
        cv2.imshow("detect", output)
        if cv2.waitKey(16) == ord("q"):
            break

    cv2.destroyAllWindows()
