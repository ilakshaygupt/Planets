//
//  InwardCurvedShape.swift
//  Planets
//
//  Created by Lakshay Gupta on 27/11/24.
//
import SwiftUI


struct InwardCurvedShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        let width = getScreenBounds().width
        let height = getScreenBounds().height * 0.5


        path.move(to: CGPoint(x: 0, y: height))


        path.addLine(to: CGPoint(x: 0, y: height - 400))


        path.addQuadCurve(
            to: CGPoint(x: width, y: height - 400),
            control: CGPoint(x: width / 2, y: height * 0.45)
        )


        path.addLine(to: CGPoint(x: width, y: height))


        path.addLine(to: CGPoint(x: 0, y: height))


        path.closeSubpath()

        return path
    }
}
