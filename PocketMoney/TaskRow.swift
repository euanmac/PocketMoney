//
//  TaskRow.swift
//  PocketMoney
//
//  Created by Euan Macfarlane on 03/09/2019.
//  Copyright © 2019 Euan Macfarlane. All rights reserved.
//

import SwiftUI

struct TaskRow: View {
    var task: ScheduledTask
    @State var checked = true
    var body: some View {
        HStack {
            Text(task.description)
            Text(task.value.displayCurrency())
            Spacer()
            TaskStatusButton(isComplete: $checked)
        }
    }
}

struct TaskRow_Previews: PreviewProvider {
    static var previews: some View {
        
        TaskRow(task: ScheduledTask(id: UUID(), task: UserTask(id: UUID(), description: "Wash Up", mandatory: false, value: 4.0), completed: false))
    }
}
