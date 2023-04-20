import FirebaseAuth

extension FirestoreAPI {
	
	func saveUserData(user: CHUser, completion: ((Error?) -> Void)?) {
        let docRef = db.collection(Constants.Firebase.usersCollectionName).document("\(user.id)")
		
		docRef.setData(user.dictionary ?? [:], completion: completion)
	}
	
	func getUserData(userId: String, completion: ((CHUser?, Error?) -> Void)?) {
		let docRef = db.collection(Constants.Firebase.usersCollectionName).document("\(userId)")
		
		docRef.getDocument { snapshot, error in
			if let user = try? snapshot?.data(as: CHUser.self) {
				if userId == Auth.auth().currentUser?.uid {
					AccountManager.shared.currentUser = user
//					MixpanelManager.shared.setUserProperties(user: user)
				}
				completion?(user, error)
				return
			}
			completion?(nil, error)
		}
	}
    
	func getUserByIds(ids: [String], completion: (([CHUser], Error?) -> Void)?) {
        let docRef = db.collection(Constants.Firebase.usersCollectionName).whereField(Constants.Firebase.idFieldName, in: ids)
        docRef.getDocuments { snapshot, error in
            var results = [CHUser]()
            snapshot?.documents.forEach({ document in
                do {
                    let user = try document.data(as: CHUser.self)
                    results.append(user)
                } catch {
                    completion?(results, error)
                    return
                }
            })
            completion?(results, error)
        }
    }
	
	func getAllUsers(completion: (([CHUser]?, Error?) -> Void)?) {
		let docRef = db.collection(Constants.Firebase.usersCollectionName)
		docRef.getDocuments { snapshot, error in
			var results = [CHUser]()
			snapshot?.documents.forEach({ document in
				do {
					let user = try document.data(as: CHUser.self)
					results.append(user)
				} catch {
					completion?(nil, error)
					return
				}
			})
			completion?(results, error)
		}
	}
	
	func getInterests(completion: ((InterestResponse?, Error?) -> Void)?) {
        let docRef = db.collection(Constants.Firebase.interestNewCollectionName).document(Constants.Firebase.interestsDocumentName)
		
		docRef.getDocument { snapshot, error in
			if let resp = try? snapshot?.data(as: InterestResponse?.self) {
				completion?(resp, error)
				return
			}
			completion?(nil, error)
		}
	}
	
//	 Need for set interest on firebase
	func setInterests(interest: InterestResponse) {
		do {
			try db.collection(Constants.Firebase.interestNewCollectionName).document(Constants.Firebase.interestsDocumentName).setData(from: interest)
		} catch {
			print(error)
		}
	}
	
    func checkUserData(localFieldText: String, userFieldName: String, completion: @escaping (Bool, Error?) -> Void) {
        let collectionRef = db.collection(Constants.Firebase.usersCollectionName)
        collectionRef.whereField(userFieldName, isEqualTo: localFieldText).getDocuments { (snapshot, err) in
            if let err = err {
                completion(false, err)
            } else if (snapshot?.isEmpty)! {
                completion(false, err)
            } else {
                for document in (snapshot?.documents)! where document.data()[userFieldName] != nil {
                    completion(true, err)
                }
            }
        }
    }
}
