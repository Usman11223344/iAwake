
import Foundation

private let contentType = "application/json"

typealias HTTPHeaders = [String: String]

enum HTTPMethod {
    case get
    case post
    case put
    case patch
    case delete
}

typealias Path = String

protocol Parameters {
    func asData() -> Data?
    func asQueryItems() -> [URLQueryItem]?
}

extension Parameters {
    func asData() -> Data? {
        return try? JSONSerialization.data(withJSONObject: self, options: [])
    }
}

extension Dictionary: Parameters where Key == String, Value == Any {
    func asQueryItems() -> [URLQueryItem]? {
        return self.map { URLQueryItem(name: $0, value: "\($1)") }
    }
}

extension Array: Parameters {
    func asQueryItems() -> [URLQueryItem]? {
        /// Arrays cannot be converted to Query Items
        return nil
    }
}

protocol Host {
    var baseURL: URL { get }
}

struct APIHost: Host {
    var baseURL: URL

    init(baseUrl: Path) {
        self.baseURL = URL(string: baseUrl)!
    }
}

enum APIVersion: String {
    case none = ""
    case v1 = "v1"
}

protocol Endpoint {
    var path: Path { get }
    var method: HTTPMethod { get }
    var parameters: Parameters? { get }
    var headers: HTTPHeaders { get }
    var body: Data? { get }
    var host: Host { get set }
    var resourcePath: Path { get }
    var version: APIVersion { get }

    func urlRequest() -> URLRequest?
}

struct APIEndPoint: Endpoint {
    
    var method: HTTPMethod
    var parameters: Parameters?
    var headers: HTTPHeaders
    var body: Data?
    var host: Host
    var resourcePath: Path
    var version: APIVersion
    

    var path: Path {
        switch self.version {
        case .v1:
            return "/v1/" + self.resourcePath
        case .none:
            return "/" + self.resourcePath
        }
    }

    init(method: HTTPMethod = .get,
         resourcePath: Path,
         parameters: Parameters? = nil,
         headers: HTTPHeaders = [:],
         version: APIVersion = .none,
         body: Data? = nil
         ) {

        self.method = method
        self.parameters = parameters
        self.headers = headers
        self.body = body
        self.resourcePath = resourcePath
        self.version = version
        
        self.host = APIHost.init(baseUrl: "https://api.iawaketechnologies.com/api")
    }

    func urlRequest() -> URLRequest? {
        let urlRequest = URLRequest(baseURL: self.host.baseURL, endpoint: self)
        return urlRequest
    }
}

