//
//  ContentView.swift
//  Rotation3DTest
//
//  Created by Minsang Choi on 6/3/24.
//

import SwiftUI
import Wave

struct ContentView: View {
    
    @State private var angle : CGFloat = 0
    @State private var offset : CGFloat = -120
    @State private var isFlipped : Bool = false
    @State private var timer: Timer?
    @State var progress: CGFloat = 0
    @State var lastVelocity : CGFloat = 0
    @State var dimmer : CGFloat = 0
    
    let progressAnimator = SpringAnimator<CGFloat>(
        spring: .init(dampingRatio: 0, response: 30),
        value: 0,
        target: 1
    )
    
    var body: some View {
        ZStack{
            ZStack { //Card
                Color.black
                ZStack{
                    Color.white
                    Color.gray.opacity(dimmer)
                    LinearGradient(colors: [.red,.teal], startPoint: .topLeading, endPoint: .bottomTrailing)
                        .frame(width:560,height:420)
                        .offset(x:offset)
                        .blur(radius: 0)
                        .opacity(dimmer)
                        .mask(
                            HStack{
                                ForEach(0..<24){ c in
                                    VStack{
                                        ForEach(0..<32) { r in
                                            Image(systemName: "airplane.circle.fill")
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width:20,height:20)
                                                .rotation3DEffect(.degrees(-45),axis: (x: 0.0, y: 0.0, z: 1.0))
                                        }
                                    }
                                    
                                }
                            }
                        )
                    DottedLine()
                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [4, 4]))
                        .frame(height: 1)
                        .offset(y:140)
                        .foregroundColor(.black.opacity(0.5))
                        .blendMode(.luminosity)
                    Circle()
                        .fill(.white.opacity(0.7))
                        .blur(radius: 20)
                        .blendMode(.screen)
                        .frame(width:320,height:320)
                        .offset(x:0-offset)
                        .opacity(isFlipped ? 1 : 0)
                    Circle()
                        .fill(.white.opacity(0.7))
                        .blur(radius: 20)
                        .blendMode(.screen)
                        .frame(width:320,height:320)
                        .offset(x:0-offset)
                        .opacity(isFlipped ? 0 : 1)
                    ZStack{ //Airplane icon in the back
                        VStack{
                            Image(systemName: "airplane.circle.fill")
                                .resizable()
                                .frame(width:120,height:120)
                                .rotation3DEffect(.degrees(-45),axis: (x: 0.0, y: 0.0, z: 1.0))
                        }
                        .rotation3DEffect(.degrees(180),axis: /*@START_MENU_TOKEN@*/(x: 0.0, y: 1.0, z: 0.0)/*@END_MENU_TOKEN@*/)
                    }
                    .frame(width:240,height:320)
                    .opacity(isFlipped ? 1 : 0)
                    ZStack{
                        VStack{
                            Color.clear
                                .frame(height:24)
                            HStack{
                                VStack{
                                    HStack{
                                        Text("Date")
                                            .font(.caption)
                                            .bold()
                                            .padding(.leading,16)
                                            .opacity(0.5)
                                        Spacer()
                                    }
                                    HStack{
                                        Text("Sat, Jun 8")
                                            .font(.system(size: 20))
                                            .padding(.leading,16)
                                        Spacer()
                                    }
                                }
                                Image(systemName: "airplane.circle.fill")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width:48,height:48)
                                    .padding(.trailing,16)
                                    .rotation3DEffect(.degrees(-45),axis: (x: 0.0, y: 0.0, z: 1.0))
                            }
                            Color.clear
                                .frame(height:12)
                            HStack{
                                Text("Origin")
                                    .font(.caption)
                                    .bold()
                                    .padding(.leading,16)
                                    .opacity(0.5)
                                Spacer()
                            }
                            HStack{
                                Text("SFO (San Francisco)")
                                    .font(.system(size: 20))
                                    .padding(.leading,16)
                                Spacer()
                            }
                            Color.clear
                                .frame(height:12)
                            HStack{
                                Text("Destination")
                                    .font(.caption)
                                    .bold()
                                    .padding(.leading,16)
                                    .opacity(0.5)
                                Spacer()
                            }
                            HStack{
                                Text("HND (Tokyo)")
                                    .font(.system(size: 20))
                                    .padding(.leading,16)
                                Spacer()
                            }
                            Color.clear
                                .frame(height:12)
                            
                            HStack{
                                Text("Name")
                                    .font(.caption)
                                    .bold()
                                    .padding(.leading,16)
                                    .opacity(0.5)
                                Spacer()
                            }
                            HStack{
                                Text("Minsang Choi")
                                    .font(.system(size: 20))
                                    .padding(.leading,16)
                                Spacer()
                            }
                            Spacer()
                            HStack{
                                Image("profileImage")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width:36,height:36)
                                    .cornerRadius(20)
                                Text("radiofun8")
                                    .font(.caption)
                                    .bold()
                                Spacer()
                                Text("JMB00323")
                                    .font(.caption)
                                    .bold()
                            }
                            .padding(16)
                        }
                        .frame(width:300)
                    }
                    .opacity(isFlipped ? 0 : 1)
                    Circle()
                        .fill(Color.black)
                        .blendMode(.destinationOut)
                        .frame(width: 40, height: 40)
                        .offset(y:220)
                    Circle()
                        .fill(Color.black)
                        .blendMode(.destinationOut)
                        .frame(width: 40, height: 40)
                        .offset(y:-220)
                    
                }
                .compositingGroup()
                .frame(width:300,height:420)
                .cornerRadius(4)
                .clipped()
                .rotation3DEffect(.degrees(progress*360),axis: (x: 0.0, y: 1, z: 0.0))
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        guard let target = progressAnimator.target else { return }
                        
                        progressAnimator.target = (target == 0) ? 1 : 0
                        
                        progressAnimator.stop(immediately: false)
                        let travel = abs(value.translation.width)
                        let mappedValue = convertRange(value: travel, minvalue: 0, maxvalue: 60, minrange: 0, maxrange: 5,clipped: false)
                        lastVelocity = mappedValue
                        progressAnimator.velocity = lastVelocity
                        
                    }
                    .onEnded { value in
                        withAnimation(.easeInOut(duration:1)){
                            progressAnimator.velocity = (lastVelocity > 0.5) ? 0.5 : lastVelocity
                        }
                    }
            )
            HStack{
                Button("Rotate") {
                    
                    guard let target = progressAnimator.target else { return }
                    progressAnimator.target = (target == 0) ? 1 : 0
                    progressAnimator.start()
                    
                    progressAnimator.valueChanged = { value in
                        self.progress = value
                        let anchorvalue = mapValueToRange(v: value*360)
                        offset = convertRange(value: anchorvalue, minvalue: 0, maxvalue: 1, minrange: -120, maxrange: 120,clipped: false)
                        if value*360 < 90 {
                            dimmer = convertRange(value: abs(anchorvalue), minvalue: 0, maxvalue: 0.15, minrange: 0, maxrange: 0.15,clipped: false)
                        } else {
                            dimmer = 0.15
                        }
                        let angle = abs(value*360)
                        isFlipped = flipTheCard(v: angle)
                    }
                }
                .foregroundColor(.black)
                .bold()
                .frame(width:160,height:60)
                .background(.white)
                .cornerRadius(30)
                Button("Stop") {
                    progressAnimator.stop()
                }
                .foregroundColor(.black)
                .bold()
                .frame(width:160,height:60)
                .background(.white)
                .cornerRadius(30)
            }.offset(y:360)
            Text("Your Ticket")
                .font(.system(size: 16))
                .foregroundStyle(.white)
                .bold()
                .offset(y:-360)
            
        }
        .ignoresSafeArea()
    }
    
    private func flipTheCard(v: CGFloat) -> Bool {
        if v < 90 {
            return false
        } else {
            // Calculate the phase within the 180-degree intervals
            let phase = Int((v - 90) / 180) % 2
            return phase == 0
        }
    }
    
    private func mapValueToRange(v: CGFloat) -> CGFloat {
        if v < 90 {
            // Directly map 0...90 to 0...100
            return v / 90 * 1
        } else {
            // Normalize the value within the 180-degree interval
            let normalizedValue = (v - 90).truncatingRemainder(dividingBy: 180)
            return min(1.0, normalizedValue / 180 * 1)
        }
    }
    
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func convertRange(value: Double, minvalue: Double,maxvalue: Double, minrange: Double, maxrange: Double, clipped:Bool) -> Double {
        // Define input and output ranges
        let inputRange: (min: Double, max: Double) = (minvalue, maxvalue)
        let outputRange: (min: Double, max: Double) = (minrange, maxrange)
        
        // Clamp value to input range for safety
        let clampedValue = max(min(value, inputRange.max), inputRange.min)
        
        // Convert the value from the input range to the output range
        let scaledValue = outputRange.min + (clampedValue - inputRange.min) * (outputRange.max - outputRange.min) / (inputRange.max - inputRange.min)
        
        if clipped == true {
            return clampedValue
        } else {
            return scaledValue
        }
    }
}

struct DottedLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        return path
    }
}
#Preview {
    ContentView()
}
