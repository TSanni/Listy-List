//
//  ContentView.swift
//  Listy List
//
//  Created by Tomas Sanni on 7/24/22.
//

import SwiftUI
import ChameleonFramework



struct ContentView: View {
    @AppStorage("hexColorStorage") var hexColorStorage = UIColor.gray.hexValue()
    @State private var showAddCategoryAlert = false
    @State private var showPinnedSection = false
    @State private var showSettingsScreen = false
    
    @State private var searchText = ""
    @State private var rectangleFill = Color(hue: 0.728, saturation: 0.022, brightness: 0.376, opacity: 0.2)
    @State private var pinCount = 0

    
    @Environment(\.managedObjectContext) private var moc
    
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.time, order: .reverse)
    ]) var cateogry: FetchedResults<Cateogries>
    
    var body: some View {
        NavigationView {
            VStack {
                Button("Add") {
                    let addedCategory1 = Cateogries(context: moc)
                    addedCategory1.name = "Vacation"
                    addedCategory1.time = Date.now
                    addedCategory1.pinned = true
                    
                    let addedCategory2 = Cateogries(context: moc)
                    addedCategory2.name = "Shopping"
                    addedCategory2.time = Date.now
                    addedCategory2.pinned = true
                    
                    
                    let addedCategory3 = Cateogries(context: moc)
                    addedCategory3.name = "Devices"
                    addedCategory3.time = Date.now
                    
                    let addedCategory4 = Cateogries(context: moc)
                    addedCategory4.name = "Games"
                    addedCategory4.time = Date.now
                    
                    showPinnedSection = true
                    pinCount = 2
                }
                
                
                
                List {
                    //MARK: -Pinned section
                    if showPinnedSection == true && pinCount > 0 {
                        
                        Section("Pinned") {
                            ForEach(filteredCategories) { singleCategory in
                                if singleCategory.wrappedPinned {
                                    
                                    
                                    NavigationLink {
                                        ItemView(passedCategory: singleCategory, colorTheme: $hexColorStorage)
                                    } label: {
                                        
                                            Text(singleCategory.wrappedName)
                                                .padding(10)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .fill(rectangleFill)
                                                        .overlay(
                                                            Text(singleCategory.wrappedName)
                                                                .foregroundColor(Color(ContrastColorOf(backgroundColor: UIColor(hexString: hexColorStorage), returnFlat: true)))
                                                        )
                                                )
                                        
                                    }
                                    .listRowBackground(Color(uiColor: HexColor(hexString: hexColorStorage)))
                                    //unpin category
                                    .swipeActions(edge: .leading , allowsFullSwipe: true, content: {
                                        Button {
                                            singleCategory.pinned = false
                                            pinCount -= 1
                                        } label: {
                                            Label("Unpin", systemImage: "pin.slash.fill")
                                        }
                                        .tint(.orange)
                                        
                                    })
                                    //delete category
                                    .swipeActions(edge: .trailing , allowsFullSwipe: true, content: {
                                        Button {
                                            moc.delete(singleCategory)
                                            pinCount -= 1
                                        } label: {
                                            Label("Delete", systemImage: "trash")
                                        }
                                        .tint(.red)
                                        
                                    })
                                }
                                
                            }
                            
                        }
                        //                    .onDelete(perform: deleteCategory)
                    }
                    
                    
                    
                    //MARK: - Category Section
                    Section("Categories") {
                        ForEach(filteredCategories, id: \.wrappedTime) { singleCategory in
                            if !singleCategory.wrappedPinned {
                                NavigationLink {
                                    ItemView(passedCategory: singleCategory, colorTheme: $hexColorStorage)
                                } label: {
                                    
                                    Text(singleCategory.wrappedName)
                                        .padding(10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(rectangleFill)
                                                .overlay(
                                                    Text(singleCategory.wrappedName)
//                                                        .foregroundColor(.white)
                                                        .foregroundColor(Color(ContrastColorOf(backgroundColor: UIColor(hexString: hexColorStorage), returnFlat: true)))
                                                )
                                        )
                                    
                                    
                                }
                                .listRowBackground(Color(uiColor: HexColor(hexString: hexColorStorage)))
                                .swipeActions(edge: .leading , allowsFullSwipe: true, content: {
                                    Button {
                                        singleCategory.pinned = true
                                        showPinnedSection = true
                                        pinCount += 1
                                    } label: {
                                        Label("Pin", systemImage: "pin.fill")
                                    }
                                    .tint(.yellow)
                                    
                                })
                                .swipeActions(edge: .trailing , allowsFullSwipe: true, content: {
                                    Button {
                                        moc.delete(singleCategory)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                    .tint(.red)
                                    
                                })
                                
                            }
                            
                        }
//                        .onDelete(perform: deleteCategory(at:))
                    }
                }
                .alert(isPresented: $showAddCategoryAlert, TextAlert(title: "Add a category", message: "", action: { result in
                    addCategoryFromAlert(result: result)
                }))
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showAddCategoryAlert = true
                        } label: {
                            Image(systemName: "plus")
                                .foregroundColor(Color(uiColor: HexColor(hexString: hexColorStorage)))
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            showSettingsScreen = true
                        } label: {
                            Image(systemName: "gear")
                                .foregroundColor(Color(uiColor: HexColor(hexString: hexColorStorage)))
                        }
                    }
                }
            }
            .navigationTitle("Listy List")
        }
//        .navigationViewStyle(.stack)
        .sheet(isPresented: $showSettingsScreen, content: {
            SettingsView(colorChange: $hexColorStorage)
        })
        .searchable(text: $searchText)
        .environment(\.defaultMinListRowHeight, 100)
    }
    
    
    func addCategoryFromAlert(result: String?) {
        if let text = result {
            if text != "" && text.replacingOccurrences(of: " ", with: "") != "" {
                print("Add category string works")
                let addedCategory = Cateogries(context: moc)
                addedCategory.name = text
                addedCategory.time = Date.now
                addedCategory.pinned = false
                
                //                try? moc.save()
            }
        }
    }
    
    func deleteCategory(at offset: IndexSet) {
        for entry in offset {
            
            withAnimation {
                let chosenForDeletion = cateogry[entry]
                moc.delete(chosenForDeletion)
                
                //                try? moc.save()
            }
        }
    }
    
    var filteredCategories: [Cateogries] {
        if searchText.isEmpty {
            return cateogry.compactMap { cat in
                cat
            }
//            return cateogry.compactMap{ $0 }
        } else {
            return cateogry.compactMap { $0 }.filter { cat in
                cat.wrappedName.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
