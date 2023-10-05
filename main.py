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

        # run the YOLO model on the frame
        detections = Camera.yoloDetect(frame.copy())

        # img process
        # 1. loop over the detections - 공 인식
        ret, ballbox, output = Camera.yoloDetect(frame.copy())
        xmin, ymin, xmax, ymax = ballbox
        if ret:
            Robot.is_ball = True
            cv2.rectangle(frame, (xmin, ymin), (xmax, ymax), (255,0,0), 2)
        else:
            Robot.is_ball = False
        # 2. hole 인식
        ret, holebox = Camera.is_hole(frame.copy())
        if ret:
            cv2.rectangle(frame, (holebox[0], holebox[1]), (holebox[0]+holebox[2], holebox[1]+holebox[3]), (0,255,255), 2)
            Robot.is_hole = True
        else:
            Robot.is_hole = False

        # 4. bunker 인식
        # ret, bunkerbox = Camera.is_bunker(frame.copy())
        # if ret:
        #     cv2.rectangle(frame, (bunkerbox[0], bunkerbox[1]), (bunkerbox[0]+bunkerbox[2], bunkerbox[1]+bunkerbox[3]), (255,255,255), 2)
        #     Robot.is_bunker = True
        # else:
        #     Robot.is_bunker = False
        
        print(f"현재 미션:{Robot.curr_mission}")
        # 공 bounding box에 따라 목 각도 조절
        if Motion.getRx() and Robot.curr_mission != "WALKING":
            pass
        elif Robot.curr_mission == "FINDGOAL":
            if Robot.is_hole:
                if Robot.neck_yaw < 0:
                    Motion.turn("LEFT", 45)
                    Motion.view("CENTER")
                elif Robot.neck_yaw > 0:
                    Motion.turn("RIGHT", 45)
                    Motion.view("CENTER")
                Robot.neck_yaw = 0
                Robot.curr_mission = "SHOT"
            else:
                if Robot.neck_yaw >= 0:
                    Motion.view("LEFT")
                    Robot.neck_yaw = -45
                else:
                    Motion.view("RIGHT")
                    Robot.neck_yaw = 45
        elif Robot.curr_mission == "SHOT":
            Motion.shot()
            Robot.curr_mission = "WALKING"
        else:
            if Robot.is_ball == False:
                Motion.turn("LEFT", 10)
            elif ymin < 100:     # 공 bounding box가 위에 있다면 고개 올리기
                if Robot.neck_pitch < 100:
                    Robot.neck_pitch += 5
                    Motion.neckup(Robot.neck_pitch)
            elif ymin > 380:     # 공 bounding box가 아래에 있다면 고개 내리기
                if Robot.neck_pitch > 35:
                    Robot.neck_pitch -= 5
                    Motion.neckup(Robot.neck_pitch)
            elif xmin > 540:
                Motion.crab("RIGHT")
            elif xmax < 100:
                Motion.crab("LEFT")
            elif Robot.robot_ball_distance > 15: # 공이 ROI 내에 있을 때
                Motion.walk()
                Robot.curr_mission = "WALKING"
            elif Robot.robot_ball_distance <= 15:
                Robot.curr_mission = "FINDGOAL"
            # elif Robot.is_hole == False: # 공과 충분히 가까워졌지만 홀이 없을 때
            #     Motion.turn("LEFT", 45)
            Robot.robot_ball_distance = ball_distance(Robot.neck_pitch, ymax)

        print(f"로봇 목 각도:{Robot.neck_pitch} | 로봇과공:{Robot.robot_ball_distance}")

        # show the frame to our screen
        cv2.imshow("Frame", frame)
        if cv2.waitKey(16) == ord("q"):
            break
        
    cv2.destroyAllWindows()
