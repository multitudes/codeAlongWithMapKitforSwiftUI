//
//  MapButtonsView.swift
//  codeAlongWithMapKitforSwiftUI
//
//  Created by Laurent B on 21/09/2023.
//

import MapKit
import SwiftUI

struct MapButtonView: View {
	@Binding var searchResults: [MKMapItem]
	
    var body: some View {
		HStack {
			Button {
				search(for: "cafes")
			} label: {
				Label ("Cafes", systemImage: "cup.and.saucer.fill")
					.frame(width: 44, height: 44)
			}
			.buttonStyle(.borderedProminent)
			
			Button {
				search(for: "beach")
			} label: {
				Label ("Beaches", systemImage: "beach.umbrella")
					.frame(width: 44, height: 44)
			}
			.buttonStyle(.borderedProminent)
		}
		.labelStyle (.iconOnly)
    }
	
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
	}
}

#Preview {
		MapButtonView(searchResults: .constant([]))
}

