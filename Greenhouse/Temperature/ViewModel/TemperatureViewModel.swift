//
//  TemperatureViewModel.swift
//  Greenhouse
//
//  Created by Izzy on 14/04/2020.
//  Copyright © 2020 Isabel Briant. All rights reserved.
//

import SwiftMQTT
import SwiftUI

final class TemperatureViewModel: ObservableObject {
    @ObservedObject var dataProvider: MQTTDataProvider
    @Published var temperature: String?
    
    init(dataProvider: MQTTDataProvider = MQTTDataProvider()) {
        self.dataProvider = dataProvider
        temperature = dataProvider.data
    }
    
    func start() {
        dataProvider.connect()
    }

    private func update(temperatureInDegrees: String?) {
//        guard let degrees = temperatureInDegrees else {
//            temperature = ""
//            return
//        }
//        temperature = "\(degrees)°"
    }
}
