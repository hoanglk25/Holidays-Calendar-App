//
//  HolidaysRequest.swift
//  Holidays-Calendar
//
//  Created by Hoàng Đức on 13/11/2022.
//

import Foundation
enum HolidayError:Error {
    case noDataAvailable
    case canNotProcessData
}

struct HolidayRequest {
    let resourceURL:URL
    let API_KEY = "4c33705568b7441608f81a81439105579cecc86b"
    
    init(countryCode:String) {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy"
        let currentYear = format.string(from: date)
        
        let resourceString = "https://calendarific.com/api/v2/holidays?&api_key=\(API_KEY)&country=\(countryCode)&year=\(currentYear)"
        guard let resourceURl = URL(string: resourceString ) else {fatalError()}
       self.resourceURL = resourceURl
    }
    func getHolidays (completion: @escaping(Result<[HolidayDetail], HolidayError>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: resourceURL) { data, _, _ in
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            do {
                let decoder = JSONDecoder()
                let holidaysResponse = try decoder.decode(HolidaysResponse.self, from: jsonData)
                let holidayDetails = holidaysResponse.response.holidays
                completion(.success(holidayDetails))
            } catch {
                completion(.failure(.canNotProcessData))
            }
        }
        dataTask.resume()
    }
}
