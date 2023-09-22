from Actuator.Motion import Motion
from Sensor.Camera import Camera
from Brain.Robot import Robot
from Brain.Robot_ball_distance import ball_distance

import cv2
import numpy as np
import time

CONFIDENCE_THRESHOLD = 0.8
GREEN = (0, 255, 0)


if __name__ == "__main__":
    
    Robot = Robot()
    Motion = Motion()
    Camera = Camera()
    
    direction = "CENTER"

    # 시리얼 연결 확인 동작
    Motion.initial()
    # 초기 자세
    Motion.init()

    # 미션 수행 함수 실행
    while True:
        xmin = ymin = xmax = ymax = False

        frame = Camera.get_image()

        # run the YOLO model on the frame
        detections = Camera.yoloDetect(frame.copy())

        # loop over the detections
        for data in detections.boxes.data.tolist():
            # extract the confidence (i.e., probability) associated with the detection
            confidence = data[4]

            # filter out weak detections by ensuring the
            # confidence is greater than the minimum confidence
            if float(confidence) < CONFIDENCE_THRESHOLD:
                continue

            # if the confidence is greater than the minimum confidence,
            # draw the bounding box on the frame
            xmin, ymin, xmax, ymax = int(data[0]), int(data[1]), int(data[2]), int(data[3])
            cv2.rectangle(frame, (xmin, ymin), (xmax, ymax), GREEN, 2)

        # 공 bounding box에 따라 목 각도 조절
        # 반복 한 번에 동작 하나만 호출함
        if ymin == False:    # 공 bounding box가 없다면
            pass
        elif ymin < 100:     # 공 bounding box가 위에 있다면 고개 올리기
            if Robot.neck_pitch < 95:
                Motion.neckup()
                Robot.neck_pitch += 5
            else:
                Motion.init()
                Robot.neck_pitch = 100
        elif ymin > 350:     # 공 bounding box가 아래에 있다면 고개 내리기
            if 65 < Robot.neck_pitch < 80:
                Motion.neck65()
                Robot.neck_pitch = 65
            elif Robot.neck_pitch > 80:
                Motion.neck80()
                Robot.neck_pitch = 80
                
        Robot.robot_ball_distance = ball_distance(Robot.neck_pitch)
        print(f"로봇 목 각도:{Robot.neck_pitch} | 로봇과공:{Robot.robot_ball_distance}")

        # show the frame to our screen
        cv2.imshow("Frame", frame)
        if cv2.waitKey(1600) == ord("q"):
            break
        
    cv2.destroyAllWindows()