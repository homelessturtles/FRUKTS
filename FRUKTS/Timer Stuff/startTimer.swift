//
//  startTimer.swift
//  FRUKTS
//
//  Created by Brian Fedelin on 6/4/21.
//

import SwiftUI

struct startTimer: View {
    @State var timer: Timer?
    @State var date = Date()
    @State var isPressed: Bool = false
    @Binding var selectedDate: Date
  
    var body: some View {
        VStack{
            Button(action:{
                timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                    date = Date()
                }
                isPressed = true
            }){
                Text("Set Alarm")
            }
            if date.description == selectedDate.description && isPressed == true{
                SoundTest(isAlarm: $isPressed)
                    .onAppear(){
                        timer?.invalidate()
                    }
            }
            Text(date.description)
            Text(selectedDate.description)
        }
    }
}



struct startTimer_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
