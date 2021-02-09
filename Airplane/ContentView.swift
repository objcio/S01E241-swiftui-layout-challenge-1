//
//  ContentView.swift
//  Airplane
//
//  Created by Chris Eidhof on 08.02.21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Hello, World!")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct WidthKey: PreferenceKey {
    static let defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

extension View {
    func measureWidth(_ f: @escaping (CGFloat) -> ()) -> some View {
        overlay(GeometryReader { proxy in
            Color.clear.preference(key: WidthKey.self, value: proxy.size.width)
        }
        .onPreferenceChange(WidthKey.self, perform: f))
    }
}

struct AirplaneView: View {
    var from: Text = Text("Berlin")
    var to: Text = Text("San Francisco")
    let airplaneIcon = Text("✈️")
    
    @State var proposedWidth: CGFloat = 0
    @State var fromWidth: CGFloat = 0
    @State var airplaneWidth: CGFloat = 0
    @State var toWidth: CGFloat = 0
    
    var shouldDrawOffCenter: Bool {
        let labelWidth = (proposedWidth - airplaneWidth) / 2
        return fromWidth > labelWidth || toWidth > labelWidth
    }
    
    var body: some View {
        HStack(spacing: 0) {
            if shouldDrawOffCenter {
                from
                Spacer()
                airplaneIcon
                Spacer()
                to
            } else {
                from
                    .frame(maxWidth: .infinity, alignment: .leading)
                airplaneIcon
                to
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .measureWidth { self.proposedWidth = $0 }
        .background(HStack {
            from.fixedSize().measureWidth { self.fromWidth = $0 }
            airplaneIcon.fixedSize().measureWidth { self.airplaneWidth = $0 }
            to.fixedSize().measureWidth { self.toWidth = $0 }
        }.hidden())
        .lineLimit(1)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            AirplaneView().frame(width: 250)
            AirplaneView().frame(width: 200)
            AirplaneView().frame(width: 175)
            AirplaneView().frame(width: 150)
            AirplaneView().frame(width: 125)
            AirplaneView().frame(width: 100)
        }
    }
}
