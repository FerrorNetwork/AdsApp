import Foundation
import RxSwift
import RxCocoa
import RxDataSources

extension Ad: IdentifiableType, Equatable {
    static func == (lhs: Ad, rhs: Ad) -> Bool {
        lhs.title == rhs.title
    }
    
    var identity: some Hashable {
        title
    }
}

struct AdsSection {
    let identity: String
    var items: [Ad]
}

extension AdsSection: AnimatableSectionModelType {
    init(original: AdsSection, items: [Ad]) {
        self = original
        self.items = items
    }
}

final class AdsViewModel {
    
    let headlines: Driver<[AdsSection]>
    
    private let service: AdsServiceType
    
    init(
        service: AdsServiceType
    ) {
        self.service = service
        headlines = service
            .getTopHeadlines()
            .map { ads in
                return [
                    AdsSection(
                        identity: UUID().uuidString,
                        items: ads
                    )
                ]
            }
            .asDriver(onErrorJustReturn: [])
    }
    
}
