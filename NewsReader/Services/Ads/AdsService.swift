import Foundation
import RxSwift
import Fakery

protocol AdsServiceType {
    func getAds(
        offset: Int,
        limit: Int
    ) -> Observable<[Ad]>
}

final class AdsService: AdsServiceType {
    
    func getAds(offset: Int, limit: Int) -> Observable<[Ad]> {
        let request = URLRequest(url: URL(string: "https://api.escuelajs.co/api/v1/products?offset=\(offset)&limit=\(limit)")!)
 
        return URLSession.shared
            .rx
            .data(request: request)
            .map { data in
                try! JSONDecoder().decode([Ad].self, from: data)
            }
    }
    
}
