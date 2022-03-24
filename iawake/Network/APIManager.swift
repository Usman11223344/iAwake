
import Foundation

private let contentType = "application/json"

enum NetworkResult<T> {
    case success(T)
    case failure(String)
}

typealias NetworkManagerResultHandler<T: Decodable> = (NetworkResult<T>) -> Void

public class APIManager {
    internal var sessionManager: URLSession
    static let shared  = APIManager.init(sessionManager: URLSession.shared)
    weak var appRouter: AppRouter?
    
    init(sessionManager: URLSession) {
        self.sessionManager = sessionManager
    }
    
    private func dataRequest<T>(for urlRequest: URLRequest, completeOn queue: DispatchQueue, completion: @escaping (NetworkManagerResultHandler<T>)) -> Void {
        
        sessionManager.dataTask(with: urlRequest) { data, response, error in
            
            guard let httpResponse = response as? HTTPURLResponse else {
                // Response invalidation will be handled here
                completion(.failure("Invalid response"))
                return
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                guard let _data = data, let responseData = try? JSONDecoder().decode(T.self, from: _data) else {
                    // In case data is not parsed it will be handled here
                    completion(.failure("Data not parse"))
                    return
                }
                completion(.success(responseData))
                break
            default:
                // Other Failure cases will be handled here
                completion(.failure("Failed"))
                break
            }

            
        }.resume()
    }
}

// MARK: - NetworkManager Delegates
extension APIManager {
    
    func execute<T>(_ endpoint: Endpoint, completeOn queue: DispatchQueue = DispatchQueue.global(qos: .background), completion: @escaping (NetworkManagerResultHandler<T>)) -> Void {
        
        guard let apiURLRequest = endpoint.urlRequest() else {
            completion(.failure("Invalid request")) // URL Request Nil case will be handled here
            return
        }
        self.dataRequest(for: apiURLRequest, completeOn: queue, completion: completion)
    }
    
}
