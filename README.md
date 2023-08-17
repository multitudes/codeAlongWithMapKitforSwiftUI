# Code Along Project With MapKit for SwiftUI

This is a code along project, the main branch has the starter project in Xcode, which is mostly empty. It should just only display a map of your region.  
You can check the completedProject branch of the project for the finished version.

# Let's start

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
```

We can use the  .annotationTitles(.hidden) modifier to hide the title of the annotation if we wish.  Also, we can choose different kind of map styles.  
I like `.mapStyle(.standard(elevation: .realistic))`

## Add buttons

For the buttons I would like to use a translucent bar at the bottom of the full screen map. I will use a `safeareainset` with my buttons inside. The buttons will allow me to display a search for cafes and beaches.  

lets make a new swiftUI file, call it MapButtonsView and add this code in its body 

### the buttons
```swift
        HStack {
            Button {
                search(for: "cafes")
            } label: {
                Label ("Cafes", systemImage: "cup.and.saucer.fill")
            }
            .buttonStyle(.borderedProminent)
            
            Button {
                search(for: "beach")
            } label: {
                Label ("Beaches", systemImage: "beach.umbrella")
            }
            .buttonStyle(.borderedProminent)
        }
        .labelStyle (.iconOnly)

```  

Pressing the button will trigger the search. The results will be stored in a searchResults variable. It will be a binding because we will pass the results to our parent view...

Here I will store my results:
```swift
    @Binding var searchResults: [MKMapItem]
``` 
Here is the search function to be added in the struct as well. 
```
    func search(for query: String) {
        let request = MKLocalSearch.Request ()
        request.naturalLanguageQuery = query
        request.resultTypes = .pointOfInterest
        request.region =  MKCoordinateRegion (
            center: .start,
            span: MKCoordinateSpan (latitudeDelta: 0.0125, longitudeDelta: 0.0125))
        
        Task {
            let search = MKLocalSearch (request: request)
            let response = try? await search.start ()
            searchResults = response?.mapItems ?? []
    }
```
