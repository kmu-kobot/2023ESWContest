class Robot:
    def __init__(self):
        # mission variables
        self.curr_mission = None # 현재 수행 중인 미션
        self.robot_ball_distance = 0

        # humanoid variables
        self.neck_pitch = 100 # 상하
        self.neck_yaw = 0    # 좌우
        