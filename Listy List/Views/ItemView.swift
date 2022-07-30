//
//  ItemView.swift
//  Listy List
//
//  Created by Tomas Sanni on 7/24/22.
//

import SwiftUI
import ChameleonFramework

struct ItemView: View {
    @ObservedObject var passedCategory: Cateogries
    @Environment(\.managedObjectContext) private var moc
    
    
    @State private var isShowingAddItemAlert = false
    @State private var searchText = ""
    @Binding var colorTheme: String
    @State private var makeUpReflectCoreDataBooleanChange = false
    
    var body: some View {
//        VStack {
//            Button("add") {
//                let item = Item(context: moc)
//                item.origin = passedCategory
//                item.name = "a"
//                item.time = Date.now
//                item.completed = false
//                
//                let item2 = Item(context: moc)
//                item2.origin = passedCategory
//                item2.name = "b"
//                item2.time = Date.now
//                item2.completed = false
//                
//                let item3 = Item(context: moc)
//                item3.origin = passedCategory
//                item3.name = "c"
//                item3.time = Date.now
//                item3.completed = false
//                
//                let item4 = Item(context: moc)
//                item4.origin = passedCategory
//                item4.name = "d"
//                item4.time = Date.now
//                item4.completed = false
//                
//                let item5 = Item(context: moc)
//                item5.origin = passedCategory
//                item5.name = "e"
//                item5.time = Date.now
//                item5.completed = false
//                
//                let item6 = Item(context: moc)
//                item6.origin = passedCategory
//                item6.name = "f"
//                item6.time = Date.now
//                item6.completed = false
//                
//                
//                let item7 = Item(context: moc)
//                item7.origin = passedCategory
//                item7.name = "g"
//                item7.time = Date.now
//                item7.completed = true
//            }
            
            
            
            List {
                
                //MARK: - Completed (checked) Items
                Section("Completed Items") {
                    ForEach(filteredItems, id: \.wrappedItemTime) { item in
                        if item.wrappedCompletedItem {
                            HStack {
                                Text(item.wrappedItemName)
                                    .foregroundColor(Color(ContrastColorOf(backgroundColor: UIColor(hexString: colorTheme), returnFlat: true)))
                                Spacer()
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(Color.green)
                            }
                            .listRowBackground(Color(HexColor(hexString: colorTheme)))
                            //mark item as finished
                            .swipeActions(edge: .leading, allowsFullSwipe: true, content: {
                                Button {
                                    item.completed.toggle()
                                    makeUpReflectCoreDataBooleanChange.toggle()
                                } label: {
                                    Label("Not finished yet", systemImage: "arrow.down.app.fill")
                                }
                                .tint(Color.gray)
                            })
                            //delete item
                            .swipeActions(edge: .trailing, allowsFullSwipe: true, content: {
                                Button {
                                    moc.delete(item)
                                    //save it
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                                .tint(Color.red)
                            })
                            .onTapGesture {
                                item.completed.toggle()
                                makeUpReflectCoreDataBooleanChange.toggle()
                            }
                        }
                    }
                }
                
                //MARK: - All other items
                Section("Items") {
                    ForEach(filteredItems, id: \.wrappedItemTime) { item in
                        if !item.wrappedCompletedItem {

                            HStack {
                                Text(item.wrappedItemName)
                                    .foregroundColor(makeUpReflectCoreDataBooleanChange ? Color(ContrastColorOf(backgroundColor: UIColor(hexString: colorTheme), returnFlat: true)) : Color(ContrastColorOf(backgroundColor: UIColor(hexString: colorTheme), returnFlat: true)))
        //                        Spacer()
        //                        Image(systemName: "checkmark.circle.fill")
                            }
                            //mark item as finished
                            .swipeActions(edge: .leading, allowsFullSwipe: true, content: {
                                Button {
                                    item.completed.toggle()
                                    makeUpReflectCoreDataBooleanChange.toggle()
                                } label: {
                                    Label("Finished", systemImage: "checkmark.circle.fill")
                                }
                                .tint(Color(hue: 0.343, saturation: 0.97, brightness: 0.427))
                            })
                            //delete item
                            .swipeActions(edge: .trailing, allowsFullSwipe: true, content: {
                                Button {
                                    moc.delete(item)
                                    //save it
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                                .tint(Color.red)
                            })

                            
                            .listRowBackground(Color(HexColor(hexString: colorTheme)))
                            .onTapGesture {
                                item.completed.toggle()
                                makeUpReflectCoreDataBooleanChange.toggle()
                            }
                        }

                    }
                    .onDelete(perform: deleteItem)
                }
            }
            .alert(isPresented: $isShowingAddItemAlert, TextAlert(title: "Add an Item", message: "", action: { result in
                addItemFromAlert(result: result)
            }))
            .navigationTitle(passedCategory.wrappedName)
//        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    isShowingAddItemAlert = true
                } label: {
                    Image(systemName: "plus")
                        .foregroundColor(Color(HexColor(hexString: colorTheme)))
                }
            }
        }
        .searchable(text: $searchText)
    }
    
    
    func addItemFromAlert(result: String?) {
        if let text = result {
            if text != "" && text.replacingOccurrences(of: " ", with: "") != "" {
                print("Add item string works")
                let item = Item(context: moc)
                item.origin = passedCategory
                item.name = text
                item.time = Date.now
                item.completed = false
                
//                try? moc.save()
            }
        }
    }
    
    
    func deleteItem(at offsets: IndexSet) {
        withAnimation {
            for itemToDelete in offsets {
                let item = passedCategory.itemArray[itemToDelete]
                moc.delete(item)
//                try? moc.save()
            }
        }
    }
    
    var filteredItems: [Item] {
        if searchText.isEmpty {
            return passedCategory.itemArray
            
            //code below breaks the delete function for some reason
//            return passedCategory.itemArray.sorted { a, b in
//                a.wrappedItemTime > b.wrappedItemTime
//            }
        } else {
            return passedCategory.itemArray.filter { itemLine in
                itemLine.wrappedItemName.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    

}

//struct ItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            ItemView(test: mockDataStruct.example)
//        }
//    }
//}
