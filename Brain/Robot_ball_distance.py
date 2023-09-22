def ball_distance(neck_angle, pixel):
    if neck_angle == 65:
        return 0.000372 * (pixel ** 2) - 0.36 * pixel + 105
    elif neck_angle == 70:
        return 0.000496 * (pixel ** 2) - 0.48 * pixel + 136
    elif neck_angle == 75:
        return 0.000593 * (pixel ** 2) - 0.58 * pixel + 165
    elif neck_angle == 80:
        return 0.000726 * (pixel ** 2) - 0.7 * pixel + 197
    elif neck_angle == 85:
        return 0.000726 * (pixel ** 2) - 0.7 * pixel + 197
    elif neck_angle == 90:
        return 0.00145 * (pixel ** 2) - 1.43 * pixel + 396
    elif neck_angle == 95:
        return 0.00183 * (pixel ** 2) - 1.85 * pixel + 517
    elif neck_angle == 100:
        return 0.00126 * (pixel **2) - 1.29 * pixel + 375
    
if __name__ == "__main__":
    distance = ball_distance(65, 480)
    print(distance)
    distance = ball_distance(80, 480)
    print(distance)
    distance = ball_distance(100, 480)
    print(distance)