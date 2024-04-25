from bluedot.btcomm import BluetoothServer
from signal import pause
import cv2
import mediapipe as mp
import numpy as np
import DetectPose as pm
import time

def data_received(data):
    print ("Data received from client - {}".format(data))
    returnedData = data.split(" ")
    exercise = returnedData[0]
    target = int(returnedData[1])
    date = returnedData[2].strip()
    t1 = time.time()
    if (exercise[0] == "P"):
      cap = cv2.VideoCapture(0)
      detector = pm.detectPose()
      count = 0
      direction = 0
      form = 0
      feedback = "Wrong Form"

      while cap.isOpened():
        ret, img = cap.read() #640 x 480
        width  = cap.get(3)  # float `width`
        height = cap.get(4)  # float `height`
    
        img = detector.findPose(img, False)
        lmList = detector.findPosition(img, False)
        if len(lmList) != 0:
          elbow = detector.findAngle(img, 11, 13, 15)
          shoulder = detector.findAngle(img, 13, 11, 23)
          hip = detector.findAngle(img, 11, 23,25)
        
          if elbow > 160 and shoulder > 40 and hip > 160:
            form = 1
    
          if form == 1:
            if (elbow > 160 and shoulder > 40 and hip > 160):
              feedback = "Up"
              if direction == 0:
                direction = 1

            if (elbow <=110 and hip > 130 and feedback == "Up"):
                feedback = "Down"
                if direction == 1:
                  count += 1
                  direction = 0
                  
        
          if form == 1:
            cv2.rectangle(img, (105,380), (205, 480), (0,255,0),cv2.FILLED)
            cv2.putText(img, str(int(target)), (125, 455),cv2.FONT_HERSHEY_PLAIN, 5,
                    (255, 0, 0), 5) 
            cv2.putText(img, "TARGET", (105, 470), cv2.FONT_HERSHEY_PLAIN, 1,
                    (0, 0, 0), 2) 

            cv2.rectangle(img, (0, 380), (100, 480), (0, 255, 0), cv2.FILLED)
            cv2.putText(img, str(int(count)), (25, 455), cv2.FONT_HERSHEY_PLAIN, 5,
                    (255, 0, 0), 5)
            cv2.putText(img, "ACTUAL", (0, 470), cv2.FONT_HERSHEY_PLAIN, 1,
                    (0, 0, 0), 2)            
            remainder = target - count
            cv2.rectangle(img, (210, 380), (310, 480), (0, 0, 255), cv2.FILLED)
            cv2.putText(img, str(int(remainder)), (225, 455), cv2.FONT_HERSHEY_PLAIN, 5,
                    (255, 0, 0), 5)
            cv2.putText(img, "REMAINING", (210, 470), cv2.FONT_HERSHEY_PLAIN, 1,
                    (0, 0, 0), 1) 

          if (feedback == "Wrong Form"):
            cv2.rectangle(img, (440, 0), (640, 40), (0, 0, 255), cv2.FILLED)
            cv2.putText(img, feedback, (440, 40 ), cv2.FONT_HERSHEY_PLAIN, 2,
                    (0, 0, 0), 2)
          else:
             cv2.rectangle(img, (560, 0), (640, 40), (0, 255, 0), cv2.FILLED)
             cv2.putText(img, feedback, (560, 40 ), cv2.FONT_HERSHEY_PLAIN, 2,
                    (0, 0, 0), 2)           

        cv2.imshow('Pushup counter', img)

        if (count == target and feedback == "Up"):
          break
        if cv2.waitKey(10) & 0xFF == ord('q'):
          break
        
      cap.release()
      cv2.destroyAllWindows()
      success = "FAIL"
      t2 = time.time()
      timeDiff = round((t2 - t1),2)
      if (count == target):
        success = "PASS"
      final_str1 = f'{date} {exercise} {timeDiff} {target} {count} {success} \r'
      print ("Data sent to the client: ", final_str1)
      s.send(final_str1)
    elif (exercise[0] == "S"):
      cap = cv2.VideoCapture(0)
      detector = pm.detectPose()
      count = 0
      direction = 0
      form = 0
      feedback = "Wrong Form"

      while cap.isOpened():
        ret, img = cap.read() #640 x 480
        width  = cap.get(3)  # float `width`
        height = cap.get(4)  # float `height`
    
        img = detector.findPose(img, False)
        lmList = detector.findPosition(img, False)
        if len(lmList) != 0:
          elbow = detector.findAngle(img, 11, 13, 15)
          knee = detector.findAngle(img, 23, 25, 27)
          hip = detector.findAngle(img, 11, 23,25)
        
          if knee > 160 and elbow > 150 and hip > 150:
            form = 1
    
          if form == 1:
            if (knee > 160):
              feedback = "Up"
              if direction == 0:
                direction = 1
                    
            if (knee <= 90 and feedback == "Up"):
                feedback = "Down"
                if direction == 1:
                  count += 1
                  direction = 0

        
          if form == 1:
            cv2.rectangle(img, (105,380), (205, 480), (0,255,0),cv2.FILLED)
            cv2.putText(img, str(int(target)), (125, 455),cv2.FONT_HERSHEY_PLAIN, 5,
                    (255, 0, 0), 5) 
            cv2.putText(img, "TARGET", (105, 470), cv2.FONT_HERSHEY_PLAIN, 1,
                    (0, 0, 0), 2) 


            cv2.rectangle(img, (0, 380), (100, 480), (0, 255, 0), cv2.FILLED)
            cv2.putText(img, str(int(count)), (25, 455), cv2.FONT_HERSHEY_PLAIN, 5,
                    (255, 0, 0), 5)
            cv2.putText(img, "ACTUAL", (0, 470), cv2.FONT_HERSHEY_PLAIN, 1,
                    (0, 0, 0), 2)            
            remainder = target - count
            cv2.rectangle(img, (210, 380), (310, 480), (0, 0, 255), cv2.FILLED)
            cv2.putText(img, str(int(remainder)), (225, 455), cv2.FONT_HERSHEY_PLAIN, 5,
                    (255, 0, 0), 5)
            cv2.putText(img, "REMAINING", (210, 470), cv2.FONT_HERSHEY_PLAIN, 1,
                    (0, 0, 0), 1) 


          if (feedback == "Wrong Form"):
            cv2.rectangle(img, (440, 0), (640, 40), (0, 0, 255), cv2.FILLED)
            cv2.putText(img, feedback, (440, 40 ), cv2.FONT_HERSHEY_PLAIN, 2,
                    (0, 0, 0), 2)
          else:
             cv2.rectangle(img, (560, 0), (640, 40), (0, 255, 0), cv2.FILLED)
             cv2.putText(img, feedback, (560, 40 ), cv2.FONT_HERSHEY_PLAIN, 2,
                    (0, 0, 0), 2)           

        
        cv2.imshow('Squat counter', img)

        if (count == target and feedback == "Up"):
          break
        if cv2.waitKey(10) & 0xFF == ord('q'):
          break
        
      cap.release()
      cv2.destroyAllWindows()
      success = "FAIL"
      t2 = time.time()
      timeDiff = round((t2 - t1),2)
      if (count == target):
        success = "PASS"
      final_str1 = f'{date} {exercise} {timeDiff} {target} {count} {success} \r'
      print ("Data sent to the client: ", final_str1)
      s.send(final_str1)


print ("Starting prog")
s = BluetoothServer(data_received)
pause()
