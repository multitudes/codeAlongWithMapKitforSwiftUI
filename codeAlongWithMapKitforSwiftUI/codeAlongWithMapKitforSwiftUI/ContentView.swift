//
//  ContentView.swift
//  codeAlongWithMapKitforSwiftUI
//
//  Created by Laurent B on 16/08/2023.
//

import MapKit
import SwiftUI

extension CLLocationCoordinate2D {
    static var start = CLLocationCoordinate2D(latitude: 49.44625973148958, longitude: 1.0889092507665954)
}

extension MKCoordinateRegion {
	static let étretat = MKCoordinateRegion (
		center: CLLocationCoordinate2D( latitude: 49.7071, longitude: 0.2064),
		span: MKCoordinateSpan ( latitudeDelta: 0.1, longitudeDelta: 0.1)
	)
	
	static let honfleur = MKCoordinateRegion (
		center: CLLocationCoordinate2D( latitude: 49.4194, longitude: 0.2333),
		span: MKCoordinateSpan( latitudeDelta: 0.1, longitudeDelta: 0.1)
	)
}

struct ContentView: View {
	@State private var position: MapCameraPosition = .automatic
	@State private var visibleRegion: MKCoordinateRegion?
	@State private var searchResults: [MKMapItem] = []
	
    var body: some View {
        Map(position: $position) {
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
			
			ForEach(searchResults, id: \.self) { result in
				Marker(item: result)
					.annotationTitles(.hidden)
			}
        }
        .mapStyle(.standard(elevation: .realistic))
        .safeAreaInset(edge: .bottom) {
			HStack {
				Spacer()
				MapButtonView(
					searchResults: $searchResults,
					position: $position)
					.padding(.top)
				Spacer()
			}
			.background(.thinMaterial)
        }
		.onChange(of: searchResults) {
			position = .automatic
		}
		.onMapCameraChange { context in
			visibleRegion = context.region
		}
    }
}

#Preview {
    ContentView()
}
