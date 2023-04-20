import Foundation
import FirebaseFirestore

extension FirestoreAPI {
    
    func createPost(post: Post, completion: ((Error?, String?) -> Void)?) {
        let docRef = db.collection(postCollectionName).document()
        let documentId = docRef.documentID
        post.id = documentId
        docRef.setData(post.dictionary ?? [:]) { (error) in
            completion?(error, documentId)
        }
    }
    
    func editPost(post: Post, completion: ((Error?) -> Void)?) {
        guard let id = post.id else { return }
        let docRef = db.collection(postCollectionName).document(id)
        if let encoded = try? Firestore.Encoder().encode(post) {
            docRef.updateData(encoded) { (error) in
                completion?(error)
            }
        }
    }
    
    func getPosts(usersIds: [String] = [], completion: (([Post], Error?) -> Void)?) {
        var results = [Post]()
        var query: Query!
        
        query = usersIds.isEmpty
        ? db.collection(postCollectionName)
            .whereField(Constants.Firebase.isDeletedFieldName, isEqualTo: false)
            .order(by: Constants.Firebase.updatedAtFieldName, descending: true)
        : db.collection(postCollectionName)
            .whereField(Constants.Firebase.userIdFieldName, in: usersIds)
            .whereField(Constants.Firebase.isDeletedFieldName, isEqualTo: false)
            .order(by: Constants.Firebase.updatedAtFieldName, descending: true)
        
        query.getDocuments { (snapshot, error) in
            if let snapshot = snapshot {
                if !snapshot.isEmpty {
                    snapshot.documents.forEach({ document in
                        do {
                            let post = try document.data(as: Post.self)
                            post.id = document.documentID
                            results.append(post)
                        } catch {
                            completion?(results, error)
                            return
                        }
                    })
                }
            }
            completion?(results, error)
        }
    }
    
    //	temp for update all posts
    //	func updatePostIds(posts: [Post]) {
    //		for post in posts {
    //			FirestoreAPI.shared.editPost(post: post, completion: nil)
    //		}
    //	}
    //
    //    temp for creating a few posts
//    func createSeveralPosts(count: Int) {
//        var i = 0
//        while i < count {
//            var post = Post(firstImage: ImageWithStatus.init(imageUrl: "https://firebasestorage.googleapis.com/v0/b/platformdev-d2b53.appspot.com/o/123.png?alt=media&token=c84c575b-daae-4d3b-be09-8d487032d0ee",
//                                                             isFromCamera: false),
//                            secondImage: nil,
//                            thirdImage: nil,
//                            title: "my TEST POST #\(i)",
//                            description: "Description for my TEST POST #\(i)",
//                            isForSale: true,
//                            price: 1,
//                            shippingPrice: 1,
//                            userId: AccountManager.shared.userId ?? "",
//                            interestCodes: [],
//                            saleStatus:  nil)
//            FirestoreAPI.shared.createPost(post: post) { error, _ in
//                if let error {
//                    print(error.localizedDescription)
//                }
//            }
//            i += 1
//        }
//    }
    
    func getPostById(postId: String, completion: ((Post?, Error?) -> Void)?) {
        let docRef = db.collection(postCollectionName).document(postId)
        docRef.getDocument { snapshot, error in
            if let post = try? snapshot?.data(as: Post.self) {
                post.id = postId
                completion?(post, error)
                return
            }
            completion?(nil, error)
        }
    }
}
