//
//  ContentView.swift
//  codeAlongWithMapKitforSwiftUI
//
//  Created by Laurent B on 16/08/2023.
//

import MapKit
import SwiftUI

extension CLLocationCoordinate2D {
	static var start = CLLocationCoordinate2D(latitude: 49.7071, longitude: 0.2064)
}

struct ContentView: View {
	@State private var searchResults: [MKMapItem] = []
	
	var body: some View {
		Map {
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
			}
			.annotationTitles(.hidden)
		}
		.safeAreaInset(edge: .bottom) {
			HStack {
				Spacer()
				MapButtonView(searchResults: $searchResults)
					.padding(.top)
				Spacer()
			}
		}
		.background(.thinMaterial)
		.mapStyle(.standard(elevation: .realistic))
	}
}


#Preview {
	ContentView()
}
