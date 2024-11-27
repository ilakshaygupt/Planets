//
//  PlanetModel.swift
//  Planets
//
//  Created by Lakshay Gupta on 27/11/24.
//


import SwiftUI

import Foundation
struct PlanetModel  {
    var backgroundColor: String
    var name: String
    var nickName: String
    var properties: PlanetProperties

    static let planets: [PlanetModel] = [
        PlanetModel(
            backgroundColor: "#B7B8B9",
            name: "Mercury",
            nickName: "The Messenger",
            properties: PlanetProperties(
                radius: "2,439.7 km",
                distanceFromSun: "57.9 mln km",
                moons: "0",
                gravity: "3.7 m/s²",
                tiltOfAxis: "0.03°",
                lengthOfYear: "88 earth days",
                lengthofDay: "58.6 earth days",
                temperature: "Average 167°C"
            )
        ),
        PlanetModel(
            backgroundColor: "#E6C229",
            name: "Venus",
            nickName: "Earth's Sister",
            properties: PlanetProperties(
                radius: "6,051.8 km",
                distanceFromSun: "108.2 mln km",
                moons: "0",
                gravity: "8.87 m/s²",
                tiltOfAxis: "177.3°",
                lengthOfYear: "225 earth days",
                lengthofDay: "243 earth days",
                temperature: "Average 462°C"
            )
        ),
        PlanetModel(
            backgroundColor: "#4169E1",
            name: "Earth",
            nickName: "The Blue Planet",
            properties: PlanetProperties(
                radius: "6,371 km",
                distanceFromSun: "149.6 mln km",
                moons: "1",
                gravity: "9.8 m/s²",
                tiltOfAxis: "23.4°",
                lengthOfYear: "365.25 days",
                lengthofDay: "24 hours",
                temperature: "Average 15°C"
            )
        ),
        PlanetModel(
            backgroundColor: "#E6744E",
            name: "Mars",
            nickName: "The Red Planet",
            properties: PlanetProperties(
                radius: "3,389.5 km",
                distanceFromSun: "227.9 mln km",
                moons: "2",
                gravity: "3.711 m/s²",
                tiltOfAxis: "25°",
                lengthOfYear: "687 earth days",
                lengthofDay: "24h 37min",
                temperature: "Average -62.78°C"
            )
        ),
        PlanetModel(
            backgroundColor: "#D2691E",
            name: "Jupiter",
            nickName: "The Giant",
            properties: PlanetProperties(
                radius: "69,911 km",
                distanceFromSun: "778.5 mln km",
                moons: "79",
                gravity: "24.79 m/s²",
                tiltOfAxis: "3.1°",
                lengthOfYear: "11.86 earth years",
                lengthofDay: "9h 55min",
                temperature: "Average -110°C"
            )
        ),
        PlanetModel(
            backgroundColor: "#F5DEB3",
            name: "Saturn",
            nickName: "The Ringed Planet",
            properties: PlanetProperties(
                radius: "58,232 km",
                distanceFromSun: "1.43 bln km",
                moons: "82",
                gravity: "10.44 m/s²",
                tiltOfAxis: "26.73°",
                lengthOfYear: "29.46 earth years",
                lengthofDay: "10h 33min",
                temperature: "Average -140°C"
            )
        ),
        PlanetModel(
            backgroundColor: "#4682B4",
            name: "Uranus",
            nickName: "The Sideways Planet",
            properties: PlanetProperties(
                radius: "25,362 km",
                distanceFromSun: "2.87 bln km",
                moons: "27",
                gravity: "8.69 m/s²",
                tiltOfAxis: "97.77°",
                lengthOfYear: "84 earth years",
                lengthofDay: "17h 14min",
                temperature: "Average -195°C"
            )
        ),
        PlanetModel(
            backgroundColor: "#4169E1",
            name: "Neptune",
            nickName: "The Ice Giant",
            properties: PlanetProperties(
                radius: "24,622 km",
                distanceFromSun: "4.5 bln km",
                moons: "14",
                gravity: "11.15 m/s²",
                tiltOfAxis: "28.32°",
                lengthOfYear: "164.8 earth years",
                lengthofDay: "16h 6min",
                temperature: "Average -200°C"
            )
        )
    ]
}
struct PlanetProperties {
    var radius : String
    var distanceFromSun : String
    var moons : String
    var gravity : String
    var tiltOfAxis : String
    var lengthOfYear : String
    var lengthofDay : String
    var temperature : String
}


class SelectedPlanet : ObservableObject {
    @Published var selectePlanet = 0
}
