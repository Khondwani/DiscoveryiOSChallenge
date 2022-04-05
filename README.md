# Discovery iOS App Challenge

In this section the app really speaks for its self. 
I built a single view application that contains different views which are as follows:
- Bluetooth view that shows all the bluetooth buddies around you 
  - In this view i added an extra set of calculations with regards to finding the approximate distance from the device searching for a peripheral device and this was really interesting. Due to it being my first time working with bluetooth devices and RSSI. I utilised the RSSI to calculate the approximated distance. This is the link i utilised as part of my research in how to get distance from RSSI [How to get distance from RSSI](https://iotandelectronics.wordpress.com/2016/10/07/how-to-calculate-distance-from-the-rssi-value-of-the-ble-beacon/) 
  
- Tableview which have a list of the heat-map html pages.
  - In this section i wanted to at-least have a place where i can serve the generated heat-maps and i decided to create a view on the swift application.
  - I utilised the express server and the python scripts i created and deployed to an EC2 instance and made an endpoint that would fetch the generated heat-maps and then show these heat-maps in the Webkit view in the next point.
- A webkit view that was used to load the heat-maps. 


The application is on TestFlight on the App store for the various users to experience. Basically removing the need for them to build the application on their end.


## [Back To Home](https://github.com/Khondwani/DiscoveryChallenges)
## [Go To Challenge 1 and 2](https://github.com/Khondwani/Challenge1-2)
