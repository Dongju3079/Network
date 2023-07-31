import UIKit

enum NetworkError: Error {
    case networkingError
    case dataError
    case parseError
}


class Networking {
    
    static let shared = Networking()
    
    private init() {}
    
    typealias Networkcompletion = (Result<[Music], NetworkError>) -> Void
    
    
    func fetchMusic(searchTerm: String, completionHandler: @escaping Networkcompletion) {
        let urlString = "\(Network.url)\(Network.keyword)&term=\(searchTerm)"
        
        performRequest(with: urlString) { completionHandler($0) }
    }
    
    func performRequest(with urlString: String, completionHandler: @escaping Networkcompletion) {
        
        guard let url = URL(string: urlString) else { return }
        
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: url) { data, url, error in
            
            if error != nil {
                print(error!)
                completionHandler(.failure(.networkingError))
                return
            }
            
            guard let safeData = data else {
                completionHandler(.failure(.dataError))
                return
            }
            
            // 메서드 실행해서, 결과를 받음
            if let musics = self.parseJSON(safeData) {
                print("Parse 실행")
                completionHandler(.success(musics))
            } else {
                print("Parse 실패")
                completionHandler(.failure(.parseError))
            }
        }.resume()
    }
    
    func parseJSON(_ musicData: Data) -> [Music]? {
        do {
            // 우리가 만들어 놓은 구조체(클래스 등)로 변환하는 객체와 메서드
            // (JSON 데이터 ====> MusicData 구조체)
            let musicData = try JSONDecoder().decode(MusicData.self, from: musicData)
            return musicData.results
        // 실패
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
}
