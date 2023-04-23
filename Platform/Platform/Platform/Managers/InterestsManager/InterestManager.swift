import Foundation

enum SelectionState {
	case none, selected, partial
}

// Need for set interest on firebase
let demoResponse = InterestResponse(categories:
										[Category(code: "Natural", children: [
											Category(code: "Botanicals"),
											Category(code: "Minerals"),
											Category(code: "Biologicals"),
											Category(code: "Artifacts")
										]),
										 Category(code: "Art/media", children: [
											Category(code: "Sculpture"),
											Category(code: "Paper"),
											Category(code: "Magazines")
										 ]),
										 Category(code: "Toys/games", children: [
											Category(code: "Dolls"),
											Category(code: "Figurines"),
											Category(code: "Models")
										 ]),
										 Category(code: "Accessory", children: [
											Category(code: "Watches"),
											Category(code: "Sneakers"),
											Category(code: "Bags"),
											Category(code: "Pins")
										 ]),
										 Category(code: "Homeware", children: [
											Category(code: "Deskware"),
											Category(code: "Kitchenware"),
											Category(code: "Machinery"),
											Category(code: "Stationary"),
											Category(code: "Textiles")
										 ]),
										 Category(code: "Other", children: [
											Category(code: "Money"),
											Category(code: "Stamps")
										 ])
										]
)

class InterestManager {
	var interestsTree: InterestResponse?
    var customInterestsTree: InterestResponse?
	var selectedCodes = [String]()
	static let shared = InterestManager()
	
	private init() { }
	
	func stateOf(category: Category) -> SelectionState {
		guard let itemFromTree = getItemByCode(code: category.code) else { return .none }
        print(selectedCodes)
        print(itemFromTree.code)
		if selectedCodes.contains(itemFromTree.code) {
			return .selected
		}
		
		let names = itemFromTree.children?.map { $0.code } ?? []
		if !names.isEmpty, names.allSatisfy(selectedCodes.contains) {
			return .selected
		} else if selectedCodes.contains(where: names.contains) {
			return .partial
		}
		return .none
	}
	
	func switchSelection(item: Category) {
		guard let itemFromTree = getItemByCode(code: item.code) else { return }
		
		if let childrenCodes = itemFromTree.children.flatMap({ $0 })?.map({ $0.code }), !childrenCodes.isEmpty {
			
			if !childrenCodes.allSatisfy(selectedCodes.contains) {
				selectedCodes += childrenCodes
				selectedCodes = Array(Set(selectedCodes))
			} else {
				selectedCodes.removeAll(where: { childrenCodes.contains($0) })
			}
		} else {
			if let indexForRemove = selectedCodes.firstIndex(of: item.code) {
				selectedCodes.remove(at: indexForRemove)
			} else {
				selectedCodes.append(item.code)
			}
		}
	}
	
	func getItemByCode(code: String) -> Category? {
		allItemsWithChildren().first(where: { $0.code == code })
	}
	
	func allItemsWithChildren() -> [Category] {
		let tree = customInterestsTree ?? interestsTree
		var result = tree?.categories ?? []
		result += (tree?.categories ?? []).flatMap { getItemChild(item: $0) }
		return result
	}
	
	private func getItemChild(item: Category) -> [Category] {
		item.children ?? []
	}
}
