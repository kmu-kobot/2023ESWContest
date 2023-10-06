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
    time.sleep(3)
    Motion.neckup(100)

    # 미션 수행 함수 실행 - 반복 한 번에 동작 한 가지만 실행
    while True:
        frame = Camera.get_image()

        ret, ballbox, output = Camera.yoloDetect(frame.copy())
        xmin, ymin, xmax, ymax = ballbox
        if ret:
            Robot.is_ball = True
            cv2.rectangle(frame, (xmin, ymin), (xmax, ymax), (255,0,0), 2)
        else:
            Robot.is_ball = False
        
        print(f"현재 미션:{Robot.curr_mission}")
        # 공 bounding box에 따라 목 각도 조절
        if Motion.getRx():
            pass
        elif Robot.is_ball == False:
            pass
        elif ymin < 170:     # 공 bounding box가 위에 있다면 고개 올리기
            if Robot.neck_pitch < 100:
                Robot.neck_pitch += 5
                Motion.neckup(Robot.neck_pitch)
            # else:
            #     Motion.step("FRONT")
        elif ymax > 310:     # 공 bounding box가 아래에 있다면 고개 내리기
            if Robot.neck_pitch > 35:
                Robot.neck_pitch -= 5
                Motion.neckup(Robot.neck_pitch)
            else:
                Motion.step("BACK")
        elif xmax > 390:
            Motion.crab("RIGHT")
        elif xmin < 250:
            Motion.crab("LEFT")
        elif Robot.robot_ball_distance > 12: # 공이 ROI 내에 있을 때
            if not Motion.getRx():
                Motion.step("FORWARD")
        elif Robot.robot_ball_distance > 11:
            Motion.init()
            time.sleep(1)
            Motion.shot()
        elif Robot.robot_ball_distance <= 10:
            Motion.step("BACK")
        # elif Robot.is_hole == False: # 공과 충분히 가까워졌지만 홀이 없을 때
        #     Motion.turn("LEFT", 45)
        Robot.robot_ball_distance = ball_distance(Robot.neck_pitch, ymax)

        print(f"pitch:{Robot.neck_pitch}\nyaw:{Robot.neck_yaw}\n로봇과공:{Robot.robot_ball_distance}")

        # show the frame to our screen
        cv2.imshow("Frame", frame)
        if cv2.waitKey(16) == ord("q"):
            break
        
    cv2.destroyAllWindows()
