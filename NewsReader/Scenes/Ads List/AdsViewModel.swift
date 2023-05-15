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
            case .activityIndicator: return "activityIndicator"
            case .ad(let ad): return ad.identity
            }
        }
    }
    
    let ads: Driver<[AdsSection]>
    let nextPageLoadingTrigger = PublishRelay<Void>()
    
    private let service: AdsServiceType
    
    init(
        service: AdsServiceType
    ) {
        self.service = service
        var offset = 0
        ads = nextPageLoadingTrigger
            .startWith(())
            .flatMap {
                service
                    .getAds(offset: offset, limit: 10)
            }
            .do(onNext: { _ in
                offset += 10
            })
            .map { ads in
                return [
                    AdsSection(
                        identity: UUID().uuidString,
                        items: ads.map(AdListItem.ad)
                    )
                ]
            }
            .asDriver(onErrorJustReturn: [])
            .scan([], accumulator: +)
            .startWith([AdsSection(identity: UUID().uuidString, items: [.activityIndicator])])
            
    }
    
}
