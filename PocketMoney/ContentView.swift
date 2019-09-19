//
//  ContentView.swift
//  PocketMoney
//
//  Created by Euan Macfarlane on 01/09/2019.
//  Copyright © 2019 Euan Macfarlane. All rights reserved.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    @EnvironmentObject var user: User
    //@State var completed = false
    var body: some View {
        Group {
            if (user.userDetails == nil) {
                HStack {
                    Text("Loading")
                }
            } else {
                NavigationView {
                    List(user.userWeeks.indices) { weekIndex in
                        WeekSummaryRow(weekIndex: weekIndex)
                    }
                    .navigationBarTitle(Text(user.userDetails!.firstName))
                }
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
  
    static var previews: some View {
        let dm = DataManager()
        let user = User(dataManager: DataManager())
        user.userDetails = dm.userDetails
        user.userTasks = dm.tasks
        user.userWeeks = dm.weeks
        return ContentView().environmentObject(user)
    }
}

//
//struct LiveView: View {
//    @EnvironmentObject private var user: User
//    var currentWeek: Week {
//        get {
//            user.getWeek(for: Date())!
//        }
//    }
//    
//    var body: some View {
////        guard let userDetails = user.userDetails else {
////            return Text("Loading...")
////        }
//        Group {
//            if (user.userDetails == nil) {
//                Text("Loading...")
//            } else {
//                NavigationView {
//                    List() {
//                        //NavigationLink(destination: WeekDetail(week: week)) {
//                            
//                        //}
//                        Section(header: Text("This Week")) {
//                            CurrentWeek(currentWeek: user.userWeeks[0])
//                        }.font(.subheadline)
//                        
//                        Section(header: Text("History")) {
//                            ForEach(user.userWeeks) {week in
//                                NavigationLink(destination: WeekDetail(week: week)) {
//                                    Text(String(week.year))
//                                    //
//                            }
//                        }.font(.subheadline)
//                
//                    }
//                    .navigationBarTitle(user.userDetails!.firstName)
//                    .listStyle(.grouped)
//                    .navigationBarItems(leading: Button("Print", action: {self.user.userWeeks.forEach({print($0)})} ))
//                }
//            }
//        }
//    }
//}
//
//struct CurrentWeek: View {
//    var currentWeek: Week?
//    
//    var body: some View {
//        Group {
//            if (currentWeek == nil) {
//                HStack {
//                    Button("Start Week", action: startWeek)
//                            //.padding()
//                            .padding(5)
//                            .background(Color.red)
//                            .foregroundColor(.white)
//                            .cornerRadius(CGFloat(10))
//                }
//            } else {
//                Group {
//                    ForEach(currentWeek!.tasks) { task in
//                        HStack {
//                            Text(task.description)
//                            //Text(String(task.displayCurrency()))
//                            //return Toggle(task.value.description, isOn: task.completed)
////                            Spacer()
//                            //CheckBox(checked: task.completed)
//                        }
//                    }
//                }
//            }
//        }
//            .font(.caption)
//    }
//    
//    func startWeek() {
//        print("Start Week")
//    }
//}
//
//struct WeekRow: View {
//    private let week: Week
//    private let weekDate: String
//    private let weekStartDay: String
//    private let weekMonth: String
//    
//    init(week: Week) {
//        self.week = week
//        let df = DateFormatter()
//        df.dateFormat = "dd MMM"
//        self.weekDate = df.string(from: week.startDate)
//        df.dateFormat = "dd"
//        weekStartDay = df.string(from: week.startDate)
//        df.dateFormat = "MMM"
//        weekMonth = df.string(from: week.startDate)
//    }
//    
//    var body: some View {
//
//        HStack {
//            VStack {
//                Text(self.weekStartDay)
//                    .font(.subheadline)
//                    .foregroundColor(.red)
//                Text(self.weekMonth)
//                    .font(.subheadline)
//                    .foregroundColor(.black)
//            }
//            VStack {
//                Text("Tasks")
//                Text(String(week.tasks.count))
//            }
//            VStack {
//                 Text("Completed")
//                 Text(String(week.tasks.count))
//             }
//            VStack {
//                Text("Earned")
//                Text(String(week.earned.displayCurrency()))
//            }
//            Spacer()
//            Button("Complete", action: completeWeek)
//            //.padding()
//            .padding(5)
//            .background(Color.green)
//            .foregroundColor(.white)
//            .cornerRadius(10)
//    
//            
//            
//        }
//        .padding(5)
//        .font(.caption)
//    }
//    
//    func completeWeek() {
//        print("Complete")
//    }
//}
//
//struct WeekDetail: View {
//    private var week: Week
//    @EnvironmentObject private var user: User
//    
//    var body: some View {
//        VStack {
////            Button("Print", action: {self.week.tasks.forEach({print($0)})} )
//            List() {
//                ForEach(week.tasks) {
//                    task in
//                        TaskRow(task: task)
//                    }
//                }
//            }
//            
//        }
//    }
//    
//}
//
//struct TaskRow: View {
// 
//    private var task: ScheduledTask
//    var body: some View {
//        HStack {
//                Text(task.description)
//                Text(String(task.displayCurrency()))
//                Spacer()
//                //CheckBox(checked: task.completed)
//            }
//        }
//}
//
//struct CheckBox: View {
//    
//    @Binding var checked: Bool
//    var body: some View {
//        //Group {
//            print("run")
//            if (checked) {
//                return Image(systemName: "checkmark.square")//.onTapGesture({self.checked.toggle()})
//            } else {
//                return Image(systemName: "square")
//                    //.onTapGesture({self.checked.toggle()})
//            }
//        //}
//        
//    }
//}
//
////struct TaskStatusButton: View {
////
////    @Binding var isComplete: Bool
////
////    var body: some View {
////        Button(action: {isComplete.toggle()}) {
////
////        }
////
////    }
////}
//
//
//extension Decimal {
//    func displayCurrency() -> String {
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .currency
//        formatter.locale = Locale(identifier: "EN-gb")
//        return formatter.string(for: self)!
//    }
//}
//
////struct ContentView : View {
////    @ObjectBinding var user: User
////
////    var body: some View {
////        Group {
////            if (user.userDetails == nil) {
////                Text("Loading...")
////            } else {
////                NavigationView {
////
////                    List() {
////                        Section(header: Text("Section 1")) {
////                            ForEach($user.userWeeks[0].tasks) {task in
////                                ExampleRow(task: task)
////                            }
////                        }
////                        Section(header: Text("Section 2")) {
////                            Text("Hello")
////                        }
////                        Section(header: Text("History")) {
////                            ForEach($user.userWeeks) {week in
////                                NavigationLink(destination: WeekDetail(week: week)) {
////                                        //WeekRow(week: week.value)
////                                        Text("\(week.value.description)")
////                                    }
////                            }
////                        }.font(.subheadline)
////                        Section(header: Text("Current Week")) {
////                            CurrentWeek(currentWeek: $user.userWeeks[0])
////                        }
////                    }
////                    .onAppear() {print("appearing")}
////                    .listStyle(.grouped)
////                    .navigationBarTitle("Test")
////                    .navigationBarItems(leading: Button("Print", action: {self.user.userWeeks[0].tasks.forEach({print($0)})} ))
////
////                }
////            }
////        }
////    }
////}
//
//struct ExampleRow: View {
//    @Binding var task : ScheduledTask
//    
//    var body: some View {
//        HStack {
//            Text(task.value.description)
//            Text(task.value.displayCurrency())
//            Text("Example Row \(String(task.completed))")
//            Spacer()
//            CheckBox(checked: $task.completed)
//        }
//    }
//}
