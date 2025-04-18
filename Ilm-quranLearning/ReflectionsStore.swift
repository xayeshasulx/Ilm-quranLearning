//
//  ReflectionsStore.swift
//  Ilm-quranLearning
//
//  Created by Ayesha Suleman on 17/04/2025.
//
// File: ReflectionsStore.swift
// 

import Foundation
import FirebaseFirestore
import FirebaseAuth

struct Reflection: Identifiable, Hashable {
    var id: String
    var title: String
    var body: String
    var timestamp: Date
    var sourceText: String? = nil
}


final class ReflectionsStore: ObservableObject {
    @Published var reflections: [Reflection] = []
    private let db = Firestore.firestore()

    init() {
        fetchReflections()
    }

    func save(_ reflection: Reflection, completion: @escaping (Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("❌ User not authenticated")
            completion(false)
            return
        }

        var data: [String: Any] = [
            "title": reflection.title,
            "body": reflection.body,
            "timestamp": reflection.timestamp,
            "uid": uid
        ]

        if let source = reflection.sourceText {
            data["sourceText"] = source
        }

        db.collection("reflections").document(reflection.id).setData(data) { error in
            if let error = error {
                print("🔥 Error saving reflection:", error.localizedDescription)
                completion(false)
            } else {
                self.fetchReflections()
                completion(true)
            }
        }
    }
    
    func delete(_ reflection: Reflection, completion: ((Bool) -> Void)? = nil) {
        db.collection("reflections").document(reflection.id).delete { error in
            if let error = error {
                print("🔥 Error deleting reflection:", error.localizedDescription)
                completion?(false)
            } else {
                DispatchQueue.main.async {
                    self.reflections.removeAll { $0.id == reflection.id }
                }
                completion?(true)
            }
        }
    }


    func fetchReflections() {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("❌ User not authenticated")
            return
        }

        db.collection("reflections")
            .whereField("uid", isEqualTo: uid)
            .order(by: "timestamp", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("🔥 Error fetching reflections:", error.localizedDescription)
                    return
                }

                guard let documents = snapshot?.documents else { return }

                DispatchQueue.main.async {
                    self.reflections = documents.compactMap { doc in
                        let data = doc.data()
                        guard let title = data["title"] as? String,
                              let body = data["body"] as? String,
                              let timestamp = data["timestamp"] as? Timestamp else {
                            return nil
                        }

                        return Reflection(
                            id: doc.documentID,
                            title: title,
                            body: body,
                            timestamp: timestamp.dateValue(),
                            sourceText: data["sourceText"] as? String
                        )
                    }
                }
            }
    }
}
