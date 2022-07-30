//
//  SettingsView.swift
//  Listy List
//
//  Created by Tomas Sanni on 7/26/22.
//

import SwiftUI
import ChameleonFramework
import StoreKit

struct SettingsView: View {
    @Binding var colorChange: String
    @State private var showColorHexName = false
    @Environment(\.dismiss) var dismiss
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 5)
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    @ObservedObject var payment = Payment()
    

    

    

    
    
    var body: some View {
        NavigationView { //need navigationview to show restore button in toolbar
            VStack(spacing: 200) {
                Text("Change the color theme.")
                    .font(.largeTitle)
                
                
                if payment.isPurchased() == false {
                    Button("Get more colors") {
                        payment.buyPremiumQuotes()
                    }
                    .buttonStyle(.borderedProminent)
                }

                
                LazyVGrid(columns: columns) {
                    ForEach(payment.hexColors, id: \.self) { color in
                        
                        Button {
                            colorChange = color
                            dismiss()
                        } label: {
                            Text(showColorHexName ? color : "")
                                .frame(width: screenWidth*0.1, height: 50)
                                .foregroundColor(.black)
                                .font(.title)
                                .background(Color(uiColor: HexColor(hexString: color)))
                                .clipShape(Capsule())
    //                            .onLongPressGesture {
    //                                print(color.description)
    //                                showColorHexName.toggle()
    //                            }
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if payment.disableRestoreButton {
                        
                    } else {
                        Button("Restore") {
                            SKPaymentQueue.default().restoreCompletedTransactions()
                        }

                    }
                }
            }
        }

    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(colorChange: .constant(UIColor.gray.hexValue()))
    }
}
