import Foundation
import CoreData

struct SampleDataSeeder {
    static func seedIfNeeded() {
        let context = CoreDataManager.shared.context
        let request = User.fetchRequest()
        let userCount = (try? context.count(for: request)) ?? 0
        if userCount > 0 { return }

        UserService.createUser(email: "alice@example.com", nickname: "Alice", password: "pass123")
        UserService.createUser(email: "bob@example.com", nickname: "Bob", password: "pass123")
        UserService.createUser(email: "carol@example.com", nickname: "Carol", password: "pass123")

        func addFriend(owner: String, nickname: String, status: String, isAlly: Bool = false) {
            let friend = Friend(context: context)
            friend.id = UUID()
            friend.owner = owner
            friend.nickname = nickname
            friend.status = status
            friend.isAlly = isAlly
        }

        addFriend(owner: "Alice", nickname: "Bob", status: "accepted", isAlly: true)
        addFriend(owner: "Bob", nickname: "Alice", status: "accepted")
        addFriend(owner: "Bob", nickname: "Carol", status: "accepted")
        addFriend(owner: "Carol", nickname: "Bob", status: "accepted")
        addFriend(owner: "Alice", nickname: "Carol", status: "pending")

        try? context.save()

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dates = [Date().addingTimeInterval(-172800), Date().addingTimeInterval(-86400)]

        for date in dates {
            let dateStr = formatter.string(from: date)
            FirestoreService.shared.saveDailyChallengeResult(
                date: dateStr,
                userNickname: "Alice",
                steps: 10000,
                stand: 12,
                calories: 600,
                userChallengeMet: true,
                allyNickname: "Bob",
                allySteps: 9500,
                allyStand: 11,
                allyCalories: 580,
                allyChallengeMet: true
            )
            FirestoreService.shared.saveDailyChallengeResult(
                date: dateStr,
                userNickname: "Bob",
                steps: 9500,
                stand: 11,
                calories: 580,
                userChallengeMet: true,
                allyNickname: "Alice",
                allySteps: 10000,
                allyStand: 12,
                allyCalories: 600,
                allyChallengeMet: true
            )
        }
    }
}
