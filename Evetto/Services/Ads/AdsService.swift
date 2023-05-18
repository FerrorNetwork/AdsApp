import Foundation
import RxSwift
import Fakery

protocol AdsServiceType {
    func getAdsList(
        page: Int,
        limit: Int
    ) -> Single<[Ad]>
    
    func getAdDetails(_ id: UUID) -> Single<Ad>
}

final class AdsService: AdsServiceType {
    
    func getAdsList(
        page: Int,
        limit: Int
    ) -> Single<[Ad]> {
        assert(Thread.isMainThread)
        let request = URLRequest(
            url: URL(string: "https://api.evetto.app/v1/ads?page=\(page)&per=\(limit)")!
        )
        
        struct Response: Decodable {
            let data: [Ad]
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        return URLSession.shared
            .rx
            .data(request: request)
            .map { data in
                try! decoder.decode(Response.self, from: data)
            }
            .map(\.data)
            .asSingle()
    }
    
    func getAdDetails(_ id: UUID) -> Single<Ad> {
        assert(Thread.isMainThread)
        let request = URLRequest(
            url: URL(string: "https://api.evetto.app/v1/ads/\(id.uuidString)")!
        )
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        return URLSession.shared
            .rx
            .data(request: request)
            .map { data in
                try! decoder.decode(Ad.self, from: data)
            }
            .asSingle()
    }
    
}
