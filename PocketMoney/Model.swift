//
//  Model.swift
//  PocketMoney
//
//  Created by Euan Macfarlane on 01/09/2019.
//  Copyright © 2019 Euan Macfarlane. All rights reserved.
//

import Foundation
import Combine


struct UserDetails {
    var firstName: String {
        willSet(name) {
            print(name)
        }
    }
    var familyName: String
    var base: Double
    
}

struct UserTask: Identifiable {
    let id: UUID
    let description: String
    let mandatory: Bool
    let value: Decimal
}

struct ScheduledTask: Identifiable {
    
    let id: UUID
    var completed: Bool
    let description: String
    let mandatory: Bool
    let value: Decimal

    init(id: UUID, task: UserTask, completed: Bool) {
        
        self.id = id
        self.description = task.description
        self.mandatory = task.mandatory
        self.value = task.value
        self.completed = completed
    }
    
}

struct Week : Identifiable {

    let number: Int
    let year: Int
    let base: Decimal
    let id: Int
    var isComplete: Bool
    
    var tasks: [ScheduledTask]
    private var earnedBase: Decimal
    private var earnedExtra: Decimal
    
    init (number: Int, year: Int, base: Decimal, isComplete: Bool, tasks: [ScheduledTask]) {
        self.number = number
        self.year = year
        self.base = base
        self.tasks = tasks
        self.isComplete = isComplete
        self.id = Int(String(self.year) + String(self.number))!

        
        //Calculations - earned base is 0 unless all mandatory task are completed
        earnedBase = (tasks.reduce(true) {$0 && ($1.mandatory ? $1.completed : true)}) ? self.base : 0.0
        
        //Calcation - earned non mandatory
        earnedExtra = tasks.reduce(0) {$0 + (!$1.mandatory && $1.completed ? $1.value : 0.0)}
        print(earnedExtra)
    }
    
    var startDate: Date {
        get {
            let dc = DateComponents(calendar: Calendar.current, weekOfYear: number, yearForWeekOfYear: self.year)
            return Calendar.current.date(from: dc)!
        }
    }
    
    var endDate: Date {
        get {
            return Calendar.current.date(byAdding: .day, value: 6, to: startDate)!
        }
    }
    
    var earned: Decimal {
        return earnedBase + earnedExtra
    }
}

extension Week : CustomStringConvertible {
    var description: String {
        get {
            var output = "ID: \(String(self.id))"
            self.tasks.forEach() {
                task in
                    output += "\(task.description) : \(task.completed) \n"
            }
            return output
        }
    }
}


class DataManager {
    static let taskIds = [UUID(),UUID(),UUID(),UUID()]
    
    let userDetailsPub = PassthroughSubject<UserDetails, Never>()
    let userTasksPub = PassthroughSubject<[UserTask], Never>()
    let userWeeksPub = PassthroughSubject<[Week], Never>()
    
    var userDetails: UserDetails
    var weeks: [Week]
    var tasks: [UserTask]
    
    init() {
        userDetails = UserDetails(firstName: "Will", familyName: "Macfarlane", base: 3)
        
        tasks = [
            UserTask(id: DataManager.taskIds[0], description: "Empty dishwasher", mandatory: true, value: 0),
            UserTask(id: DataManager.taskIds[1], description: "Make bed", mandatory: false, value: 2),
            UserTask(id: DataManager.taskIds[2], description: "Clear plates", mandatory: true, value: 3),
            UserTask(id: DataManager.taskIds[3], description: "Clean car", mandatory: true, value: 4)
        ]
        
        weeks = [
            Week(number: 34, year: 2019, base: 3, isComplete: false, tasks: [
                ScheduledTask(id: UUID(), task: tasks[0], completed: true),
                ScheduledTask(id: UUID(), task: tasks[1], completed: true),
                ScheduledTask(id: UUID(), task: tasks[2], completed: true)
            ]),
            Week(number: 35, year: 2019, base: 2.5, isComplete: false, tasks: [
                ScheduledTask(id: UUID(), task: tasks[1], completed: true),
                ScheduledTask(id: UUID(), task: tasks[2], completed: true),
                ScheduledTask(id: UUID(), task: tasks[3], completed: false)
            ])
        ]
    }
    
    func loadUserDetails() {
 
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 0) {
            
           DispatchQueue.main.async {
                self.userDetailsPub.send(self.userDetails)
            }
        }
    }
    
    func loadTasks() {
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 0) {
            DispatchQueue.main.async {
                self.userTasksPub.send(self.tasks)
            }
        }
    }
    
    func loadWeeks(tasks: [UserTask]) {
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 0) {
            DispatchQueue.main.async {
                self.userWeeksPub.send(self.weeks)
            }
        }

    }
}

class User : ObservableObject {
    
    let dm: DataManager
    
    @Published var userWeeks = [Week]()
    @Published var userDetails: UserDetails?
    @Published var userTasks = [UserTask]()
    var userDataSub: AnyCancellable?
    var userWeeksSub: AnyCancellable?
    

    
    init(dataManager: DataManager) {
        self.dm = dataManager
    }
    
    func loadData() {
        dm.loadUserDetails()
        dm.loadTasks()
      
        userDataSub = dm.userDetailsPub.combineLatest(dm.userTasksPub).sink() { userData in
                self.userDetails = userData.0
                self.userTasks = userData.1
                print("User Tasks: \(self.userTasks.count)")
                print("User Details: \(self.userDetails!.firstName)")
                self.dm.loadWeeks(tasks: self.userTasks)
        }
        
        userWeeksSub = dm.userWeeksPub.assign(to: \.userWeeks, on: self)
    }
    
    func getWeek(for date: Date) -> Week? {
        return userWeeks.first() { week in
            return (date >= week.startDate &&
                    date <= week.endDate)
        }
    }
}

public extension Decimal {
    func displayCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "EN-gb")
        return formatter.string(for: self)!
    }
}

public extension Double {
    func displayCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "EN-gb")
        return formatter.string(for: self)!
    }
}
