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
    Motion.init(True)
    time.sleep(3)

    # 미션 수행 함수 실행 - 반복 한 번에 동작 한 가지만 실행
    while True:
        frame = Camera.get_image()

        # image process
        Robot.is_hole, holeBox, Robot.is_ball, ballBox, Robot.is_arrow, arrowBox = Camera.yoloDetect_master(frame)

        # 공 인식
        # 공과의 거리가 12 이하, 13 이상이면 approach ball
        # 공과의 거리가 12~13이면 공을 칠 목표점을 찾아야 함
        # 공이 없으면 find ball
        xmin, ymin, xmax, ymax = ballBox
        if Robot.is_ball and Robot.neck_yaw == 0:
            cv2.rectangle(frame, (xmin, ymin), (xmax, ymax), (0,0,255), 2)
            Robot.robot_ball_distance = ball_distance(Robot.neck_pitch, ymax)
            print(f"distance: {Robot.robot_ball_distance}")
        # 홀 인식
        # 홀이 로봇 시선 중앙에 있으면 shot  
        elif Robot.is_hole:
            cv2.rectangle(frame, (holeBox[0], holeBox[1]), (holeBox[2], holeBox[3]), (255,255,0), 2)

        # show the frame to our screen
        cv2.imshow("Frame", frame)
        if cv2.waitKey(16) == ord("q"):
            break
        
    cv2.destroyAllWindows()
