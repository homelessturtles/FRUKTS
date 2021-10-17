//
//  AlarmSetView.swift
//  FRUKTS
//
//  Created by Brian Fedelin on 6/7/21.
//

import SwiftUI

struct AlarmSetView: View {
    @State var isToggled: Bool = true
    
    var body: some View {
        ZStack{
            VStack{
                Text("My \nAlarm ")
                    .font(.largeTitle)
                    .bold()
                    .frame(width: 300, alignment: .topLeading)
                    .padding()
                Spacer()
                RoundedRectangle(cornerRadius: 25.0, style: RoundedCornerStyle.circular)
                    .fill(Color(#colorLiteral(red: 0.3759861887, green: 0.4126484692, blue: 0.542275548, alpha: 1)))
                    .frame(width: 400, height: 150, alignment: .topLeading)
                    .padding(.top, -700)
            }
            RoundedRectangle(cornerRadius: 25.0, style: RoundedCornerStyle.circular)
                .opacity(0.1)
                .frame(width: 200, height: 100, alignment: .topLeading)
                .padding(.trailing, 140)
                .padding(.bottom, 400)
            Text(TimePicker().dateformatter.string(from: TimePicker().selectedDate))
                .font(.largeTitle)
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
                .padding(.bottom, 400)
                .padding(.trailing, 140)
            Toggle("Alarm", isOn: $isToggled).labelsHidden()
                .toggleStyle(SwitchToggleStyle(tint: Color.lightGray))
                .padding(.bottom, 270)
                .padding(.leading, 150)
                .scaleEffect(1.5)
        
                
        }
    }
}

struct AlarmSetView_Previews: PreviewProvider {
    static var previews: some View {
        AlarmSetView()
    }
}
