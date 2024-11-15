//
//  ContentView.swift
//  forecast
//
//  Created by alumno on 11/15/24.
//

import SwiftUI

struct Weather: Codable {
    var location: Location
    var forecast: Forecast
}

struct Location: Codable {
    var name: String
}

struct Forecast: Codable {
    var forecastday: [ForecastDay]
}

struct ForecastDay: Codable, Identifiable {
    var date_epoch: Int
    var id: Int {date_epoch}
    var day: Day
}

struct Day: Codable {
    var avgtemp_c: Double
    var condition: Condition
}

struct Condition: Codable {
    var text: String
}

struct ContentView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("Toronto")
                .font(.system(size: 35))
                .bold()
            Text("\(Date().formatted(date: .complete, time: .omitted))")
                .font(.system(size: 18))
            Text("☀️")
                .font(.system(size: 180))
                .shadow(radius: 75)
            Text("0°C")
                .font(.system(size: 70))
                .bold()
        }
    }
}
#Preview {
    ContentView()
}
