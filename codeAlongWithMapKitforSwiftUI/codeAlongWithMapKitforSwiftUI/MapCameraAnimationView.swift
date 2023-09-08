//
//  MapCameraAnimationView.swift
//  codeAlongWithMapKitforSwiftUI
//
//  Created by Laurent B on 02/09/2023.
//

import MapKit
import SwiftUI

extension MKMapRect {
	static var paris = MKMapRect(origin: MKMapPoint(.notreDameCoord), size: MKMapSize(width: 1000, height: 1000))
}

struct MapCameraAnimationView: View {
	@State private var trigger = false
	
	var body: some View {
		Map {
			
		}
		.mapCameraKeyframeAnimator(trigger: trigger) { _ in
			KeyframeTrack(\.centerCoordinate) {
				MoveKeyframe(.notreDameCoord)
			}
			KeyframeTrack(\.distance) {
				LinearKeyframe(900, duration: 8)
				LinearKeyframe(450, duration: 8)
				LinearKeyframe(350, duration: 8)
				LinearKeyframe(400, duration: 8)
				LinearKeyframe(400, duration: 8)
			}
			KeyframeTrack(\.heading) {
				LinearKeyframe(242, duration: 8)
				LinearKeyframe(360, duration: 8)
				LinearKeyframe(440, duration: 8)
				LinearKeyframe(480, duration: 8)
				LinearKeyframe(500, duration: 8)
			}
			KeyframeTrack(\.pitch) {
				LinearKeyframe(60, duration: 8)
				LinearKeyframe(70, duration: 8)
				LinearKeyframe(80, duration: 8)
				LinearKeyframe(90, duration: 8)
				LinearKeyframe(90, duration: 8)
			}
		}
		.onAppear {
			trigger = true
		}
		.mapStyle(.standard(elevation: .realistic))
	}
}


#Preview {
    MapCameraAnimationView()
}
