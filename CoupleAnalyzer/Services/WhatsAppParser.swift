import Foundation

// MARK: - WhatsApp Chat Parser
class WhatsAppParser {
    
    // MARK: - Parse WhatsApp Export
    static func parseWhatsAppExport(_ content: String) -> [ChatMessage] {
        let lines = content.components(separatedBy: .newlines)
        var messages: [ChatMessage] = []
        
        for line in lines {
            if let message = parseLine(line) {
                messages.append(message)
            }
        }
        
        return messages.sorted { $0.timestamp < $1.timestamp }
    }
    
    // MARK: - Private Helper Methods
    private static func parseLine(_ line: String) -> ChatMessage? {
        // WhatsApp format: [DD.MM.YYYY HH:MM:SS] Sender: Message
        let pattern = "^\\[([0-9]{1,2}\\.{1}[0-9]{1,2}\\.{1}[0-9]{4})\\s([0-9]{1,2}:[0-9]{2}:[0-9]{2})\\]\\s(.+?):\\s(.+)$"
        
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return nil
        }
        
        let range = NSRange(location: 0, length: line.utf16.count)
        guard let match = regex.firstMatch(in: line, options: [], range: range) else {
            return nil
        }
        
        // Tarih ve saat bilgilerini çıkar
        guard let dateRange = Range(match.range(at: 1), in: line),
              let timeRange = Range(match.range(at: 2), in: line),
              let senderRange = Range(match.range(at: 3), in: line),
              let messageRange = Range(match.range(at: 4), in: line) else {
            return nil
        }
        
        let dateString = String(line[dateRange])
        let timeString = String(line[timeRange])
        let sender = String(line[senderRange])
        let message = String(line[messageRange])
        
        // Tarih oluştur
        guard let timestamp = createTimestamp(dateString: dateString, timeString: timeString) else {
            return nil
        }
        
        // Sistem mesajı kontrolü
        let isSystemMessage = sender.isEmpty || 
                              message.hasPrefix("Messages and calls are end-to-end encrypted") ||
                              message.hasPrefix("‎Mesajlar ve aramalar uçtan uca şifrelidir") ||
                              message.hasPrefix("‎görüntü dahil edilmedi") ||
                              message.hasPrefix("‎video dahil edilmedi") ||
                              message.hasPrefix("‎belge dahil edilmedi") ||
                              message.hasPrefix("‎Çıkartma dahil edilmedi") ||
                              message.hasPrefix("‎Konum:") ||
                              message.hasPrefix("‎Cevapsız görüntülü arama") ||
                              message.hasPrefix("‎Görüntülü arama")
        
        return ChatMessage(
            timestamp: timestamp,
            sender: sender,
            content: message,
            isSystemMessage: isSystemMessage
        )
    }
    
    private static func createTimestamp(dateString: String, timeString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        formatter.locale = Locale(identifier: "tr_TR")
        
        let fullDateTimeString = "\(dateString) \(timeString)"
        return formatter.date(from: fullDateTimeString)
    }
}

// MARK: - Mock Data Generator
class MockDataGenerator {
    
    static func generateMockMessages() -> [ChatMessage] {
        var messages: [ChatMessage] = []
        let calendar = Calendar.current
        let now = Date()
        
        // Son 3 ay boyunca mock mesajlar oluştur
        for dayOffset in 0..<90 {
            guard let date = calendar.date(byAdding: .day, value: -dayOffset, to: now) else { continue }
            
            let messagesPerDay = Int.random(in: 5...50)
            let startHour = Int.random(in: 8...22)
            
            for messageIndex in 0..<messagesPerDay {
                let hour = startHour + (messageIndex / 5)
                let minute = Int.random(in: 0...59)
                
                guard let messageTime = calendar.date(bySettingHour: hour % 24, minute: minute, second: 0, of: date) else { continue }
                
                let sender = messageIndex % 2 == 0 ? "Ayşe" : "Mehmet"
                let content = generateRandomMessage(sender: sender, messageIndex: messageIndex)
                
                messages.append(ChatMessage(
                    timestamp: messageTime,
                    sender: sender,
                    content: content,
                    isSystemMessage: false
                ))
            }
        }
        
        return messages.sorted { $0.timestamp < $1.timestamp }
    }
    
    private static func generateRandomMessage(sender: String, messageIndex: Int) -> String {
        let loveMessages = [
            "Aşkım nasılsın? ❤️",
            "Canım seni çok seviyorum 💕",
            "Bebeğim ne yapıyorsun? 😘",
            "Tatlım iyi geceler 💖",
            "Sevgilim günaydın 🌹",
            "Hayatım seni özledim 😍",
            "Kalbim seninle 💗",
            "Meleğim nasıl geçti günün? 🥰"
        ]
        
        let casualMessages = [
            "Napıyorsun?",
            "Ne yapıyorsun?",
            "Nasılsın?",
            "İyi misin?",
            "Neredesin?",
            "Ne zaman geleceksin?",
            "Yemek yedin mi?",
            "Çalışıyor musun?",
            "Evde misin?",
            "Dışarıda mısın?"
        ]
        
        let funnyMessages = [
            "Hahaha çok komik 😂",
            "Gülmekten öldüm 🤣",
            "Çok eğlenceli 😆",
            "Harika! 😄",
            "Süper! 😃",
            "Mükemmel! 😁",
            "Çok güzel! 😊",
            "Harika bir fikir! 😅"
        ]
        
        let goodNightMessages = [
            "İyi geceler tatlım 💤",
            "Tatlı rüyalar 🌙",
            "İyi geceler canım 😴",
            "Geceler güzel olsun 💫",
            "İyi geceler sevgilim 🌟"
        ]
        
        let goodMorningMessages = [
            "Günaydın aşkım ☀️",
            "İyi sabahlar canım 🌅",
            "Günaydın bebeğim 🌞",
            "Sabah şerifler tatlım 🌸",
            "Günaydın sevgilim 🌺"
        ]
        
        // Mesaj türünü belirle
        let messageType = Int.random(in: 0...100)
        
        switch messageType {
        case 0...20:
            return loveMessages.randomElement() ?? "Aşkım ❤️"
        case 21...60:
            return casualMessages.randomElement() ?? "Merhaba"
        case 61...80:
            return funnyMessages.randomElement() ?? "Haha 😂"
        case 81...90:
            return goodNightMessages.randomElement() ?? "İyi geceler"
        case 91...100:
            return goodMorningMessages.randomElement() ?? "Günaydın"
        default:
            return "Merhaba"
        }
    }
}
