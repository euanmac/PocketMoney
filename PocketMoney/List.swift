//
//  List.swift
//  PocketMoney
//
//  Created by Euan Macfarlane on 16/09/2019.
//  Copyright © 2019 Euan Macfarlane. All rights reserved.
//

import SwiftUI


struct EditableList: View {
    @State var isEditMode: EditMode = .active
    
    @State var sampleData = [("Hello",5.0), ("This is a row",3.0), ("So is this",0.5)]
    @State var sampleDouble: [Double] = [5.0, 3.0, 0.4]
    
    private var currencyFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.isLenient = true
        f.numberStyle = .currency
        return f
    } ()
    
    var body: some View {
        NavigationView {
//            List(sampleData, id: \.self) { rowValue in
//                if (self.isEditMode == .active) {
//                    Text("now is edit mode")
//                } else  {
//                    Text(rowValue)
//                }
            List {
                ForEach(sampleData.indices) {(index) in
                    HStack {
                        TextField("test", text: self.$sampleData[index].0)
                        //TextField("test 2hh", text: Binding(get: {return String(describing: self.sampleData[index].1)}, set: {self.sampleData[index].1 = Decimal(string: $0) ?? 0}))
                        
                        //TextField("test", text: Binding<String>(get: {return String(describing: self.$sampleData[index].1)}, set: {$sampleData[index].1 = Decimal(string: $0) ?? 0}))
                        TextField("Amount", value: self.$sampleDouble[index], formatter: self.currencyFormatter)
                    }
                }.onMove {(indexSet, index) in
                    self.sampleData.move(fromOffsets: indexSet, toOffset: index)}
                Text(sampleData.reduce(""){$0 + $1.0})
                Text(String(describing:sampleDouble.reduce(0){$0 + $1}))
            }
            
            .navigationBarTitle(Text("Edit A Table?"), displayMode: .inline)
            .navigationBarItems(trailing: EditButton())
            .environment(\.editMode, self.$isEditMode)
        }
    }
}

struct EditableList_Previews: PreviewProvider {
    static var previews: some View {
        EditableList()
    }
}
