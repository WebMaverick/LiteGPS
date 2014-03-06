# LiteGPS

Simple iOS prototype app to track and record 3 dimensional trips

## Views

The main view of the app begins tracking the trip upon pressing start.  Statistics displayed include:

- Current latitude
- Current longitude
- Current altitude
- Current speed
- Max speed this trip
- Distance from origin
- Distance travelled along your path
- Elapsed time
- Time spent idle, i.e. not moving
- A progress bar indicates percentage of time moving, useful if you want to use on a car trip to see how much time was spent at lights or in stop-and-go traffic

## Data

GPS Data is saved to Core Data and associated with the trip

### Todo

To complete the implementation the following items should be addressed

- Retrieve data from Core Data
- Display map of trip
- Display meta-statistics regarding longest trip, fastest speed, etc
