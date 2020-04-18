//
//  TemperatureViewModel.swift
//  Greenhouse
//
//  Created by Izzy on 14/04/2020.
//  Copyright © 2020 Isabel Briant. All rights reserved.
//

import SwiftMQTT
import SwiftUI
import Combine

final class TemperatureViewModel: ObservableObject {
    @ObservedObject var dataProvider: MQTTDataProvider
    var cancellable: AnyCancellable?

    @Published var temperature: String
    private var temperatureC: String?

    private var temperatureF: String {
        guard let celcius = temperatureC, let float = Float(celcius) else { return "" }
        let fahrenheit = (float * 9/5) + 32
        return fahrenheit.formattedOneDecimal
    }
    
    private var unit: Unit = .c
    
    init(dataProvider: MQTTDataProvider = MQTTDataProvider()) {
        self.dataProvider = dataProvider
        temperatureC = dataProvider.data
        temperature = "--°C"
        cancellable = dataProvider.dataPublisher.print().sink { [weak self] in
              self?.updateTemperature()
        }
        start()
    }
    
    func start() {
        dataProvider.connect()
    }
    
    func changeUnit() {
        unit = unit == .c ? .f : .c
        temperature = formattedTemperature()
    }

    private func updateTemperature() {
        guard let temp = dataProvider.data, let float = Float(temp) else { return }
        let rounded = ((float * 10).rounded()) / 10
        temperatureC = rounded.formattedOneDecimal
        temperature = formattedTemperature()
    }
    
    private func formattedTemperature() -> String {
        switch unit {
        case .c: return "\(temperatureC ?? "")°C"
        case .f: return "\(temperatureF)°F"
        }
    }
}

extension TemperatureViewModel {
    enum Unit {
        case c
        case f
    }
}

private extension Float {
    var formattedOneDecimal: String {
        String(format: "%0.1f", self)
    }
}
