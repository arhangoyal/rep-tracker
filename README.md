# REP TRACKER
- CV Project that uses Mediapipe for Pose Detection.
- Front end (mobile app) implemented using Flutter and SQLite backend to track reps during workouts.
- Workouts implemented - PushUps and Squats
- Pose Detection implemented on RPi using Python
- Mobile App communicates with RPi via Bluetooth. The RPi is the bluetooth server.

# Code
- lib/ - Contains Flutter and SQLite code
- MLPoseDetector/ - Contains bluetooth server that uses mediapipe for Pose Detection

# Installation 
## For Flutter Code
- Connect your Android phone to the IDE (VS Code) and run the code in the lib/ directory with the pubspec.yaml that has been provided here

## For MLPoseDetector
- On Raspberry Pi, install the dependencies - openCV, numpy, bluedot, mediapipe
- Once dependecies are installed, place the bluetoothserver.py and DetectPose.py in same path
- Enter 'python bluetoothserver.py' to run the program
