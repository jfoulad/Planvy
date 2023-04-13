//
//  AutoComplete.swift
//  Planvy
//
//  Created by Jeremy Fouladian on 4/8/23.
//

import Foundation


struct Autocomplete: Decodable {
    
    //YELP GOES TERMS BUSINESSES CATEGORIES
    let categories: Array<CategoriesAutocomplete>
    let businesses: Array<BusinessesAutoComplete>
    let terms: Array<Term>
}
