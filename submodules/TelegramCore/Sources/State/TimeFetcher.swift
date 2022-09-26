import Foundation
import SwiftSignalKit

private struct Time : Codable {
    let timezone: String
    let unixtime: Int
}

public final class TimeFetcher {
    
    public func currentDateTime(timezoneName: String = TimeZone.current.identifier) -> Signal<Date, NoError> {
        return Signal { subscriber in
            let url = URL(string: "http://worldtimeapi.org/api/timezone/" + timezoneName)!

            let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
                if let data = data, let time = try? JSONDecoder().decode(Time.self, from: data) {
                    subscriber.putNext(Date(timeIntervalSince1970: TimeInterval(time.unixtime)))
                } else {
                    subscriber.putCompletion()
                }
            }
            
            task.resume()
            return EmptyDisposable
        }
    }
}
