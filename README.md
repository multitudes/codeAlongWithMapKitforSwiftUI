# Code Along Project With MapKit for SwiftUI

This is a code along project, the main branch has the starter project in Xcode, which is mostly empty. It should just only display a map of your region.  
You can check the completedProject branch of the project for the finished version.

# lets start

Xcode by default will show the map of the region you are in when building and showing the preview in the simulator. This is the standard behaviour when no parameters are passed in the map initializer.  

We are in the Normandie, in Rouen, and we will start a weekend bike trip going surfing and visiting the coast.  
for convenience we add our start location as a static variable in this extension. Just a clean way to store our first variable.

We use now the map builder closure to put this location on the map.
```swift
extension CLLocationCoordinate2D {
    static var start = CLLocationCoordinate2D(latitude: 49.44625973148958, longitude: 1.0889092507665954)
}

struct ContentView: View {
    var body: some View {
        Map {
            Marker("Start", coordinate: .start)
        }
    }
}

```

The marker is ok but perhaps a bit boring. We can do better with annotations! replace the marker with this:

```swift
Annotation("Start",
  coordinate: .start,
  anchor: .bottom
){
Image(systemName: "flag")
 .padding(4)
 .foregroundStyle(.white)
 .background(Color.indigo)
 .cornerRadius(4)
}
