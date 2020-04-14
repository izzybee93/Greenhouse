//
//  TemperatureView.swift
//  Greenhouse
//
//  Created by Izzy on 14/04/2020.
//  Copyright © 2020 Isabel Briant. All rights reserved.
//

import SwiftUI

struct TemperatureView: View {
    @ObservedObject private var viewModel: TemperatureViewModel
    
    init(viewModel: TemperatureViewModel) {
        self.viewModel = viewModel
    }
        
    var body: some View {
        ZStack {
            Color.background.edgesIgnoringSafeArea([.top, .bottom])
            TemperatureTextView()
        }
    }
}

private struct TemperatureTextView: View {
    @State var temperature: String = ""
    var body: some View {
        GeometryReader { geometry in
            Text(self.temperature)
                .font(.big)
                .bold().foregroundColor(.primary)
                .offset(CGSize(width: 0, height: -(geometry.size.height/6)))
        }
    }
}

#if DEBUG
struct TemperatureView_Preview: PreviewProvider {
    static var previews: some View {
        TemperatureView(viewModel: TemperatureViewModel())
    }
}
#endif
