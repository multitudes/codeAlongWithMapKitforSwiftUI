//
//  MapButtonView.swift
//  codeAlongWithMapKitforSwiftUI
//
//  Created by Laurent B on 16/08/2023.
//

import MapKit
import SwiftUI

struct MapButtonView: View {
    @Binding var searchResults: [MKMapItem]
	@Binding var position: MapCameraPosition
	
    var body: some View {
		HStack(spacing: 10) {
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
			
			Button {
				position = .region(.étretat)
			} label: {
				Label("Honfleur", systemImage: "sun.dust.fill")
					.frame(width: 44, height: 44)
			}
			.buttonStyle(.bordered)
			
			Button {
				position = .region(.honfleur)
			} label: {
				Label("Honfleur", systemImage: "sailboat.fill")
					.frame(width: 44, height: 44)
			}
			.buttonStyle(.bordered)
        }
        .labelStyle(.iconOnly)
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
            let response = try? await search.start()
            searchResults = response?.mapItems ?? []
        }
    }
}

#Preview {
	MapButtonView(searchResults: .constant([]), position: .constant(.automatic))
}
