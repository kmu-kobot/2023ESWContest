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
        if Robot.is_ball:
            cv2.rectangle(frame, (xmin, ymin), (xmax, ymax) (0,0,255), 2)
            Robot.robot_ball_distance = ball_distance(Robot.neck_pitch, ymax)
            if Robot.robot_ball_distance > 13:
                if not Motion.getRx():
                    Motion.walk()
                Robot.curr_mission = "APPROACHBALL"
            elif Robot.robot_ball_distance < 12:
                Motion.step("BACK")
                Robot.curr_mission = "APPROACHBALL"
            else:
                Motion.init()
                Robot.curr_mission == "FINDGOAL"
        else:
            Robot.curr_mission = "FINDBALL"

        # 홀 인식
        # 홀이 로봇 시선 중앙에 있으면 shot
        if Robot.is_hole and Robot.curr_mission == "FINDGOAL" and Robot.neck_yaw == -90:
            cv2.rectangle(frame, (holeBox[0], holeBox[1]), (holeBox[2], holeBox[3]), (255,255,0), 2)
            if 300 < (holeBox[0] + holeBox[2]) / 2 < 340:
                Robot.curr_mission = "SHOT"


        # motion
        if Motion.getRx() and Robot.curr_mission != "APPROACHBALL":
            pass
        # shot 가능한 거리라면 hole을 찾기 위해 목을 돌림
        elif Robot.curr_mission == "FINDGOAL":
            if Robot.neck_yaw == 0:
                Robot.neck_yaw = -90
                Motion.view(-90)
            elif Robot.neck_yaw == -90:
                Robot.neck_yaw = 0
                Motion.view(0)
        # 공이 감지된 후 공으로 다가감
        elif Robot.curr_mission == "APPROACHBALL":
            if ymin < 190:
                if Robot.neck_pitch < 100:
                    Robot.neck_pitch += 5
                    Motion.neckup(Robot.neck_pitch)
            elif ymax > 290:
                if Robot.neck_pitch > 35:
                    Robot.neck_pitch -= 5
                    Motion.neckup(Robot.neck_pitch)
            if xmin < 270:
                Motion.crab("RIGHT")
            elif xmax > 370:
                Motion.crab("LEFT")
        # 공과 충분히 가까워진 후 샷
        elif Robot.curr_mission == "SHOT":
            Motion.view(0)
            Motion.shot()
            time.sleep(10)
            Motion.init(True)
        elif Robot.curr_mission == "FINDBALL":
            Motion.init(True)
            Motion.turn("LEFT", 45)
        

        # show the frame to our screen
        cv2.imshow("Frame", frame)
        if cv2.waitKey(16) == ord("q"):
            break
        
    cv2.destroyAllWindows()
