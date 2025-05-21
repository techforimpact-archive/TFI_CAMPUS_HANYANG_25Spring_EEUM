import Foundation

struct MultipartForm: Sendable {
    private typealias Form = (String, String?, Content)
    
    let boundary: String = "----\(UUID().uuidString)"
    private var forms = [Form]()
    
    subscript(index: Int) -> (String, String?, Content) {
        forms[index]
    }
    
    mutating func append(name: String, fileName: String? = nil, content: Content) {
        forms.append((name, fileName, content))
    }
    
    func build() -> (String, Data)? {
        var data = Data()
        
        for (name, fileName, content) in forms {
            data.append("--\(boundary)\r\n".data(using: .utf8)!)
            data.append(deposition(name: name, fileName: fileName))
            data.append("Content-Type: \(content)\r\n\r\n".data(using: .utf8)!)
            data.append(content.contentData)
            data.append("\r\n".data(using: .utf8)!)
        }
        data.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        return (boundary, data)
    }
    
    private func deposition(name: String, fileName: String?) -> Data {
        if let fileName {
            return "Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!
        }
        return "Content-Disposition: form-data; name=\"\(name)\"\r\n".data(using: .utf8)!
    }
}

extension MultipartForm {
    enum Content: CustomStringConvertible {
        case text(data: Data)
        case json(data: Data)
        case jpeg(data: Data)
        
        var contentData: Data {
            switch self {
            case .text(let data): return data
            case .json(let data): return data
            case .jpeg(let data): return data
            }
        }
        
        var description: String {
            switch self {
            case .text: "text/plain"
            case .json: "application/json"
            case .jpeg: "image/jpeg"
            }
        }
    }
}
