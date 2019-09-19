//
//  UserProfile.swift
//  PocketMoney
//
//  Created by Euan Macfarlane on 12/09/2019.
//  Copyright © 2019 Euan Macfarlane. All rights reserved.
//

import SwiftUI

struct UserProfile: View {
    
    @EnvironmentObject var user: User
    @State var name: Double  = 0.0
    var mode: EditMode = .active
    @Binding var draftUser: User

   
    var currencyFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.isLenient = true
        f.numberStyle = .currency
        return f
    } ()
    
    var body: some View {
        
        get {
            List {
                Section(header: Text("User Details")) {
                    HStack {
                        Text("First Name").bold()
                        Divider()
                        TextField("First Name", text: Binding<String>(get: {return self.user.userDetails!.firstName}, set: {self.user.userDetails!.firstName = $0}))
                    }
                    HStack {
                        Text("Family Name").bold()
                        Divider()
                        TextField("Family Name", text: Binding<String>(get: {return self.user.userDetails!.familyName}, set: {self.user.userDetails!.familyName = $0}))
                    }
                    
//                    HStack {
//                        Text("Pocket Money").bold()
//                        Divider()
//                        TextField("Pocket Money", text: Binding<Double>(get: {return self.user.userDetails!.base}, set: {self.user.userDetails!.base = $0}), formatter: currencyFormatter)
//                            .keyboardType(.numberPad)
//                    }
                    
                    HStack {
                       
                        //Stepper(String(name), value: $name, in: 0...10)
                        //Stepper(String(describing: name), value: $name, in: stride(from: 0.0, to: 10.0, by: 0.5))
                        Slider(value: $name, in: 0.0...10.0, step: 0.5)
                        Text(String(name))
                        
                    }
                    
                    HStack {
                        Text("My name is \(user.userDetails!.firstName)  \(user.userDetails!.familyName). I earn \(user.userDetails!.base.displayCurrency()) a week")
                    }
                }
                
                Section(header: Text("User Tasks")) {
                    //TextField("Second Name", text: $name)

                    
                    ForEach(user.userTasks) { task in
                        Text(task.description)
                    }.onDelete(perform: deleteTask)
                    Button(action: addTask, label: {Text("Add Task")})
                    
                }
            }.environment(\.editMode, .constant(EditMode.inactive))

        }
    }
    
    func deleteTask(at offsets: IndexSet) {
        user.userTasks.remove(atOffsets: offsets)
    }
    func addTask() {
        user.userTasks.append(UserTask(id: UUID(), description: "New task", mandatory: false, value: 0.0))
    }
}

struct UserProfile_Previews: PreviewProvider {
    static var previews: some View {
        let dm = DataManager()
        var user = User(dataManager: DataManager())
        user.userDetails = dm.userDetails
        user.userTasks = dm.tasks
        user.userWeeks = dm.weeks
        return UserProfile(draftUser: .constant(user)).environmentObject(user).environment(\.editMode, .constant(EditMode.inactive))
        
    }
}
