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
plain_frame_count = 0

if __name__ == "__main__":
    
    Robot = Robot()
    Motion = Motion()
    Camera = Camera()
    
    direction = "CENTER"

    Motion.initial()
    Motion.init(True)

    # 미션 수행 함수 실행
    print("Loop 시작 :)")
    while True:
        frame = Camera.get_image()

        # image process
        hls = cv2.cvtColor(frame, cv2.COLOR_BGR2HLS)
        Robot.is_ball, ballBox = Camera.cvCircleDetect(hls)
        Robot.is_hole, holeBox = Camera.is_hole(hls)
        Robot.is_arrow, arrowBox = False, [0, 0, 0, 0]

        if Robot.is_ball:
            cv2.rectangle(frame, (ballBox[0], ballBox[1]), (ballBox[2], ballBox[3]), (0,0,255), 2)
        if Robot.is_hole:
            cv2.rectangle(frame, (holeBox[0]. holeBox[1]), (holeBox[2], holeBox[3]), (0,255,255), 2)
        if Robot.is_arrow:
            cv2.rectangle(frame, (arrowBox[0], arrowBox[1]), (arrowBox[2], arrowBox[3]), (255,255,255), 2)


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
            # 공에 가까이 가는 중에 순간 공이 감지되지 않았다면 일단 기다린다
            if not Robot.is_ball:
                plain_frame_count += 1
                if plain_frame_count > 5:
                    Robot.curr_mission = "FindBall"
                    plain_frame_count = 0
            # 공이 shot 가능한 위치에 있으면 goal을 찾는다
            elif Robot.is_ball and  12 <= Robot.robot_ball_distance <= 13:
                Robot.curr_mission == "FindGoal"
            # 공이 shot 불가능한 위치에 있으면 공으로 다가간다
            else:
                Robot.curr_mission = "ApproachBall"
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
        # 1. FindBall
        if Robot.curr_mission == "FindBall":
            Motion.init(True)
            Motion.turn("LEFT", 45)
            Robot.neck_pitch = 100
            Robot.neck_yaw = 0
        # 2. ApproachBall
        elif Robot.curr_mission == "ApproachBall":
            xmin, ymin, xmax, ymax = ballBox
            # 공에 다가가다가 순간 공이 안 보인 경우
            if not Robot.is_ball:
                pass
            # 공 bounding box가 화면 중앙에 오도록 움직이고 shot 가능할때까지 걸어간다
            else:
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
                
                if Robot.robot_ball_distance > 15:
                    Motion.walk()
                elif Robot.robot_ball_distance > 13:
                    Motion.step()
                elif Robot.robot_ball_distance < 12:
                    Motion.step("BACK")
                else:
                    Motion.init()
                Robot.neck_yaw = 0
        # 3. FindGoal
        elif Robot.curr_mission == "FindGoal":
            if Robot.neck_yaw == 0:
                Robot.neck_yaw = -90
                Motion.view(-90)
            elif Robot.neck_yaw == -90:
                Robot.neck_yaw = 0
                Motion.view(0)
        # 4. ApproachGoal
        elif Robot.curr_mission == "ApproachGoal":
            Robot.neck_pitch = 100
            Robot.neck_yaw = 0
            Motion.init(True)
            # TODO Motion.turn() 홀 찾아 원 궤도로 회전하는 동작
        # 5. Shot
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
