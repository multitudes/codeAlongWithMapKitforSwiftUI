//
//  MapCameraView.swift
//  codeAlongWithMapKitforSwiftUI
//
//  Created by Laurent B on 27/08/2023.
//

import MapKit
import SwiftUI

struct CameraParam: Equatable {
	var distance: Double
	var heading: Double
	var pitch: Double
	
	static let defaults = CameraParam(distance: 980, heading: 242, pitch: 60)
}

extension CLLocationCoordinate2D {
	static var notreDameCoord = CLLocationCoordinate2D(
		latitude: 48.8530,
		longitude: 2.3499
	)
}

extension MapCameraPosition {
	static let notreDame: MapCameraPosition = .camera(
		MapCamera(centerCoordinate: .notreDameCoord,
		//The distance from the center point of the map to the camera, in meters.
		distance: CameraParam.defaults.distance,
		//The heading of the camera, in degrees, relative to true North.
		heading: CameraParam.defaults.heading,
		//The viewing angle of the camera, in degrees.
		pitch: CameraParam.defaults.pitch
		))
}

struct MapCameraView: View {
	@State private var position: MapCameraPosition = .notreDame
	@State private var cameraParam: CameraParam = CameraParam.defaults
	
    var body: some View {
		Map(position: $position) {
			
		}
		.mapStyle(.standard)
		.safeAreaInset(edge: .bottom) {
			Form {
				Section {
					Slider(value: $cameraParam.distance, in: 10...1500)
				} header: {
					Label("Distance", systemImage: "chevron.up.circle")
				}
				
				Section {
					Slider(value: $cameraParam.heading, in: 0...360)
				} header: {
					Label("Heading", systemImage: "arrow.triangle.2.circlepath.circle")
				}
				
				Section {
					Slider(value: $cameraParam.pitch, in: 0...70)
				} header: {
					Label("Pitch", systemImage: "trapezoid.and.line.vertical")
				}
				
				Button("Reset params") {
					
				}
			}
			.frame(height: 280)
			.background(.thinMaterial)
		}
		.mapStyle(.standard(elevation: .realistic))
		.onMapCameraChange {
			// update params here if user changes the settings with his finger dire tly on the map
		}
		.onChange(of: cameraParam) {
			// update the position
			position = .camera(
				MapCamera(centerCoordinate: CLLocationCoordinate2D(
					latitude: 48.8530,
					longitude: 2.3499
				),
					distance: cameraParam.distance,
					heading: cameraParam.heading,
					pitch: cameraParam.pitch
				))
		}
    }
}

#Preview {
    MapCameraView()
}
