//
//  HotSpotModel.swift
//  Planvy
//
//  Created by Jeremy Fouladian on 4/2/23.
//

import Foundation

//yelp api singleton
class YelpApiModel {
    let COUNT = 10
    let API_KEY = "Bearer I4d9M5UiS8Czv-TqUO3ny_1KfSW7tIXQSJlmRBH3uG6qn--LxWFOg469fHhFX7LrMTRil66nS_XZiFdzBJE9ut6dsPdVWVhb557TDwHUCqIPvr6AU7vjcl9MZDcpZHYx"
    let CLIENT_ID = "zMYM37CDpXG-moc3ATBy4Q"
    let BASE_URL_SEARCH = "https://api.yelp.com/v3/businesses/search?"
    let BASE_URL_ID = "https://api.yelp.com/v3/businesses/"
    let BASE_URL_AUTOCOMPLETE = "https://api.yelp.com/v3/autocomplete?"
    var businessesArray: Array<Business> = Array()
    var city: String?
    var latitude: String?
    var longitude: String?
    
    
    
    static let shared = YelpApiModel()
        
    //call Yelp API to load business in category near location
    func getBusinessesForTerm(term: String, onSuccess: @escaping (Array<Business>) -> Void) {
        
        var urlString = ""
        let termNoSpaces = term.replacingOccurrences(of: " ", with: "_")
        
        if let city {
            let cityNoSpaces = city.replacingOccurrences(of: " ", with: "")
            urlString = "\(BASE_URL_SEARCH)location=\(cityNoSpaces)&term=\(termNoSpaces)&limit=\(COUNT)"
        } else {
            if let latitude, let longitude {
                urlString = "\(BASE_URL_SEARCH)latitude=\(latitude)&longitude=\(longitude)&term=\(termNoSpaces)&limit=\(COUNT)&radius=5000"
            }
        }
        
        let url = URL(string: urlString)!
        
        var request = URLRequest(url: url)
        
        request.setValue(API_KEY, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request, completionHandler: { (data, respnse, error) in

            
            if let data = data {
                do {
                    
                    let businesses = try JSONDecoder().decode(Businesses.self, from: data)
                    let businessArray = businesses.businesses
                    onSuccess(businessArray)
                    
                } catch {
                    print(error)
                    exit(1)
                }
            }
        }).resume()
    }
    
    
    //get more specific business data given ID
    func getBusiness(businessID: String, onSuccess: @escaping (SpecificBusiness) -> Void, onFail: @escaping (Error) -> Void) {

        let url = URL(string: "\(BASE_URL_ID)\(businessID)")!
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 2
        
        request.setValue(API_KEY, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request, completionHandler: { (data, respnse, error) in
            
            
            if let data = data {
                do {
                    
                    let business = try JSONDecoder().decode(SpecificBusiness.self, from: data)
                    onSuccess(business)
                } catch {
                    onFail(error)
                    print(error)
                }
            }
        }).resume()
    }
    
    //get autocomplete given search criteria
    func autocomplete(term: String, onSuccess: @escaping (Autocomplete) -> Void) {
//        let locationNoSpaces = location.replacingOccurrences(of: " ", with: "")
//
//        let termNoSpaces = term.replacingOccurrences(of: " ", with: "")
//        let url = URL(string: "\(BASE_URL_AUTOCOMPLETE)location=\(locationNoSpaces)&text=\(termNoSpaces)")!
//        print("\(BASE_URL_AUTOCOMPLETE)location=\(locationNoSpaces)&text=\(termNoSpaces)")
        
        var urlString = ""
        let termNoSpaces = term.replacingOccurrences(of: " ", with: "_")

        if let city {
            let cityNoSpaces = city.replacingOccurrences(of: " ", with: "")
            urlString = "\(BASE_URL_AUTOCOMPLETE)location=\(cityNoSpaces)&text=\(termNoSpaces)"
        } else {
            if let latitude, let longitude {
                urlString = "\(BASE_URL_AUTOCOMPLETE)latitude=\(latitude)&longitude=\(longitude)&text=\(termNoSpaces)"
            }
        }
        
        let url = URL(string: urlString)!
        
        var request = URLRequest(url: url)
        
        request.setValue(API_KEY, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request, completionHandler: { (data, respnse, error) in
            
            
            if let data = data {
                do {
                    
                    let terms = try JSONDecoder().decode(Autocomplete.self, from: data)
                    onSuccess(terms)
                } catch {
                    print(error)
                    exit(1)
                }
            }
        }).resume()
        
    }
}
