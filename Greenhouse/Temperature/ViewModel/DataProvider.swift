//
//  DataProvider.swift
//  Greenhouse
//
//  Created by Izzy on 14/04/2020.
//  Copyright © 2020 Isabel Briant. All rights reserved.
//

import Foundation
import SwiftMQTT

protocol DataProvider {
    var temperatureData: Float? { get }
}

final class MQTTDataProvider: DataProvider {
    var temperatureData: Float?
    private var mqttSession: MQTTSession?
    
    func connect() {
        mqttSession = MQTTSession(host: "chip.local",
                                  port: 1883,
                                  clientID: UUID().uuidString,
                                  cleanSession: true,
                                  keepAlive: 15,
                                  useSSL: false)
        
    }
}
