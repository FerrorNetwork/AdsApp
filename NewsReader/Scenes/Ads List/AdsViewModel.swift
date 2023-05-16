import Foundation
import RxSwift
import RxCocoa
import RxDataSources



struct AdsSection {
    let identity: String
    var items: [AdsViewModel.AdListItem]
}

extension AdsSection: AnimatableSectionModelType {
    init(original: AdsSection, items: [AdsViewModel.AdListItem]) {
        self = original
        self.items = items
    }
}

final class AdsViewModel {
    
    enum AdListItem: IdentifiableType, Equatable {
        case activityIndicator
        case ad(Ad)
        
        var identity: String {
            switch self {
            case .activityIndicator: return UUID().uuidString
            case .ad(let ad): return ad.identity
            }
        }
    }
    
    
    let ads: Driver<[AdsSection]>
    let nextPageLoadingTrigger = PublishRelay<Void>()
    let reloadingTrigger = PublishRelay<Void>()
    
    private let service: AdsServiceType
    
    init(
        service: AdsServiceType
    ) {
        self.service = service
        ads = AdsViewModel.createAdsLoader(service: service,
                                           nextPageTrigger: nextPageLoadingTrigger.asObservable(),
                                           reloadTrigger: reloadingTrigger.asObservable())
    }
    
    
    static func createAdsLoader(
        service: AdsServiceType,
        nextPageTrigger: Observable<Void>,
        reloadTrigger: Observable<Void>
    ) -> Driver<[AdsSection]> {
        var offset = 0
        
        return Observable
            .merge(
                nextPageTrigger.do(onNext: { _ in
                    offset += 10
                }),
                reloadTrigger.do(onNext: { _ in
                    offset = 0
                })
            )
            .startWith(())
            .flatMap {
                service
                    .getAds(offset: offset, limit: 10)
            }
            .map { ads in
                return [
                    AdsSection(
                        identity: UUID().uuidString,
                        items: ads.map(AdListItem.ad)
                    )
                ]
            }
            .asDriver(onErrorJustReturn: [])
            .scan([], accumulator: { old, new in
                var data: [AdsSection] = []
                if offset == 0 {
                    data = new
                } else {
                    data = old.dropLast() + new
                }
                return data + [AdsSection(identity: UUID().uuidString, items: [.activityIndicator])]
            })
            .startWith([AdsSection(identity: UUID().uuidString, items: [.activityIndicator])])
    }
}
