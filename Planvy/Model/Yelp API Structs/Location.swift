//
//  Location.swift
//  Planvy
//
//  Created by Jeremy Fouladian on 4/2/23.
//

import Foundation
import FirebaseFirestoreSwift

//Yelp API struct
struct Location: Codable {
    let address1: String?
    let address2: String?
    let address3: String?
    let city: String?
    let zip_code: String?
    let state: String?
    let display_address: Array<String>
    
    
    //get whole address string from array
    func getFormattedAddress() -> String {
        var formattedAddress = ""
        for address in self.display_address {
            formattedAddress.append("\(address), ")
        }
        formattedAddress.remove(at: formattedAddress.index(before: formattedAddress.endIndex))
        formattedAddress.remove(at: formattedAddress.index(before: formattedAddress.endIndex))
        
        return formattedAddress
    }

}
