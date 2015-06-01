import UIKit

class SignViewController: UIViewController, UIGestureRecognizerDelegate {
	
	var statusBarVisible = false
	@IBOutlet weak var label : UILabel?

	override func viewDidLoad() {
		super.viewDidLoad()
		
		if let label = label {
			if let text = loadText() {
				label.text = text
			}
			else if let text = label.text {
				saveText(text)
			}
		}
	}
	
	func loadText() -> String? {
		let defaults = NSUserDefaults.standardUserDefaults()
		if let value = defaults.stringForKey("SignageText") {
			if !value.isEmpty {
				return value
			}
		}
		return nil
	}
	
	func saveText(text : String) {
		let defaults = NSUserDefaults.standardUserDefaults()
		defaults.setObject(text, forKey: "SignageText")
		defaults.synchronize()
	}
	
	@IBAction func handleLongPress(recognizer: UIGestureRecognizer) {
		self.performSegueWithIdentifier("ShowEditController", sender: self)
	}
	
	@IBAction func toggleStatusBarVisible(recognizer: UIGestureRecognizer) {
		statusBarVisible = !statusBarVisible
		self .setNeedsStatusBarAppearanceUpdate()
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if let identifier = segue.identifier {
			if
				identifier == "ShowEditController",
				let navigationController = segue.destinationViewController as? UINavigationController,
				let editController = navigationController.topViewController as? SignEditViewController {
					editController.delegate = self
			}
		}
	}
	
	override func prefersStatusBarHidden() -> Bool {
		return !statusBarVisible
	}
}

extension SignViewController : SignEditViewControllerDelegate {
	func getExistingText(controller: SignEditViewController) -> String {
		return loadText() ?? ""
	}
	
	func controller(controller: SignEditViewController, didFinishedEditingWithText text: String) {
		saveText(text)
		
		if let label = label {
			label.text = text
		}
		
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	func controllerDidCancelEditing(controller: SignEditViewController) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
}

