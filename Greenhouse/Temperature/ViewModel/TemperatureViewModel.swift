//
//  TemperatureViewModel.swift
//  Greenhouse
//
//  Created by Izzy on 14/04/2020.
//  Copyright © 2020 Isabel Briant. All rights reserved.
//

import SwiftMQTT

final class TemperatureViewModel {
    private(set) var temperature: String = ""
    private let dataProvider: DataProvider
    
    init(dataProvider: DataProvider = MQTTDataProvider()) {
        self.dataProvider = dataProvider
    }

    private func update(temperatureInDegrees: Float) {
        guard let degrees = dataProvider.temperatureData else {
            temperature = ""
            return
        }
        temperature = "\(degrees)°"
    }
}
