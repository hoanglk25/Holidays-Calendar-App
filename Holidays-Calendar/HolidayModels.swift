//
//  HolidayModels.swift
//  Holidays-Calendar
//
//  Created by Hoàng Đức on 13/11/2022.
//

import Foundation

struct HolidayDetail:Decodable {
    var name: String
    var date: DateInfo
}

struct DateInfo: Decodable {
    var iso: String
}

struct Holidays:Decodable {
    var holidays:[HolidayDetail]
}

struct HolidaysResponse:Decodable {
    var response:Holidays
}
