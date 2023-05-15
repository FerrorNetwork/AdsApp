import Foundation
import RxSwift
import Fakery

protocol AdsServiceType {
    func getTopHeadlines() -> Observable<[Ad]>
}

final class AdsService: AdsServiceType {
    
    func getTopHeadlines() -> Observable<[Ad]> {
        let request = URLRequest(url: URL(string: "https://fakestoreapi.com/products")!)
 
        return URLSession.shared
            .rx
            .data(request: request)
            .map { data in
                try! JSONDecoder().decode([Ad].self, from: data)
            }
    }
    
}
