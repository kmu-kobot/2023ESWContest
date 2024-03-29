class Robot:
    def __init__(self):
        # mission variables
        self.curr_mission = "ApproachBall" # 현재 수행 중인 미션
        self.robot_ball_distance = 1000
        self.long_shot = True
        self.turn_angle = 5

        # humanoid variables
        self.neck_pitch = 50 # 상하
        self.neck_yaw = 0    # 좌우
        
        # object detection boolean variables
        self.is_hole = False
        self.is_ball = False
        self.is_bunker = False
        self.is_arrow = False
        
        self.shotzone = False