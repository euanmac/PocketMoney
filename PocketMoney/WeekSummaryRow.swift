//
//  ThisWeekView.swift
//  PocketMoney
//
//  Created by Euan Macfarlane on 05/09/2019.
//  Copyright © 2019 Euan Macfarlane. All rights reserved.
//

import SwiftUI

struct WeekSummaryRow: View {
    @EnvironmentObject var user: User
 
    
    private let weekIndex: Int
   
    private var weekDate: String {
        get {
            let df = DateFormatter()
            df.dateFormat = "dd MMM"
            return df.string(from: week.startDate)
        }
    }
    
    private var weekStartDay: String {
        get {
               let df = DateFormatter()
               df.dateFormat = "dd "
               return df.string(from: week.startDate)
        }
    }
    
    private var weekMonth: String {
        get {
                   let df = DateFormatter()
                   df.dateFormat = "MMM"
                   return df.string(from: week.startDate)
            }
    }
    
    private var week: Week {
        get {
            return user.userWeeks[weekIndex]
        }
    }
    
    init(weekIndex: Int) {
        self.weekIndex = weekIndex
//        self.week = user.userWeeks[weekIndex]
//        df.dateFormat = "dd MMM"
//        weekDate = df.string(from: week.startDate)
//        df.dateFormat = "dd"
//        weekStartDay = df.string(from: week.startDate)
//        df.dateFormat = "MMM"
//        weekMonth = df.string(from: week.startDate)
//
    }
    
    var body: some View {

        HStack {
            VStack {
                Text(self.weekStartDay)
                    .font(.subheadline)
                    .foregroundColor(.red)
                Text(self.weekMonth)
                    .font(.subheadline)
                    .foregroundColor(.black)
            }
            VStack {
                Text("Tasks")
                Text(String(week.tasks.count))
            }
            VStack {
                 Text("Completed")
                 Text(String(week.tasks.count))
             }
            VStack {
                Text("Earned")
                Text(String(week.earned.displayCurrency()))
            }
            Text(String(user.userWeeks[weekIndex].isComplete))
            Spacer()
            WeekStatusButton(isComplete: $user.userWeeks[weekIndex].isComplete)
        }
        .padding(5)
        .font(.caption)
    }
    
    func completeWeek() {
        print("Complete")
    }


}

struct ThisWeekView_Previews: PreviewProvider {
    
    static var previews: some View {
        let dm = DataManager()
        let user = User(dataManager: DataManager())
        user.userDetails = dm.userDetails
        user.userTasks = dm.tasks
        user.userWeeks = dm.weeks
        
        return WeekSummaryRow(weekIndex: 0).environmentObject(user)
    }
}
