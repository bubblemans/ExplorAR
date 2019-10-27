# ExplorAR

> Effortless navigation through intuitive AR.

## Purpose

Imagine you are in downtown, looking for a place to eat in. 

You open Google Maps or Yelp.

<!-- image of restaurants on a map in Yelp -->

Too many places to pick from! Now you go into list view to check out the ratings.

<!-- list view of restaurants in yelp/Google -->

Finally! You picked a place....but where is that place? You enter the map view again and find it.

Needless switching between one view and the other, but why? What if we could achieve this effortlessly in an intuitive Augmented Reality, all from an iOS app?

## Demo

<!-- image of app detecting restaurants and displaying rating -->

<!-- video showing temporal stability of displayed information -->

## Technical Approach

__Technologies used__ : [Google Vision API (logo detection)](https://cloud.google.com/vision/docs/detecting-logos), [Google Places API](https://developers.google.com/places/web-service/search), [Apple ARKit3](https://developer.apple.com/augmented-reality/arkit/), [Apple SceneKit](https://developer.apple.com/documentation/scenekit).

__Approach__ : We first feed a frame from the camera to the Vision API and obtain the label and the location of any logos it sees. Then, we obtain ratings and other useful about the restaurant that was detected by Vision API using Places API. Finally, we display the information in the Augmented Reality environment using ARKit3. The information will be overlayed over (or close to) the actual location of the restaurant and it will remain temporally stable. We currently have a working proof of concept--including detection and feature display on AR environment-- without any heavy UI/UX implementations.

## Future Improvements

* __Improve the UI/UX__ beyond what the time constraints in CalHacks allowed. 
* Allow the user to __choose what features should be displayed__ in the AR scene; every individual has different priorities, so this feature has high priority.
* Try to make the app lightweight so we can __increase the rate for prediction/display__ from ~1 times a second to ~10 times a second.
