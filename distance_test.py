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
    
    Motion.initial()
    Motion.wait_unlock()
    Motion.init(True)
    Motion.wait_unlock()

    # 미션 수행 함수 실행
    print("Loop 시작 :)")
    while True:
        frame = Camera.get_image()

        # image process
        img = frame.copy()
        Robot.is_ball, ballBox1, ballBox2 = Camera.hsvDetect(img)

        if Robot.is_ball:
            cv2.rectangle(frame, ballBox1, ballBox2, (0,0,255), 2)

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
            print(f"공과 로봇 거리 {int(Robot.robot_ball_distance)} cm")
            # 공에 가까이 가는 중에 순간 공이 감지되지 않았다면 일단 기다린다
            if not Robot.is_ball:
                plain_frame_count += 1
                if plain_frame_count > 5:
                    Robot.curr_mission = "FindBall"
                    plain_frame_count = 0
            # 공이 shot 가능한 위치에 있으면 goal을 찾는다
            elif Robot.is_ball and  12 <= Robot.robot_ball_distance <= 13:
                Robot.curr_mission == "FindGoal"
                plain_frame_count = 0
            # 공이 shot 불가능한 위치에 있으면 공으로 다가간다
            else:
                Robot.curr_mission = "ApproachBall"
                plain_frame_count = 0
          
        print(f"현재 상태 {Robot.curr_mission}")

        # motion
        # 1. FindBall
        if Motion.getRx() and Robot.curr_mission != "ApproachBall":
            pass
        elif Robot.curr_mission == "FindBall":
            Motion.init(True)
            Motion.wait_unlock()
            Motion.turn("LEFT", 45)
            Motion.wait_unlock()
            Robot.neck_pitch = 100
            Robot.neck_yaw = 0
        # 2. ApproachBall
        elif Robot.curr_mission == "ApproachBall":
            (xmin, ymin) = ballBox1
            (xmax, ymax) = ballBox2
            # 공에 다가가다가 순간 공이 안 보인 경우
            if not Robot.is_ball:
                pass
            # 공 bounding box가 화면 중앙에 오도록 움직이고 shot 가능할때까지 걸어간다
            else:
                if xmin < 270:
                    if Motion.getRx():
                        Motion.init()
                        Motion.wait_unlock()
                    Motion.turn("LEFT")
                    Motion.wait_unlock()
                elif xmax > 370:
                    if Motion.getRx():
                        Motion.init()
                        Motion.wait_unlock()
                    Motion.turn("RIGHT")
                    Motion.wait_unlock()
                elif ymin < 190 and Robot.neck_pitch < 100:
                    if Motion.getRx():
                        Motion.init()
                        Motion.wait_unlock() 
                    Robot.neck_pitch += 5
                    Motion.neckup(Robot.neck_pitch)
                    Motion.wait_unlock()
                elif ymax > 290 and Robot.neck_pitch > 35:
                    if Motion.getRx():
                        Motion.init()
                        Motion.wait_unlock()
                    Robot.neck_pitch -= 5
                    Motion.neckup(Robot.neck_pitch)
                    Motion.wait_unlock()
                
                elif Robot.robot_ball_distance > 15:
                    Motion.walk()
                elif Robot.robot_ball_distance > 13:
                    if Motion.getRx():
                        Motion.init()
                        Motion.wait_unlock()
                    Motion.step()
                    Motion.wait_unlock()
                elif Robot.robot_ball_distance < 12:
                    if Motion.getRx():
                        Motion.init()
                        Motion.wait_unlock()
                    Motion.step("BACK")
                    Motion.wait_unlock()
                else:
                    Motion.init()
                    Motion.wait_unlock()
                Robot.neck_yaw = 0

        # show the frame to our screen
        cv2.imshow("Frame", frame)
        if cv2.waitKey(1) == ord("q"):
            break
        
    cv2.destroyAllWindows()