from Actuator.Motion import Motion

import time
# import cv2

# Robot 클래스 import

if __name__ == "__main__":
    # ROBOT 객체 생성
    # robot = Robot()
    # 미션 수행 함수 실행
    # robot.line_tracing_Final()
    
    Motion = Motion()
    
    start = time.time()
    end = start
    while end-start < 1:
        end = time.time()
        Motion.TX_data_py3(11)
    while end-start < 3:
        end = time.time()
        Motion.TX_data_py3(13)
    while end-start < 5:
        end = time.time()
        Motion.TX_data_py3(11)
    Motion.TX_data_py3(26)
        
    # main while loop
    # ceremony 완료할 때까지 반복