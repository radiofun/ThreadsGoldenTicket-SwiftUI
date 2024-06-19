//
//  WaveTest.swift
//  Rotation3DTest
//
//  Created by Minsang Choi on 6/7/24.
//

import SwiftUI
import Wave

struct WaveTest: View {
    
    @State var progress: CGFloat = 0
    @State var targetvalue: CGFloat = 0

    
    let progressAnimator = SpringAnimator<CGFloat>(
        spring: .init(dampingRatio: 0.6, response: 0.6),
        value: 0,
        target: 1
    )
    
    

    var body: some View {
        Circle()
            .offset(y:progress)
            .frame(width:200,height:200)
            .overlay(
                LinearGradient(gradient: /*@START_MENU_TOKEN@*/Gradient(colors: [Color.red, Color.blue])/*@END_MENU_TOKEN@*/, startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/).blendMode(.screen)
            )
            .clipped()
            .onTapGesture {
                guard let target = progressAnimator.target else { return }
                progressAnimator.target = (target == 0) ? 1 : 0
                progressAnimator.start()
                progressAnimator.valueChanged = { v in
                    self.progress = v*200
                }
                

            }
        
    }
}

#Preview {
    WaveTest()
}
