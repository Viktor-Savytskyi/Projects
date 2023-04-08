import UIKit

class InterestSuperCategoryView: ViewFromXib {

	@IBOutlet weak var arrowImgView: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var plusButton: UIButton!
	@IBOutlet weak var stackView: UIStackView!
	@IBOutlet weak var allSeclectedView: UIView!
	
	var superCategory: Category!
	weak var delegate: InterestChangedDelegate?
	private let interestManager = InterestManager.shared
    
    private var newCategoryView: TextFieldViewWithButtons?
    private var customCategoryView: InterestCategoryView?
    private let newCategoryNameMaxLenght = 30
    var drawInterestTreeCallBack: (() -> Void)?
    
    func setup(superCategory: Category,
               interestChangesDelegate: InterestChangedDelegate?,
               filteredCategories: [Category] = []) {
        self.superCategory = superCategory
        self.delegate = interestChangesDelegate
        nameLabel.text = superCategory.code
        arrowImgView.image = superCategory.visible ? #imageLiteral(resourceName: "arrowDown")  : #imageLiteral(resourceName: "arrow")
        let isAllSelected = interestManager.stateOf(category: superCategory) == .selected
        allSeclectedView.isHidden = !isAllSelected
        plusButton.setImage(isAllSelected
                            ? #imageLiteral(resourceName: "selectedPlus.pdf")
                            : #imageLiteral(resourceName: "plus.pdf"),
                            for: .normal)
        
        if superCategory.visible {
            let currentCategories = filteredCategories.isEmpty
            ? interestManager.interestsTree!.categories
                .filter { $0.code == superCategory.code }
                .compactMap { $0.children }
                .flatMap { $0 }
            : filteredCategories
                .filter { $0.code == superCategory.code }
                .compactMap { $0.children }
                .flatMap { $0 }
            
            currentCategories.forEach { category in
                let categoryView = InterestCategoryView()
                categoryView.setup(category: category, delegate: interestChangesDelegate) {
                    interestChangesDelegate?.selectCategory(category: category)
                } onPressed: {
                    interestChangesDelegate?.selectCategory(category: category)
                }
                stackView.addArrangedSubview(categoryView)
            }
            
            if filteredCategories.isEmpty {
                newCategoryView = TextFieldViewWithButtons()
                guard let newCategoryView else { return }
                setNewCategoryTextViewConfigurations(parentCategory: superCategory)
                
                customCategoryView = InterestCategoryView()
                guard let customCategoryView else { return }
                customCategoryView.plusButton.alpha = 0
                
                customCategoryView.setup(category: Category(code: "Custom"), delegate: interestChangesDelegate) {
                    // when tap on plus button //  -- plus button has 0 alpha
                } onPressed: {
                    customCategoryView.isHidden.toggle()
                    newCategoryView.isHidden.toggle()
                }
                
                stackView.addArrangedSubview(customCategoryView)
                stackView.addArrangedSubview(newCategoryView)
            }
        }
    }
    
    private func setNewCategoryTextViewConfigurations(parentCategory: Category) {
        guard let newCategoryView else { return }
        newCategoryView.isHidden = true
        newCategoryView.textFieldView.textField.placeholder = "{LIVE TEXT}"
        newCategoryView.buttonsDelegate = self
        newCategoryView.textFieldView.textField.delegate = self
        newCategoryView.textFieldView.textField.addPermanentSymbolOnLeft(leftViewWidth: 15)
        newCategoryView.textFieldView.textField.addTarget(self, action: #selector(newCategoryTextFieldDidChange), for: .editingChanged)
        newCategoryView.textFieldView.textField.returnKeyType = .done
        newCategoryView.textFieldView.errorText = nil
        newCategoryView.parentCategory = parentCategory
        newCategoryView.isUserInteractionEnabled = true
        newCategoryView.setButton.isEnabled = false
		//		Fix bug with showing error label
		newCategoryView.textFieldView.errorLabel.translatesAutoresizingMaskIntoConstraints = false
		newCategoryView.textFieldView.errorLabel.heightAnchor.constraint(equalToConstant: 13).isActive = true
    }
    
	private func isNewCategoryValid(newCategoryName: String) -> Bool {
		let duplicatesArrayIsEmpty = interestManager
			.allItemsWithChildren()
			.filter({ $0.code.lowercased() == newCategoryName.lowercased() })
			.isEmpty
        
        if duplicatesArrayIsEmpty {
            if !OffensiveWords.list.contains(newCategoryName.lowercased()) {
                return true
            } else {
                newCategoryView?.showOffensiveWordsEnteringError(errorIn: "Category")
                return false
            }
        } else {
            showOrHideCategoryNameError(name: newCategoryName)
            return false
        }
    }
    
    private func showOrHideCategoryNameError(name: String?) {
        newCategoryView?.textFieldView.errorText = name != nil
            ? "Category \(name ?? "") is already exist"
            : nil
    }
    
    @objc private func newCategoryTextFieldDidChange() {
        guard let newCategoryView else { return }
        guard let text = newCategoryView.textFieldView.textField.text else { return }
        newCategoryView.setButton.isEnabled = text.trim().count > 2
        newCategoryView.textFieldView.errorText = newCategoryView.setButton.isEnabled ? nil : "Category should be from 3 to 30 symbols"
    }
    
	@IBAction func viewButtonViewcked(_ sender: Any) {
		superCategory.visible.toggle()
		delegate?.visibleChanged()
	}

	@IBAction func plusButtonClicked(_ sender: Any) {
		delegate?.selectSuperCategory(superCategory: superCategory)
	}
}

extension InterestSuperCategoryView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =  currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= newCategoryNameMaxLenght
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        newCategoryView?.clearOffensiveWordsEnteredError()
        showOrHideCategoryNameError(name: nil)
    }
}

extension InterestSuperCategoryView: SetChangesAndCancelButtonTapDelegate {
	
	func didTapSetButton(with parent: Category?, newTitle: String) {
		if isNewCategoryValid(newCategoryName: newTitle) {
		   let newCategory = Category(code: newTitle)
		   if interestManager.customInterestsTree == nil {
			  interestManager.customInterestsTree = interestManager.interestsTree
		   }
		   if let parent {
			  if let index = interestManager.customInterestsTree?.categories.firstIndex(of: parent) {
				 interestManager.customInterestsTree?.categories[index].children?.append(newCategory)
			  }
		   } else {
			  interestManager.customInterestsTree?.categories.append(newCategory)
		   }
		   interestManager.interestsTree = interestManager.customInterestsTree
		   drawInterestTreeCallBack?()
		   newCategoryView?.endEditing(true)
		}
	}
	
    func didTapCancelButton() {
        newCategoryView?.isHidden.toggle()
        customCategoryView?.isHidden.toggle()
        newCategoryView?.textFieldView.textField.text = nil
        newCategoryView?.clearOffensiveWordsEnteredError()
        showOrHideCategoryNameError(name: nil)
        endEditing(true)
    }
}
