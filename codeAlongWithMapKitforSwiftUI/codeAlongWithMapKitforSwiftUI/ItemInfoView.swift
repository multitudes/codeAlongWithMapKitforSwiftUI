//
//  ItemInfoView.swift
//  codeAlongWithMapKitforSwiftUI
//
//  Created by Laurent B on 10/09/2023.
//

import MapKit
import SwiftUI

struct ItemInfoView: View {
	var selectedResult: MKMapItem
	var route: MKRoute?
	
	private var travelTime: String? {
		guard let route else { return nil }
		let formatter = DateComponentsFormatter()
		formatter.unitsStyle = .abbreviated
		formatter.allowedUnits = [.hour, .minute]
		return formatter.string(from: route.expectedTravelTime)
	}
	
	var body: some View {
		HStack {
			Text ("\(selectedResult.name ?? "")")
			if let travelTime {
				Text(travelTime)
			}
		}
		.font(.caption)
		.padding (10)
	}
}

#Preview {
	ItemInfoView(selectedResult: MKMapItem.forCurrentLocation())
}
