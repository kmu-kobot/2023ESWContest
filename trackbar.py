import cv2
import numpy as np

def empty_callback(x):
    pass

# VideoCapture 객체를 생성하여 비디오 파일을 엽니다.
cap = cv2.VideoCapture(0)  # 비디오 파일의 경로를 지정해주세요

# 창을 생성하여 트랙바를 추가합니다.
cv2.namedWindow('Video')

# 하한(H, L, S) 값의 초기 설정을 지정합니다.
h_min, l_min, s_min = 0, 0, 0
h_max, l_max, s_max = 179, 255, 255

cv2.createTrackbar('Hue Min', 'Video', h_min, 179, empty_callback)
cv2.createTrackbar('Lightness Min', 'Video', l_min, 255, empty_callback)
cv2.createTrackbar('Saturation Min', 'Video', s_min, 255, empty_callback)
cv2.createTrackbar('Hue Max', 'Video', h_max, 179, empty_callback)
cv2.createTrackbar('Lightness Max', 'Video', l_max, 255, empty_callback)
cv2.createTrackbar('Saturation Max', 'Video', s_max, 255, empty_callback)

while True:
    ret, frame = cap.read()
    if not ret:
        break

    # 트랙바에서 현재 설정된 값들을 읽어옵니다.
    h_min = cv2.getTrackbarPos('Hue Min', 'Video')
    l_min = cv2.getTrackbarPos('Lightness Min', 'Video')
    s_min = cv2.getTrackbarPos('Saturation Min', 'Video')
    h_max = cv2.getTrackbarPos('Hue Max', 'Video')
    l_max = cv2.getTrackbarPos('Lightness Max', 'Video')
    s_max = cv2.getTrackbarPos('Saturation Max', 'Video')

    # 영상을 HLS 색상 공간으로 변환합니다.
    hls = cv2.cvtColor(frame, cv2.COLOR_BGR2HLS)

    # 범위 설정을 통해 마스크를 생성합니다.
    lower_bound = np.array([h_min, l_min, s_min])
    upper_bound = np.array([h_max, l_max, s_max])
    mask = cv2.inRange(hls, lower_bound, upper_bound)

    # 마스크를 사용하여 영상을 필터링합니다.
    filtered_frame = cv2.bitwise_and(frame, frame, mask=mask)

    # 화면에 영상을 표시합니다.
    cv2.imshow('Video', filtered_frame)

    if cv2.waitKey(1) & 0xFF == 27:  # 'Esc' 키를 누르면 종료합니다.
        break

cap.release()
cv2.destroyAllWindows()
