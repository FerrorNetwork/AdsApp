
import Foundation

struct DependencyContainer {
    
    func getAdsService() throws -> AdsServiceType {
        return AdsService()
    }
}
