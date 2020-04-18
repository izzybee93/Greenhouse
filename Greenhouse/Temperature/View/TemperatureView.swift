//
//  TemperatureView.swift
//  Greenhouse
//
//  Created by Izzy on 14/04/2020.
//  Copyright © 2020 Isabel Briant. All rights reserved.
//

import SwiftUI

struct TemperatureView: View {
    @ObservedObject var viewModel: TemperatureViewModel
    @Environment(\.colorScheme) var colorScheme

    var tap: some Gesture {
           TapGesture(count: 1).onEnded { _ in self.viewModel.changeUnit() }
    }
    
    
    init(viewModel: TemperatureViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            if colorScheme == .light {
                Color.backgroundLight.edgesIgnoringSafeArea([.top, .bottom])
            } else {
                Color.backgroundDark.edgesIgnoringSafeArea([.top, .bottom])
            }
            
            TemperatureTextView(temperature: viewModel.temperature)
        }.gesture(tap)
    }
}

private struct TemperatureTextView: View {
    var temperature: String
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        GeometryReader { geometry in
            Text(self.temperature)
                .font(.big)
                .bold().foregroundColor(self.textColor())
                .offset(CGSize(width: 0, height: -(geometry.size.height/6)))
        }
    }
    
    private func textColor() -> Color {
        return colorScheme == .light ? Color.foregroundLight : Color.foregroundDark
    }
}

#if DEBUG
struct TemperatureView_Preview: PreviewProvider {
    static var previews: some View {
        TemperatureView(viewModel: TemperatureViewModel())
    }
}

struct TemperatureViewDark_Preview: PreviewProvider {
    static var previews: some View {
        TemperatureView(viewModel: TemperatureViewModel())
            .environment(\.colorScheme, .dark)
    }
}
#endif
