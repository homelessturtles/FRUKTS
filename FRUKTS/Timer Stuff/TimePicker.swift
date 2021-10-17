//
//  TimePicker.swift
//  FRUKTS
//
//  Created by Brian Fedelin on 5/30/21.
//

import SwiftUI

struct TimePicker: View {
    @State var selectedDate: Date = Date()
    
    var dateformatter: DateFormatter{
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
    
    var body: some View {
        VStack{
            DatePicker("Select a Time",
                       selection: $selectedDate,
                       displayedComponents: [.hourAndMinute])
            //Text(startTimer(date: Date()).date.description)
           // Text(dateformatter.string(from: selectedDate))
            startTimer(selectedDate: $selectedDate)
        }
    }
}

struct TimePicker_Previews: PreviewProvider {
    static var previews: some View {
        TimePicker()
    }
}
