//
//  DataProvider.swift
//  Greenhouse
//
//  Created by Izzy on 14/04/2020.
//  Copyright © 2020 Isabel Briant. All rights reserved.
//

import Foundation
import SwiftMQTT
import Combine

protocol DataProvider {
    var data: String? { get }
    func connect()
}

final class MQTTDataProvider: DataProvider, ObservableObject {
    @Published var data: String?
     let dataPublisher = PassthroughSubject<Void, Never>()
    
    private let mqttSession: MQTTSession
    private let topic = "greenhouse/temp"
    
    init(host: String = "chip.local") {
        mqttSession = MQTTSession(host: host,
                                  port: 1883,
                                  clientID: UUID().uuidString,
                                  cleanSession: true,
                                  keepAlive: 15,
                                  useSSL: false)
        mqttSession.delegate = self
    }
    
    func connect() {
        mqttSession.connect { [weak self] error in
            guard let self = self else { return }
            switch error {
            case .none:
                print("🌱 connected to chip")
                self.subscribe()
            default:
                self.handleError(error)
            }
        }
    }
    
    private func subscribe() {
        mqttSession.subscribe(to: topic, delivering: .atLeastOnce) { [weak self] error in
            guard let self = self else { return }
            switch error {
            case .none:
                print("🌱 subscribed to \(self.topic)")
            default:
                self.handleError(error)
            }
        }
    }
    
    private func unsubscribe() {
        mqttSession.unSubscribe(from: topic) { [weak self] error in
            guard let self = self else { return }
            switch error {
            case .none:
                print("🌱 unsubscribed from \(self.topic)!")
            default:
                self.handleError(error)
            }
        }
    }
    
    private func handleError(_ error: MQTTSessionError) {
        print("🐛 \(error.description)")
        if error == .socketError {
            connect()
        }
    }
    
    deinit {
        unsubscribe()
    }
}

extension MQTTDataProvider: MQTTSessionDelegate {
    func mqttDidReceive(message: MQTTMessage, from session: MQTTSession) {
        guard message.topic == topic else { return }
        print(message)
        data = message.stringRepresentation
        dataPublisher.send()
    }

    func mqttDidAcknowledgePing(from session: MQTTSession) {
        print("🌱 ping")
    }
    
    func mqttDidDisconnect(session: MQTTSession, error: MQTTSessionError) {
        switch error {
        case .none:
            print("🌱 disconnected from mqtt broker")
        default:
            self.handleError(error)
        }
    }
}
