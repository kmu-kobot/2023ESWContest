# par3 기울기 없을 때
# 목표: 홀인원

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
shot_direction = "Left"
shot_power = 8
shot_roi = False

if __name__ == "__main__":
    
    Robot = Robot()
    Motion = Motion()
    Camera = Camera()
    
    Motion.initial()
    Motion.init(True)
    Motion.neckup(50)
    neck_before_find = 50
    
    time.sleep(1)

    # 미션 수행 함수 실행
    print("Loop 시작 :)")
    while True:
        frame = Camera.get_image()

        # image process
        img = frame.copy()
        Robot.is_ball, ballBox1, ballBox2 = Camera.hsvDetect(img)
        # Robot.is_bunker, bunkerL, bunkerR = Camera.is_bunker(img)
        # Robot.shotzone, hole_frame = Camera.shotzoneChecker(img)

        if Robot.is_ball:
            plain_frame_count = 0
            cv2.rectangle(frame, ballBox1, ballBox2, (0,0,255), 2)
        # if Robot.is_bunker:
        #     cv2.circle(frame, (bunkerL, 5, (255,255,255), -1))
        #     cv2.circle(frame, (bunkerR, 5, (255,255,255), -1))

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
            elif 9.5 <= Robot.robot_ball_distance <= 11 and 330 < (xmin+xmax) // 2 < 370:
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
                if shot_count == 1 and shot_roi:
                    shot_roi = False
                Robot.long_shot = False
                Robot.curr_mission = "Shot"
                shot_direction = "Left"
                shot_power = 11
            elif Robot.shotzone == "!!!R-Shot!!!":
                if shot_count == 1 and shot_roi:
                    shot_roi = False
                Robot.long_shot = False
                Robot.curr_mission = "Shot"
                shot_direction = "Right"
                shot_power = 2
            elif Robot.shotzone == "NoHole" and shot_count == 1 and shot_roi:
                shot_roi = False
                neck_before_find = Robot.neck_pitch
                Motion.neckup(80)
                time.sleep(1)
                shortchecker = Camera.get_image()
                Robot.shotzone, shortchecker = Camera.shortChecker_R(shortchecker)
                cv2.imshow("IMG_ROI", shortchecker)
                Robot.curr_mission = "ApproachBall"
                if Robot.shotzone == "L-turn":
                    Motion.circular_orbit("Left", False)
                elif Robot.shotzone == "LL-turn":
                    Motion.circular_orbit("Left", False)
                    Motion.circular_orbit("Left", False)
                elif Robot.shotzone == "LLL-turn":
                    Motion.circular_orbit("Left", False)
                    Motion.circular_orbit("Left", False)
                    Motion.step("BACK")
                    Motion.step("BACK")
                    Motion.circular_orbit("Left", False)
                elif Robot.shotzone == "LLLL-turn":
                    Motion.circular_orbit("Left", False)
                    Motion.circular_orbit("Left", False)
                    Motion.crab("LEFT")
                    Motion.crab("LEFT")
                    Motion.circular_orbit("Left", False)
                    Motion.circular_orbit("Left", False)
                Motion.neckup(neck_before_find)
                time.sleep(0.5)
            elif Robot.shotzone == "NoHole":
                Robot.curr_mission = "LongCheck"
                neck_before_find = Robot.neck_pitch
                Motion.neck_pitch = 70
                Motion.neckup(70)
            elif Robot.shotzone == "R-turn-20":
                if shot_count == 1 and shot_roi:
                    shot_roi = False
                Robot.curr_mission = "ApproachGoal"
                clockwise = "Left"
                Robot.turn_angle = 200 # TODO Short Check turn angle 결정
            elif Robot.shotzone == "L-turn":
                if shot_count == 1 and shot_roi:
                    shot_roi = False
                Robot.curr_mission = "ApproachGoal"
                clockwise = "Left"
                Robot.turn_angle = 100 # TODO Short Check turn angle 결정
            else: # hole in
                Robot.curr_mission = "Ceremony"            
        # 4. LongCheck
        elif Robot.curr_mission == "LongCheck":
            if shot_count == 0:
                Robot.shotzone, frame, shot_power = Camera.longChecker_par3_first_shot(img)
            else:
                Robot.shotzone, frame, shot_power = Camera.longChecker(img)
            if Robot.shotzone == "!!!Shot!!!":
                if shot_power < 10:
                    Robot.long_shot = False
                else:
                    Robot.long_shot = True
                Robot.curr_mission = "Shot"
                shot_direction = "Left"
            else:
                Robot.curr_mission = "ApproachGoal"
                Robot.neck_pitch = neck_before_find
                Motion.neckup(Robot.neck_pitch)
                if Robot.shotzone == "R-turn":
                    clockwise = "Right"
                    Robot.turn_angle = 100
                elif Robot.shotzone == "R-turn-20":
                    clockwise = "Right"
                    Robot.turn_angle = 20
                elif Robot.shotzone == "R-turn-10":
                    clockwise = "Right"
                    Robot.turn_angle = 10
                elif Robot.shotzone == "R-turn-5":
                    clockwise = "Right"
                    Robot.turn_angle = 5
                elif Robot.shotzone == "L-turn":
                    clockwise = "Left"
                    Robot.turn_angle = 100
                elif Robot.shotzone == "L-turn-20":
                    clockwise = "Left"
                    Robot.turn_angle = 20
                elif Robot.shotzone == "L-turn-10":
                    clockwise = "Left"
                    Robot.turn_angle = 10
                else:
                    clockwise = "Left"
                    Robot.turn_angle = 5
                    
        # 5. ApproachGoal
        elif Robot.curr_mission == "ApproachGoal":
            # goal을 찾아 한걸음 움직였으면 공과의 거리를 보정한다
            Robot.curr_mission = "ApproachBall"
        # 6. Shot
        elif Robot.curr_mission == "Shot":
            shot_direction = "Left"
            # shot을 하면 다음 shot을 위해 공을 찾는다
            Robot.curr_mission = "ApproachBall"
            shot_count += 1
            if shot_count == 1:
                shot_roi = True
        # 7. Ceremony
        else:
            print("미션 종료")
            break

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
            if shot_count == 0 and Robot.neck_pitch != 70:
                Robot.neck_pitch = 70
                Motion.neckup(70)
            else:
                Motion.init()
                Motion.turn("LEFT", 45)
                time.sleep(1)
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
                if xmean < 190:
                    if Motion.getRx():
                        Motion.init()
                    Motion.turn("LEFT", 20)
                elif xmean > 510:
                    if Motion.getRx():
                        Motion.init()
                    Motion.turn("RIGHT", 20)
                elif ymean < 100 and Robot.neck_pitch < 100:
                    if Motion.getRx():
                        Motion.init()
                    Robot.neck_pitch += 5
                    Motion.neckup(Robot.neck_pitch)
                elif ymean > 280 and Robot.neck_pitch > 35:
                    if Motion.getRx():
                        Motion.init()
                    Robot.neck_pitch -= 5
                    Motion.neckup(Robot.neck_pitch)
                elif Robot.robot_ball_distance < 9.5:
                    if Motion.getRx():
                        Motion.init()
                    Motion.step("BACK")
                elif Robot.robot_ball_distance > 18:
                    Motion.walk()
                elif Robot.robot_ball_distance > 13:
                    if Motion.getRx():
                        Motion.init()
                    Motion.step("FRONT", "big")
                elif Robot.robot_ball_distance > 11:
                    if Motion.getRx():
                        Motion.init()
                    Motion.step("FRONT", "small")
                elif xmean < 340:
                    if Motion.getRx():
                        Motion.init()
                    Motion.crab("LEFT")
                    time.sleep(0.5)
                elif xmean > 360:
                    if Motion.getRx():
                        Motion.init()
                    Motion.crab("RIGHT")
                else:
                    Motion.init()
                Robot.neck_yaw = 0
        # 3. ShortCheck
        elif Robot.curr_mission == "ShortCheck":
            if Motion.getRx():
                Motion.init()
            Robot.neck_pitch = 45
            Motion.neckup(45)                
            time.sleep(0.7)
        # 4. LongCheck
        elif Robot.curr_mission == "LongCheck":
            if Motion.getRx():
                Motion.init()
            Robot.neck_yaw = -90
            Motion.view(-90)
            time.sleep(1)
        # 5. ApproachGoal
        elif Robot.curr_mission == "ApproachGoal":
            if Motion.getRx():
                Motion.init()
            Robot.neck_yaw = 0
            Motion.view(0)
            time.sleep(1)
            # hole이 공이 움직일 궤도 왼쪽에 있다면 반시계 방향으로 회전한다
            if clockwise == "Left":
                if Robot.turn_angle == 200:
                    Motion.circular_orbit("Left", False)
                    Motion.circular_orbit("Left", False)
                    Motion.step("BACK")
                    Motion.step("BACK")
                    Motion.circular_orbit("Left", False)
                elif Robot.turn_angle == 100:
                    Motion.circular_orbit("Left", False)
                else:
                    Motion.circular_orbit_small("Left", Robot.turn_angle)
            else:
                if Robot.turn_angle == 100:
                    Motion.circular_orbit("Right", True)
                else:
                    Motion.circular_orbit_small("Right", Robot.turn_angle)
            time.sleep(1) # 동작 안정성을 위한 대기
        # 6. Shot
        elif Robot.curr_mission == "Shot":
            if Motion.getRx():
                Motion.init()
            Robot.neck_yaw = 0
            Motion.view(0)
            if shot_direction == "Left":
                if shot_count == 0:
                    shot_power = 15 # TODO 첫 샷 세기 수정
                Motion.shot("LEFT", shot_power)
            else:
                Motion.shot("RIGHT", shot_power)
            if Robot.long_shot:
                if shot_power < 14:
                    Robot.neck_pitch = 60
                elif shot_power < 19:
                    Robot.neck_pitch = 70
                else:
                    Robot.neck_pitch = 80
                Motion.neckup(80)
                Motion.turn("LEFT", 45)
                Motion.turn("LEFT", 45)
            else:
                if shot_direction == "Left":
                    Motion.turn("LEFT", 20)
                else:
                    Motion.turn("RIGHT", 20)
        # 7. Ceremony
        else:
            if Motion.getRx():
                Motion.init()
            Motion.ceremony()

        
    cv2.destroyAllWindows()
