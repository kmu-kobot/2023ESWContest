def ball_distance(neck_angle, pixel):
    if neck_angle == 35:
        return 4.41E-05 * (pixel ** 2) - 0.0848 * pixel + 27.9
    elif neck_angle == 40:
        return 5.48E-05 * (pixel ** 2) - 0.0968 * pixel + 33
    elif neck_angle == 45:
        return 8.33E-05 * (pixel ** 2) - 0.117 * pixel + 39
    elif neck_angle == 50:
        return 1.31E-04 * (pixel ** 2) - 0.158 * pixel + 51.7
    elif neck_angle == 55:
        return 1.86E-04 * (pixel ** 2) - 0.2 * pixel + 62
    elif neck_angle == 60:
        return 2.4E-04 * (pixel ** 2) - 0.245 * pixel + 73.4
    elif neck_angle == 65:
        return 3.46E-04 * (pixel ** 2) - 0.327 * pixel + 91.5
    elif neck_angle == 70:
        return 5.41E-04 * (pixel ** 2) - 0.482 * pixel + 127
    elif neck_angle == 75:
        return 1.13E-08 * (pixel ** 4) - 1.5E-05 * (pixel ** 3) + 7.55E-03 * (pixel ** 2) - 1.88 * pixel + 236
    elif neck_angle == 80:
        return 1.37E-03 * (pixel ** 2) - 1.1 * pixel + 247
    elif neck_angle == 85:
        return 1.63E-03 * (pixel ** 2) - 1.37 * pixel + 316
    elif neck_angle == 90:
        return 2.04E-03 * (pixel ** 2) - 1.75 * pixel + 411
    elif neck_angle == 95:
        return 2.46E-03 * (pixel ** 2) - 2.16 * pixel + 518
    elif neck_angle == 100:
        return 3.24E-03 * (pixel ** 2) - 3.02 * pixel + 756
    
if __name__ == "__main__":
    distance = ball_distance(65, 480)
    print(distance)
    distance = ball_distance(80, 480)
    print(distance)
    distance = ball_distance(100, 480)
    print(distance)