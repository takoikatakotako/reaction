import SwiftUI
import Combine

class ReactionMechanismRepository {
    func fetchMechanisms() -> AnyPublisher<[ReactionMechanism], Error> {
        let url = URL(string: "https://chemist.swiswiswift.com/resource/reactions.json")!
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .tryMap { try JSONDecoder().decode([ReactionMechanism].self, from: $0.data) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func fetchMechanisms() async throws -> [ReactionMechanism]  {
        
        URLCache.shared.removeAllCachedResponses()

        
        let url = URL(string: "https://chemist.swiswiswift.com/resource/reactions.json")!
        let (data, _) = try await URLSession.shared.data(from: url)
        
        print(String(data: data, encoding: .utf8)!)
        
        return try JSONDecoder().decode([ReactionMechanism].self, from: data)
    }
}
