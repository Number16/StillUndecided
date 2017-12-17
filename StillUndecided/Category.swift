//
//  Category.swift
//  StillUndecided
//
//  Created by Igor on 17/12/2017.
//  Copyright © 2017 Anonim. All rights reserved.
//

import Foundation


struct CategoryData: Codable {
    var CategoryName: String?
    var CategoryIcon: String?
    
    func convertToDictionary() -> [String : Any] {
        let dic: [String: Any] = ["CategoryName":self.CategoryName, "CategoryIcon":self.CategoryIcon]
        return dic
    }
    
    init(CategoryName: String?, CategoryIcon: String?) {
        self.CategoryName = CategoryName
        self.CategoryIcon = CategoryIcon
        
    }
    
    init() {
        self.CategoryName = nil
        self.CategoryIcon = nil
    }
}


class Category {
    var CategoryName: String?
    var CategoryIcon: String?
    
    init ()
    {
        
    }
    
    init (CategoryName: String?)
    {
        self.CategoryName = CategoryName
        
        switch (CategoryName)
        {
        case "Airport"?:
            self.CategoryIcon = "airport_icon_white"
        case "Album"?:
            self.CategoryIcon = "album_icon_white"
        case "Book"?:
            self.CategoryIcon = "book_icon_white"
        case "Cafe"?:
            self.CategoryIcon = "cafe_icon_white"
        case "Camera"?:
            self.CategoryIcon = "camera_icon_white"
        case "Company"?:
            self.CategoryIcon = "company_icon_white"
        case "Hotel"?:
            self.CategoryIcon = "hotel_icon_white"
        case "Laptop"?:
            self.CategoryIcon = "laptop_icon_white"
        case "Store"?:
            self.CategoryIcon = "store_icon_white"
        case "Movie"?:
            self.CategoryIcon = "movie_icon_white"
        case "Operator"?:
            self.CategoryIcon = "operator_icon_white"
        case "Restaurant"?:
            self.CategoryIcon = "restaurant_icon_white"
        case "TV Show"?:
            self.CategoryIcon = "show_icon_white"
        case "Smartphone"?:
            self.CategoryIcon = "smartphone_icon_white"
        case "Song"?:
            self.CategoryIcon = "song_icon_white"
        case "TV"?:
            self.CategoryIcon = "tv_icon_white"
        case "Videogame"?:
            self.CategoryIcon = "videogame_icon_white"
        case "Website"?:
            self.CategoryIcon = "website_icon_white"
            
        default:
          self.CategoryIcon = nil
        }
    }
    func setIcon()
    {
        
    }
    
}
