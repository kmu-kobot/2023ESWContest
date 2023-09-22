def ball_distance(neck_angle, pixel):
    if neck_angle == 65:
        return 0.000372 * (pixel ** 2) - 0.36 * pixel + 105
    elif neck_angle == 80:
        return (0.0466 * pixel) ** 2 - 9.59 * pixel + 675
    elif neck_angle == 100:
        return 0.00126 * (pixel **2) - 1.29 * pixel + 375
    
if __name__ == "__main__":
    distance = ball_distance(65, 480)
    distance = ball_distance(100, 480)
    print(distance)