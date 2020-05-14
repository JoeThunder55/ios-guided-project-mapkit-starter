//
//  Quake.swift
//  Quakes
//
//  Created by Joe on 5/13/20.
//  Copyright © 2020 Lambda, Inc. All rights reserved.
//

import Foundation
import MapKit

struct QuakeResults: Decodable {
    let features: [Quake]
    
}

class Quake: Codable, NSObject {
    let magnitude: Double
    let place: String
    let time: Date
    let latitude: Double
    let longitude: Double
    
    enum QuakeCodingKeys: String, CodingKey {
      case properties
        case mag
        case place
        case time
        case geometry
        case coordinates
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: QuakeCodingKeys.self)
        let properties =  try container.nestedContainer(keyedBy: QuakeCodingKeys.self, forKey: .properties)
        self.magnitude = try properties.decode(Double.self, forKey: .mag)
        self.place = try properties.decode(String.self, forKey: .place)
        self.time = try properties.decode(Date.self, forKey: .time)
        
        let geometry =  try container.nestedContainer(keyedBy: QuakeCodingKeys.self, forKey: .geometry)
        var coordinates = try geometry.nestedUnkeyedContainer(forKey: .coordinates)
        self.longitude = try coordinates.decode(Double.self)
        self.latitude = try coordinates.decode(Double.self)
    }
}


extension Quake: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D {
            CLLocationCoordinate2D(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)
        }
    }
    var title: String? {
        place
    }
  
    var subtitle: String? {
        "Magnitude: \(magnitude)"
    }
}
