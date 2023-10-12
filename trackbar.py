import cv2
import numpy as np

def empty_callback(x):
    pass

cap = cv2.VideoCapture(0)

cv2.namedWindow('Video')

h_min, s_min, v_min = 0, 0, 0
h_max, s_max, v_max = 179, 255, 255

cv2.createTrackbar('Hue Min', 'Video', h_min, 179, empty_callback)
cv2.createTrackbar('Saturation Min', 'Video', s_min, 255, empty_callback)
cv2.createTrackbar('Value Min', 'Video', v_min, 255, empty_callback)
cv2.createTrackbar('Hue Max', 'Video', h_max, 179, empty_callback)
cv2.createTrackbar('Saturation Max', 'Video', s_max, 255, empty_callback)
cv2.createTrackbar('Value Max', 'Video', v_max, 255, empty_callback)

while True:
    ret, frame = cap.read()
    if not ret:
        break

    h_min = cv2.getTrackbarPos('Hue Min', 'Video')
    s_min = cv2.getTrackbarPos('Saturation Min', 'Video')
    v_min = cv2.getTrackbarPos('Value Min', 'Video')
    h_max = cv2.getTrackbarPos('Hue Max', 'Video')
    s_max = cv2.getTrackbarPos('Saturation Max', 'Video')
    v_max = cv2.getTrackbarPos('Value Max', 'Video')

    hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV)

    lower_bound = np.array([h_min, s_min, v_min])
    upper_bound = np.array([h_max, s_max, v_max])
    mask = cv2.inRange(hsv, lower_bound, upper_bound)

    filtered_frame = cv2.bitwise_and(frame, frame, mask=mask)

    cv2.imshow('Frame', filtered_frame)

    if cv2.waitKey(1) & 0xFF == 27:
        break

cap.release()
cv2.destroyAllWindows()
