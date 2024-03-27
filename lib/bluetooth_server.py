from bluedot.btcomm import BluetoothServer
from signal import pause
import time
import picar_4wd as fc
from picar_4wd import utils

fc.start_speed_thread()
grayscale_list = []

dist = 0.0

def data_received(data):
    global grayscale_list
    global dist
    grayscale_list = fc.get_grayscale_list()
    grayscale_str = f'{grayscale_list[0]} {grayscale_list[1]} {grayscale_list[2]}'
    pi_re = utils.pi_read()
    pi_st = "{cpu_temperature} {gpu_temperature}".format(**pi_re)
    car_moving = data[0]
    print(data)
    t1 = time.time()
    if (data[0] == "F"):
      print ("move forward")
      fc.forward(50)
      time.sleep(1)
    elif (data[0] == "B"):
      print ("move backward")
      fc.backward(50)
      time.sleep(1)
    elif (data[0] == "L"):
      print ("move left")
      fc.turn_left(50)
      time.sleep(1)
    elif (data[0] == "R"):
      print ("move right")
      fc.turn_right(50)
      time.sleep(1)
    else:
      fc.stop()

    fc.stop()
    t2 = time.time()
    timeDiff = t2 - t1
    speed = round(fc.speed_val(), 2)
    if (data[0] == "F"  or data[0] == "B"):
     dist += timeDiff*speed
     print ("speed is Distance is ", speed, dist)

    dist = round(dist,2)
    final_str1 = f'{grayscale_str} {pi_st} {car_moving} {speed} {dist} \r'
    print (final_str1)
    s.send(final_str1)

s = BluetoothServer(data_received)
pause()
