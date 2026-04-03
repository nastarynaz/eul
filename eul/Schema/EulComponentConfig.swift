//
//  EulComponentConfig.swift
//  eul
//
//  Created by Gao Sun on 2020/11/8.
//  Copyright © 2020 Gao Sun. All rights reserved.
//

import Foundation
import SharedLibrary
import SwiftUI
import SwiftyJSON

enum GraphColorOption: String, CaseIterable, Codable {
    case monochrome
    case red
    case blue
    case orange
    case yellow

    var color: Color {
        switch self {
        case .monochrome: return .text
        case .red: return .graphRed
        case .blue: return .graphBlue
        case .orange: return .graphOrange
        case .yellow: return .graphYellow
        }
    }

    var label: String {
        switch self {
        case .monochrome: return "Monochrome"
        case .red: return "Red"
        case .blue: return "Blue"
        case .orange: return "Orange"
        case .yellow: return "Yellow"
        }
    }
}

struct EulComponentConfig: Codable {
    var component: EulComponent
    var showIcon: Bool = true
    var showGraph: Bool = false
    var diskSelection: String = ""
    var networkPortSelection: String = ""
    var graphColor: GraphColorOption = .monochrome

    var json: JSON {
        JSON([
            "component": component.rawValue,
            "showIcon": showIcon,
            "showGraph": showGraph,
            "diskSelection": diskSelection,
            "networkPortSelection": networkPortSelection,
            "graphColor": graphColor.rawValue,
        ])
    }
}

extension EulComponentConfig {
    init?(_ json: JSON) {
        guard let rawComponent = json["component"].string, let component = EulComponent(rawValue: rawComponent) else {
            return nil
        }

        self.component = component

        if let bool = json["showIcon"].bool {
            showIcon = bool
        }

        if let bool = json["showGraph"].bool {
            showGraph = bool
        }

        if let string = json["diskSelection"].string {
            diskSelection = string
        }

        if let string = json["networkPortSelection"].string {
            networkPortSelection = string
        }

        if let string = json["graphColor"].string, let option = GraphColorOption(rawValue: string) {
            graphColor = option
        }
    }
}
