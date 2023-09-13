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

extension MKMapRect {
	// static let myRect = MKMapRect(...)
}



struct ContentView: View {
	@State private var position: MapCameraPosition = .automatic
	@State private var visibleRegion: MKCoordinateRegion? = nil
	@State private var searchResults: [MKMapItem] = []
	@State private var selectedResult: MKMapItem?
	@State private var route: MKRoute?
	
	@State var pinLocation :CLLocationCoordinate2D? = nil
	
	var body: some View {
		MapReader {  reader in
			Map(position: $position, selection: $selectedResult) {
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
				.annotationTitles(.hidden)
				
				ForEach(searchResults, id: \.self) { result in
					Marker(item: result)
						.annotationTitles(.hidden)
				}
				if let route {
					MapPolyline(route)
						.stroke(.blue, lineWidth: 5)
				}
				if let pinLocation = pinLocation {
					Marker("", coordinate: pinLocation)
				}
			}
			.onTapGesture(perform: { screenCoord in
				print("\(screenCoord.y)")
				pinLocation = reader.convert(screenCoord, from: .local)
				print("\(pinLocation?.latitude ?? 0.0)")
				if let pinLocation = pinLocation {
					selectedResult = MKMapItem(placemark: MKPlacemark(coordinate: pinLocation))
				}
			})
			.mapStyle(.standard(elevation: .realistic))
			.safeAreaInset(edge: .bottom) {
				HStack {
					Spacer()
					VStack(spacing: 0) {
						if let selectedResult {
							ItemInfoView(selectedResult: selectedResult, route: route)
								.frame(height: 128)
								.clipShape(RoundedRectangle (cornerRadius: 10))
								.padding([.top, .horizontal])
						}
						MapButtonView(
							searchResults: $searchResults,
							position: $position,
							visibleRegion: visibleRegion)
						.padding(.top)
					}
					Spacer()
				}
				.background(.thinMaterial)
			}
			.onChange(of: searchResults) {
				position = .automatic
				route = nil
				selectedResult = nil
				pinLocation = nil
				
			}
			.onChange(of: selectedResult) {
				getDirections()
			}
			.onMapCameraChange { context in
				visibleRegion = context.region
			}
		}
	}
	
	func getDirections() {
		route = nil
		guard let selectedResult else { return }
		let request = MKDirections.Request()
		request.source = MKMapItem(placemark: MKPlacemark(coordinate: .start))
		request.destination = selectedResult
		
		Task {
			let directions = MKDirections(request: request)
			let response = try? await directions.calculate()
			route = response?.routes.first
		}
	}
}

#Preview {
	ContentView()
}
