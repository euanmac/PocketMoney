//
//  WeekDetail.swift
//  PocketMoney
//
//  Created by Euan Macfarlane on 08/09/2019.
//  Copyright © 2019 Euan Macfarlane. All rights reserved.
//

import SwiftUI

struct WeekDetail: View {
    @EnvironmentObject var user: User
    let weekId: Int
    
    func taskIndex(task: ScheduledTask) -> Int {
        return user.userWeeks[weekId].tasks.firstIndex(where: { $0.id == task.id })!
    }
    
    func taskDescription(task: ScheduledTask) -> Text {
        var description = task.description
        if task.mandatory {
            return Text(description).bold()
        } else {
            description += "(\(task.value))"
            return Text(description)
        }
    }
    
    var body: some View {
        List(user.userWeeks[0].tasks.indices) { index in
            HStack {
                //self.taskDescription(task: user.userWeeks[0].tasks[index])
                Spacer()
                //TaskStatus(status: $user.userWeeks[0].tasks[index].completed)
                //TaskStatus(status: .constant(.complete))
                //WeekStatusButton(isComplete: true)
            }
        }
    }
}

struct WeekDetail_Previews: PreviewProvider {
    static var previews: some View {
        let dm = DataManager()
        let user = User(dataManager: DataManager())
        user.userDetails = dm.userDetails
        user.userTasks = dm.tasks
        user.userWeeks = dm.weeks
         
        return WeekDetail(weekId: user.userWeeks[0].id).environmentObject(user)
        
    }
}
