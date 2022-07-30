//
//  InAppPurchases.swift
//  Listy List
//
//  Created by Tomas Sanni on 7/29/22.
//

import Foundation
import StoreKit
import SwiftUI

class Payment: NSObject, ObservableObject, SKPaymentTransactionObserver {
    let productID = "com.sannideveloper.ListyList.PremiumColors"
    @Published var disableRestoreButton = false
    
    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
        
        //whenever user launches app, checks to see
        //if user has already purchased
        if isPurchased() {
            showPremiumColors()
        }
    }
    
    
    //MARK: - In-App Purchase
    func buyPremiumQuotes() {
        if SKPaymentQueue.canMakePayments() { //returns bool saying whether user can make payments
            //Can make payments
            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = productID
            SKPaymentQueue.default().add(paymentRequest)
        } else {
            //Can't make payments
            
        }
    }
    
    
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            if transaction.transactionState == .purchased {
                //User payment successful
                print("Transaction successful")
                
                showPremiumColors()
                
                
                SKPaymentQueue.default().finishTransaction(transaction)
                
            } else if transaction.transactionState == .failed {
                //Payment failed
                
                if let error = transaction.error {
                    let errorDescription = error.localizedDescription
                    print("Transaction failed due to error \(errorDescription)")
                }
                
                SKPaymentQueue.default().finishTransaction(transaction)


            } else if transaction.transactionState == .restored {
                showPremiumColors()
                disableRestoreButton = true
                print("Transaction restored")
                
                SKPaymentQueue.default().finishTransaction(transaction)
            }
        }
    }
    
    
    
    func showPremiumColors() {
        UserDefaults.standard.set(true, forKey: productID)

        hexColors.append(contentsOf: premiumHexColors)
    }
    
    
    
    func isPurchased() -> Bool {
        let purchaseStatus = UserDefaults.standard.bool(forKey: productID)
        
        if purchaseStatus {
            print("Previously purchased")
            return true
        } else {
            print("Never purchased")
            return false
        }
    }
    
    @Published var hexColors: [String] = [
        K.defaultHexColors.gray,
        K.defaultHexColors.blue,
        K.defaultHexColors.purple,
        K.defaultHexColors.red,
        K.defaultHexColors.yellow

        
//        UIColor.gray.hexValue(),
//        UIColor.blue.hexValue(),
//        UIColor.purple.hexValue(),
//        UIColor.red.hexValue(),
//        "#FCCB00" // yellow
    ]
    
    let premiumHexColors: [String] = [
        K.ColorHexConstantsPremium.lightBlue,
        K.ColorHexConstantsPremium.orange,
        K.ColorHexConstantsPremium.lightPurple,
        K.ColorHexConstantsPremium.lightGreen,
        K.ColorHexConstantsPremium.floral,
        K.ColorHexConstantsPremium.navyBlue,
        K.ColorHexConstantsPremium.gold,
    ]
    
    
}
