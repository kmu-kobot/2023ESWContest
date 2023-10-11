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
    time.sleep(3)

    # 미션 수행 함수 실행 - 반복 한 번에 동작 한 가지만 실행
    while True:
        frame = Camera.get_image()

        # image process
        Robot.is_hole, holeBox, Robot.is_ball, ballBox, Robot.is_arrow, arrowBox = Camera.yoloDetect_master(frame)


        # Finite State Machine
        # 1. FindBall
        if Robot.curr_mission == "FindBall":
            # 공이 있으면 공으로 다가간다
            if Robot.is_ball:
                Robot.curr_mission = "ApproachBall"
            # 공이 없으면 계속 공을 찾는다
            else:
                Robot.curr_mission = "FindBall"
        # 2. ApproachBall
        elif Robot.curr_mission == "ApproachBall":
            xmin, ymin, xmax, ymax = ballBox
            Robot.robot_ball_distance = ball_distance(Robot.neck_pitch, ymax)
            # 공이 shot 가능한 위치에 있으면 goal을 찾는다
            if Robot.is_ball and  12 <= Robot.robot_ball_distance <= 13:
                Robot.curr_mission == "FindGoal"
            # 공이 shot 불가능한 위치에 있으면 공으로 다가간다
            elif Robot.is_ball:
                Robot.curr_mission = "ApproachBall"
            # 공이 없으면 공을 찾는다 - Approach 동작을 수행하다가 공이 사라진 경우
            else:
                Robot.curr_mission = "FindBall"
        # 3. FindGoal
        elif Robot.curr_mission == "FindGoal":
            xmin, ymin, xmax, ymax = holeBox
            # goal이 shot 가능한 위치에 있으면 shot을 한다
            if Robot.is_hole and  300 < (xmin + xmax) // 2 < 340:
                Robot.curr_mission = "Shot"
            # goal이 shot 불가능한 위치에 있으면 goal을 찾아 회전한다
            else:
                Robot.curr_mission = "ApproachGoal"
        # 4. ApproachGoal
        elif Robot.curr_mission == "ApproachGoal":
            # goal을 찾아 한걸음 움직였으면 공과의 거리를 보정한다
            Robot.curr_mission = "ApproachBall"
        # 5. Shot
        elif Robot.curr_mission == "Shot":
            # shot을 하면 다음 shot을 위해 공을 찾는다
            Robot.curr_mission = "FindBall"
            shot_count += 1
           

        # motion
        if Robot.curr_mission == "FindBall":
            Motion.init(True)
            Motion.turn("LEFT", 45)
            Robot.neck_pitch = 100
            Robot.neck_yaw = 0
        elif Robot.curr_mission == "ApproachBall":
            xmin, ymin, xmax, ymax = ballBox
            if ymin < 190 and Robot.neck_pitch < 100:
                Robot.neck_pitch += 5
                Motion.neckup(Robot.neck_pitch)
            elif ymax > 290 and Robot.neck_pitch > 35:
                Robot.neck_pitch -= 5
                Motion.neckup(Robot.neck_pitch)
            if xmin < 270:
                Motion.crab("RIGHT")
            elif xmax > 370:
                Motion.crab("LEFT")
            
            if Robot.robot_ball_distance > 20:
                Motion.walk()
            elif Robot.robot_ball_distance > 13:
                Motion.step()
            elif Robot.robot_ball_distance < 12:
                Motion.step("BACK")
            else:
                Motion.init()
            Robot.neck_yaw = 0
        elif Robot.curr_mission == "FindGoal":
            if Robot.neck_yaw == 0:
                Robot.neck_yaw = -90
                Motion.view(-90)
            elif Robot.neck_yaw == -90:
                Robot.neck_yaw = 0
                Motion.view(0)
        elif Robot.curr_mission == "ApproachGoal":
            Robot.neck_pitch = 100
            Robot.neck_yaw = 0
            Motion.init(True)
            # Motion.turn() 홀 찾아 원 궤도로 회전하는 동작
        elif Robot.curr_mission == "Shot":
            Robot.neck_pitch = 100
            Robot.neck_yaw = 0
            Motion.shot()   
            Motion.init(True)
            time.sleep(10)
            print(f"{shot_count}번째 Shot 완료 >__<")   

        # show the frame to our screen
        cv2.imshow("Frame", frame)
        if cv2.waitKey(16) == ord("q"):
            break
        
    cv2.destroyAllWindows()
