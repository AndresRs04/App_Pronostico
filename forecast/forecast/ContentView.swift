//
//  ContentView.swift
//  forecast
//
//  Created by alumno on 11/15/24.
//

import SwiftUI
import Alamofire


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
    
    @State private var resultados = [ForecastDay]()
    
    let azulCielo = Color.init(red: 135/255, green: 206/255, blue: 235/255)
    let gris = Color.init(red: 47/255, green: 79/255, blue: 79/255)
    
    @State var colorDeFondo = Color.init(red: 135/255, green: 206/255, blue: 235/255)
    @State var iconoDelClima = "☀️"
    @State var tempActual = 0
    @State var condicionTexto = "Slightly Overcast"
    @State var nombreCiudad = "Washington"
    @State var cargando = true
    var body: some View {
        VStack {
            Spacer()
            Text("\(nombreCiudad)")
                .font(.system(size: 35))
                .foregroundStyle(.white)
                .bold()
            Text("\(Date().formatted(date: .complete, time: .omitted))")
                .font(.system(size: 18))
            Text(iconoDelClima)
                .font(.system(size: 180))
                .shadow(radius: 75)
            Text("\(tempActual)°C")
                .font(.system(size: 70))
                .foregroundStyle(.white)
                .bold()
            Text("\(condicionTexto)")
                .font(.system(size: 22))
                .foregroundStyle(.white)
                .bold()
            Spacer()
            Spacer()
            Spacer()
            Spacer()
            Spacer()
            List (resultados) { forecast in
                HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: nil) {
                    Text("\(obtenerFecha(epoch: forecast.date_epoch))")
                        .frame(maxWidth: 50, alignment: .leading)
                        .bold()
                    Text("\(obtenerIconoDelClima(text: forecast.day.condition.text))")
                        .frame(maxWidth: 30, alignment: .leading)
                    Text("\(Int(forecast.day.avgtemp_c))°C")
                    Spacer()
                    Text("\(forecast.day.condition.text)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
                .listRowBackground(Color.white.blur(radius: 75).opacity(0.5))
            }
            .contentMargins(.vertical, 0)
            .scrollContentBackground(.hidden)
            .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
            Spacer()
            Text("Información Proporcionada por Free Weather API")
                .font(.system(size: 12))
            
        }
        .background(colorDeFondo)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
        .task {
            await obtenerEstadoDeclima()
        }
    }
    
    func obtenerEstadoDeclima () async {
        let solicitud = AF.request("http://api.weatherapi.com/v1/forecast.json?key=aa92633023c44229b4e172550241311&q=98101&days=3&aqi=no&alerts=no")
        solicitud.responseDecodable(of: Weather.self) { response in
            switch response.result {
            case.success(let weather):
                nombreCiudad = weather.location.name
                resultados = weather.forecast.forecastday
                tempActual = Int(resultados[0].day.avgtemp_c)
                colorDeFondo = establecerColorDeFondo(text: resultados[0].day.condition.text)
                iconoDelClima = obtenerIconoDelClima(text: resultados[0].day.condition.text)
                condicionTexto = resultados[0].day.condition.text
                cargando = false
            case.failure(let error):
            print(error)
            }
            
        }
    }
    
    func obtenerIconoDelClima(text: String) -> String {
        var iconoDelClima = "☀️"
        let condicionTexto = text.lowercased()
        if condicionTexto.contains("snow") ||
            condicionTexto.contains("blizzard") {
            iconoDelClima = "🌨️"
        } else if condicionTexto.contains("rain") {
            iconoDelClima = "🌧️"
        } else if condicionTexto.contains("partly cloudy") {
            iconoDelClima = "🌥️"
        } else if condicionTexto.contains("cloudy") ||
                    condicionTexto.contains("overcast") {
            iconoDelClima = "☁️"
        } else if condicionTexto.contains("clear") ||
                    condicionTexto.contains("sunny") {
            iconoDelClima = "☀️"
        }
        
        return iconoDelClima
    }
    
    func establecerColorDeFondo (text: String) -> Color {
        var colorDeFondo = azulCielo
        let condicionDeTexto = text.lowercased()
        if !(condicionDeTexto.contains("clear") ||
             condicionDeTexto.contains("sunny")) {
            colorDeFondo = gris
        }
        return colorDeFondo
    }
    
    func obtenerFecha(epoch: Int) -> String {
        return Date(timeIntervalSince1970:
                        TimeInterval(epoch)).formatted(Date.FormatStyle()
                            .weekday(.abbreviated))
    }
}

#Preview {
    ContentView()
}

