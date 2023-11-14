import cv2

def mouse_callback(event, x, y, flags, param):
    if event == cv2.EVENT_LBUTTONDOWN:
        print(f'({x}, {y})')

cap = cv2.VideoCapture(0)

cv2.namedWindow('frame')
cv2.setMouseCallback('frame', mouse_callback)

while True:
    ret, frame = cap.read()

    if not ret:
        break

    cv2.imshow('frame', frame)

    key = cv2.waitKey(1)
    if key == 27:
        break

cap.release()
cv2.destroyAllWindows()
