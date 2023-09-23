//
//  RouteView.swift
//  codeAlongWithMapKitforSwiftUI
//
//  Created by Laurent B on 22/09/2023.
//

import MapKit
import SwiftUI

struct RouteView: View {
	@State private var route: [CLLocationCoordinate2D]?
	@State private var waypoints: [Waypoint]?
	
	var body: some View {
		Map {
			
			if let route {
				MapPolyline(coordinates: route, contourStyle: .straight)
					.stroke(.blue, lineWidth: 5)
			}
			
			if let waypoints {
				ForEach(waypoints) { waypoint in
					Annotation(waypoint.name,
							   coordinate: waypoint.coord,
							   anchor: .bottom
					){
						Image(systemName: waypoint.image)
							.padding(4)
							.foregroundStyle(.white)
							.background(waypoint.background)
							.cornerRadius(2)
					}
					//.annotationTitles(.hidden)
				}
			}
		}
		.onAppear {
			
			
			getRouteGPX(file: "TransVerdon")
		}
	}
	
	// this function will convert the GPX file to an array of CLLocationCoordinate2D
	func getRouteGPX(file: String) {
		// reset the previous if any
		route = nil
		// instaantiate the parser
		let gpxParser = GPXParser(with: file)
		let gpxData = gpxParser.parse()
		route = gpxData.route
		waypoints = gpxData.waypoints
		print(gpxData.debugDescription)
		}
}

#Preview {
	RouteView()
}

// our data model
struct GPXData: CustomDebugStringConvertible {
	// properties of the xml file
	var author: String = ""
	var url: String = ""
	var time: String = ""
	
	// properties computed by our parser
	var route = [CLLocationCoordinate2D]()
	var waypoints = [Waypoint]()
	
	var debugDescription: String {
		return "Author: \(author), url: \(url)"
	}
}

struct Waypoint: Identifiable {
	let id = UUID()
	var name: String = ""
	var coord: CLLocationCoordinate2D
	// this is a string defining the sf image to use
	var image: String = ""
	var background: Color = .brown
}
// need to be NSObject because required by XMLParserDelegate
class GPXParser: NSObject, XMLParserDelegate  {
	
	// will be assigned in the init together with the data from the gpx file
	var xmlParser: XMLParser?
	// temp variable to store the chars fired by the parser
	var xmlText: String = ""
	// instantiating our data model
	var gpxData: GPXData = GPXData()
	// need this to create a temp waypoint
	var currentWaypoint: Waypoint?
	
	// We init with a gpx file in our bundle in this case but it could be on the web as well
	init(with gpxFilename: String) {
		// get the assets from the Bundle
		if let fileName = Bundle.main.url(forResource: gpxFilename, withExtension: "gpx"),
		   let data = try? Data(contentsOf: fileName) {
			xmlParser = XMLParser(data: data)
		}
	}
	
	//This is not a delegate function. We call it from outside to get our gpxData parsed
	func parse() -> GPXData {
		xmlParser?.delegate = self
		xmlParser?.parse()
		return gpxData
	}
	
	// delegate function didStartElement
	// it will notify me when the element tag is found as a start. I will use it for the latitude and longitude params
	func parser(_ parser: XMLParser,
				didStartElement elementName: String,
				namespaceURI: String?,
				qualifiedName qName: String?,
				attributes attributeDict: [String : String]) {
		// reset temp text to be empty
		xmlText = ""
		// in this method we will only look at two elements and get their coordinates
		switch elementName {
		case "trkpt":
			// from the XMLParser we get strings
			guard let latString = attributeDict["lat"],
				  let lonString = attributeDict["lon"] else { return }
			guard let lat = Double(latString), let lon = Double(lonString) else { return }
			gpxData.route.append(CLLocationCoordinate2D(latitude: lat, longitude: lon))
			
		// the waypoints will start with wpt
		case "wpt":
			// again we get the strings
			guard let latString = attributeDict["lat"],
				  let lonString = attributeDict["lon"] else { return }
			// we convert to double
			guard let lat = Double(latString), let lon = Double(lonString) else { return }
			// I will append it when I get the name in the other parser delegate
			currentWaypoint = Waypoint(coord: CLLocationCoordinate2D(latitude: lat, longitude: lon))
		default:
			return
		}
	}
	
	// this is another parser method we get from the delegate. This one fires when we get a closing tag for an element. Ideal to get the values from the header. When we get at the end of the tag our temp xmltext var will be populated with the string inside the tags
	func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
		if elementName == "author" {
			gpxData.author = xmlText.trimmingCharacters(in: .whitespacesAndNewlines)
		}
		if elementName == "url" {
			gpxData.url = xmlText.trimmingCharacters(in: .whitespacesAndNewlines)
		}
		if elementName == "time" {
			gpxData.time = xmlText.trimmingCharacters(in: .whitespacesAndNewlines)
		}
		// adding the name and then appending the waypoint to the array
		if elementName == "name" {
			guard var currentWaypoint else { return }
			currentWaypoint.name = xmlText.trimmingCharacters(in: .whitespacesAndNewlines)
			// check for the image to display
			if currentWaypoint.name.contains("CAMP") ||
				currentWaypoint.name.contains("SHELTER")
			{
				currentWaypoint.image = "tent"
				currentWaypoint.background = .brown
				
			} else if currentWaypoint.name.contains("Supermarket") {
				currentWaypoint.image = "basket.fill"
				currentWaypoint.background = .cyan
			} else {
				currentWaypoint.image = "mappin.circle.fill"
				currentWaypoint.background = .gray
			}
			
			
			gpxData.waypoints.append(currentWaypoint)
			}
		currentWaypoint = nil
//		}
	}
	// this delegate method populates our temp file xmlText
	func parser(_ parser: XMLParser, foundCharacters string: String) {
		xmlText += string
	}
}


