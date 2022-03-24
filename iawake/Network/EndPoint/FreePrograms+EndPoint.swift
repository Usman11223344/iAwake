
import Foundation

extension APIEndPoint {
    
    enum FreePrograms {
        case programs
        
        var endPoint: Endpoint {
            
            switch self {
            case .programs:
                return APIEndPoint.init(method: .get, resourcePath: "programs/free", parameters: nil, version: .v1)
            }
        }
    }
    
}
