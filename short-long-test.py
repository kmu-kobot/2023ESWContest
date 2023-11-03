from Actuator.Motion import Motion
from Sensor.Camera import Camera
from Brain.Robot import Robot
from Brain.Robot_ball_distance import ball_distance

import cv2
import numpy as np
import time

shot_count = 0
plain_frame_count = 0
clockwise = "Left"

if __name__ == "__main__":
    
    Robot = Robot()
    Motion = Motion()
    Camera = Camera()
    
    Motion.initial()
    Motion.wait_unlock()
    Motion.init(True)
    Motion.wait_unlock()
    Motion.neckup(70)
    Motion.wait_unlock()
    neck_before_find = 70

    # 미션 수행 함수 실행
    print("Loop 시작 :)")
    while True:
        frame = Camera.get_image()

        # image process
        img = frame.copy()
        Robot.is_ball, ballBox1, ballBox2 = Camera.hsvDetect(img)
        Robot.is_bunker, bunkerL, bunkerR = Camera.is_bunker(img)
        # Robot.shotzone, hole_frame = Camera.shotzoneChecker(img)

        if Robot.is_ball:
            cv2.rectangle(frame, ballBox1, ballBox2, (0,0,255), 2)
        if Robot.is_bunker:
            cv2.circle(frame, (bunkerL, 5, (255,255,255), -1))
            cv2.circle(frame, (bunkerR, 5, (255,255,255), -1))

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
            (xmin, ymin) = ballBox1
            (xmax, ymax) = ballBox2
            Robot.robot_ball_distance = ball_distance(Robot.neck_pitch, ymax)
            print(f"공으로 다가가는 중: {int(Robot.robot_ball_distance)} cm")
            # 공에 가까이 가는 중에 순간 공이 감지되지 않았다면 일단 기다린다
            if not Robot.is_ball:
                plain_frame_count += 1
                if plain_frame_count > 5:
                    Robot.curr_mission = "FindBall"
                    plain_frame_count = 0
            # 공이 shot 가능한 위치에 있으면 goal을 찾는다
            elif Robot.is_ball and  12 <= Robot.robot_ball_distance <= 15:
                Robot.curr_mission = "ShortCheck"
                plain_frame_count = 0
            # 공이 shot 불가능한 위치에 있으면 공으로 다가간다
            else:
                Robot.curr_mission = "ApproachBall"
                plain_frame_count = 0
        # 3. ShortCheck
        elif Robot.curr_mission == "ShortCheck":
            Robot.shotzone, frame = Camera.shortChecker(img)
            if Robot.shotzone == "!!!Shot!!!":
                Robot.curr_mission = "Shot"
            elif Robot.shotzone == "NoHole":
                Robot.curr_mission == "LongCheck"
                neck_before_find = Robot.neck_pitch
                Motion.neck_pitch = 70
                Motion.neckup(70)
                Motion.wait_unlock()
            else:
                Robot.curr_mission = "ApproachGoal"
                Robot.neck_pitch = neck_before_find
                Motion.neckup(Robot.neck_pitch)
                Motion.wait_unlock()
                clockwise = Robot.shotzone
        # 4. LongCheck
        elif Robot.curr_mission == "LongCheck":
            Robot.shotzone, frame = Camera.longChecker(img)
            if Robot.shotzone == "!!!Shot!!!":
                Robot.curr_mission = "Shot"
            else:
                Robot.curr_mission = "ApproachGoal"
                Robot.neck_pitch = neck_before_find
                Motion.neckup(Robot.neck_pitch)
                Motion.wait_unlock()
                clockwise = Robot.shotzone

            # Robot.is_hole, detected_points = Camera.is_hole(img)
            # if not Robot.is_hole:
            #     Robot.curr_mission = "ApproachGoal"
            #     Robot.neck_pitch = neck_before_find
            #     Motion.neckup(Robot.neck_pitch)
            #     Motion.wait_unlock()
            # else:
            #     if 2*detected_points[0] - 620 > detected_points[1] > (76*detected_points[0] - 25460)/ 61:
            #         Robot.curr_mission = "Shot"
            #     else:
            #         Robot.curr_mission = "ApproachGoal"
        # 4. ApproachGoal
        elif Robot.curr_mission == "ApproachGoal":
            # goal을 찾아 한걸음 움직였으면 공과의 거리를 보정한다
            Robot.curr_mission = "ApproachBall"
        # 5. Shot
        elif Robot.curr_mission == "Shot":
            # shot을 하면 다음 shot을 위해 공을 찾는다
            Robot.curr_mission = "FindBall"
            shot_count += 1
        
        print(f"현재 상태 {Robot.curr_mission}, neck: {Robot.neck_pitch}")


        # show the frame to our screen
        cv2.imshow("Frame", frame)
        if cv2.waitKey(1) == ord("q"):
            break
        # motion
        # 1. FindBall
        if Motion.getRx() and Robot.curr_mission != "ApproachBall":
            pass
        elif Robot.curr_mission == "FindBall":
            Motion.init()
            Motion.wait_unlock()
            Motion.turn("LEFT", 45)
            Motion.wait_unlock()
            time.sleep(2)
            Robot.neck_yaw = 0
        # 2. ApproachBall
        elif Robot.curr_mission == "ApproachBall":
            (xmin, ymin) = ballBox1
            (xmax, ymax) = ballBox2
            xmean = (xmin + xmax) // 2
            ymean = (ymin + ymax) // 2
            # 공에 다가가다가 순간 공이 안 보인 경우
            if not Robot.is_ball:
                pass
            # 공 bounding box가 화면 중앙에 오도록 움직이고 shot 가능할때까지 걸어간다
            else:
                if xmean < 160:
                    if Motion.getRx():
                        Motion.init()
                        Motion.wait_unlock()
                    Motion.turn("LEFT", 20)
                    Motion.wait_unlock()
                    print("TURN LEFT")
                elif xmean > 480:
                    if Motion.getRx():
                        Motion.init()
                        Motion.wait_unlock()
                    Motion.turn("RIGHT", 20)
                    Motion.wait_unlock()
                    print("TURN RIGHT")
                elif ymean < 100 and Robot.neck_pitch < 100:
                    if Motion.getRx():
                        Motion.init()
                        Motion.wait_unlock() 
                    Robot.neck_pitch += 5
                    Motion.neckup(Robot.neck_pitch)
                    Motion.wait_unlock()
                    print("목 조절")
                elif ymean > 280 and Robot.neck_pitch > 35:
                    if Motion.getRx():
                        Motion.init()
                        Motion.wait_unlock()
                    Robot.neck_pitch -= 5
                    Motion.neckup(Robot.neck_pitch)
                    Motion.wait_unlock()
                    print("목 조절")
                elif Robot.robot_ball_distance > 18:
                    Motion.walk()
                    print("WALKING")
                elif Robot.robot_ball_distance > 14:
                    if Motion.getRx():
                        Motion.init()
                        Motion.wait_unlock()
                    Motion.step()
                    Motion.wait_unlock()
                    time.sleep(1)
                elif xmean < 300:
                    if Motion.getRx():
                        Motion.init()
                        Motion.wait_unlock()
                    Motion.turn("LEFT")
                    Motion.wait_unlock()
                    print("TURN LEFT")
                elif xmean > 340:
                    if Motion.getRx():
                        Motion.init()
                        Motion.wait_unlock()
                    Motion.turn("RIGHT")
                    Motion.wait_unlock()
                    print("TURN RIGHT")
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
        # 3. ShortCheck
        elif Robot.curr_mission == 'ShortCheck':
            time.sleep(1)
        # 4. LongCheck
        elif Robot.curr_mission == "LongCheck":
            if Motion.getRx():
                Motion.init()
                Motion.wait_unlock()
            Robot.neck_yaw = -90
            Motion.view(-90)
            time.sleep(1)
        # 4. ApproachGoal
        elif Robot.curr_mission == "ApproachGoal":
            if Motion.getRx():
                Motion.init()
                Motion.wait_unlock()
            Robot.neck_yaw = 0
            Motion.view(0)
            time.sleep(1)
            if clockwise == "Right":
                Motion.circular_orbit(leg_up=False)
                Motion.wait_unlock()
                Motion.turn("RIGHT", 20)
                Motion.wait_unlock()
            else:
                Motion.circular_orbit("Right", False)
                Motion.wait_unlock()
                Motion.turn("LEFT", 20)
                Motion.wait_unlock()
                time.sleep(2)
        # 5. Shot
        elif Robot.curr_mission == "Shot":
            if Motion.getRx():
                Motion.init()
                Motion.wait_unlock()
            Robot.neck_yaw = 0
            Motion.view(0)
            Motion.wait_unlock()
            Robot.neck_pitch = 70
            Motion.neckup(70)
            Motion.wait_unlock()
            Motion.shot()
            Motion.wait_unlock()

        
    cv2.destroyAllWindows()