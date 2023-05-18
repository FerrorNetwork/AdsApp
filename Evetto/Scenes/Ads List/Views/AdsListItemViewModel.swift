//
//  AdsListItemViewModel.swift
//  NewsReader
//
//  Created by avocoder on 24.01.2023.
//

import Foundation
import Differentiator

struct AdsListItemViewModel: Hashable, IdentifiableType {
    
    var identity: String {
        id.uuidString
    }
    
    let id: UUID
    let title: String
    let location: String?
    let price: String
    let date: String
    let imageURL: URL?
    
    init(
        ad: Ad,
        formatDate: (Date) -> String,
        formatPrice: (Double) -> String?
    ) {
        id = ad.id
        title = ad.title
        imageURL = ad.previewImageURL
        
        if let location = ad.location {
            var formattedLocation = location.area
            if let district = location.district {
                formattedLocation += ", " + district
            }
            self.location = formattedLocation
        } else {
            location = nil
        }
        
        self.date = formatDate(ad.createdAt)
        
        if let price = ad.price {
            self.price = (formatPrice(price.amount) ?? "\(price.amount)") + " " + price.currency.rawValue
        } else {
            price = "Цена не указана"
        }
    }
}
