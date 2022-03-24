
import Foundation

extension APIWorker {
 
    static func getFreePrograms(onComplete: @escaping (_ result: NetworkResult<[Program]?>) -> Void) {
        
        let endPoint = APIEndPoint.FreePrograms.programs.endPoint
        
        APIManager.shared.execute(endPoint) { (result: NetworkResult<FreePrograms>) in
            switch result {
            case .success(let data):
                onComplete(.success(data.data))
            case .failure(let errorString):
                onComplete(.failure(errorString))
            }
        }
    }
}
