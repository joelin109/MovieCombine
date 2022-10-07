//
//  RatingView.swift
//  ReactiveMovies
//
//  Created by Joe Lin on 25/04/2020.
//  Copyright © 2020 Joe Lin. All rights reserved.
//

import SwiftUI

struct RatingView: View {
    @State var percent: Float
    
    var color: Color {
        if percent > 79 {
            return Color.exGelbDunkel
        } else if percent > 69 {
            return Color.exBlauDunkel
        } else {
            return Color.exGruen
        }
    }
    
    var animate: Bool = true
    
    var body: some View {
        ZStack {
            Circle()
                .opacity(0.8)
            
            Circle()
                .stroke(lineWidth: 3)
                .opacity(0.8)
                .foregroundColor(color)
                .modifier(RankingPercentIndicator(percent: percent, color: color))
                .padding(EdgeInsets(top: 3, leading: 3, bottom: 3, trailing: 3))
            
        }
        
        .frame(width:36, height: 36)
        .onAppear {
            guard animate else {
                return
            }
            let finalPercent = percent
            percent = 0
            withAnimation(.easeInOut(duration: 2.0)) {
                self.percent = finalPercent
            }
        }
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(percent: 91)
    }
}
