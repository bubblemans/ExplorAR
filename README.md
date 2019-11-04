# ExplorAR

> Effortless navigation through intuitive AR.

View shops' information on the street using AR technology including types of shops, discount information, and so on. We foresee this idea can replace Yelp or be integrated into Yelp or Google Map.

## Demo
For the Demo, we use accessable logo to detect.


![Image of demo1](https://github.com/bubblemans/ExplorAR/blob/master/image/demoAR.png)![Image of demo2](https://github.com/bubblemans/ExplorAR/blob/master/image/demo2.png)

## Technical Approach

__Technologies used__ : [Google Vision API (logo detection)](https://cloud.google.com/vision/docs/detecting-logos), [Google Places API](https://developers.google.com/places/web-service/search), [Apple ARKit3](https://developer.apple.com/augmented-reality/arkit/), [Apple SceneKit](https://developer.apple.com/documentation/scenekit).

__Approach__ : We use some of the source code from Apple's official documentation https://developer.apple.com/documentation/vision/recognizing_objects_in_live_capture.
We first feed a frame from the camera to the Vision API and obtain the label and the location of any logo it sees. Then, we obtain ratings and other useful information about the restaurant that was detected by Vision API using Places API. Finally, we display the information in the Augmented Reality environment using ARKit3. The information will be overlayed over (or close to) the actual location of the restaurant and it will remain temporally stable. We currently have a working proof of concept--including detection and feature display on AR environment-- without any heavy UI/UX implementations.

## Challenge

* Race condition between __AVCapture.session__ and __SceneKit's session__ which makes the app not real-time(but logo detection is real-time); however, eventually, we did not use run __AVCapture.session__.
* __CurrentFrame__ from __SceneKit__ gives low quality of image, and __AVCapture__ gives good quality, but we need __SceneKit__.

## Future Improvements

* __Improve the UI/UX__ beyond what the time constraints in CalHacks allowed. 
* Allow the user to __choose what features should be displayed__ in the AR scene; every individual has different priorities, so this feature has high priority.
