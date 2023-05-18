//
//  DependencyContainer.swift
//  NewsReader
//
//  Created by avocoder on 21.01.2023.
//

import Foundation

struct AppContext {
    let adsService: AdsServiceType = AdsService()
}

let appContext = AppContext()

struct DependencyContainer {
    
    func getAdsService() throws -> AdsServiceType {
        return AdsService()
    }
    
}
