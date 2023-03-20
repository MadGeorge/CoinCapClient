import Foundation

func asyncOnMain(after: TimeInterval? = nil, job: @escaping VoidBlock) {
    guard let time = after else {
        DispatchQueue.main.async(execute: job)
        return
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + time, execute: job)
}

extension DispatchQueue {
    static let background = DispatchQueue(label: "foodrocket.default", qos: .default)
}
