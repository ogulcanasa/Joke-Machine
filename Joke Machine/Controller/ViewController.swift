import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var setupLabel: UILabel!
    @IBOutlet weak var punchlineLabel: UILabel!
    @IBOutlet weak var buttonLabel: UIButton!
    
    private var jokes : Jokes?
    private let url = "https://joke.deno.dev/"
    private var setup : String?
    private var puchline : String?
    private var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeTextColorOfViewDidLoad()
    }

    func getData(from url: String, _ completion: @escaping (Bool) -> Void) {
        guard let downloadUrl = URL(string: url) else { return }
        URLSession.shared.dataTask(with: downloadUrl) { data, urlResponse, error in
            guard let data = data, error == nil , urlResponse != nil else {
                print("something is wrong")
                return
            }
            do {
                let decoder = JSONDecoder()
                let downloadedJokes = try decoder.decode(Jokes.self, from: data)
                self.jokes = downloadedJokes
                completion(true)
            }catch {
                print("something wrong after downloaded")
                completion(false)
            }
        }.resume()
    }
    
    @IBAction func buttonClicked(_ sender: UIButton) {
        if (buttonLabel.titleLabel?.text == "Tell me a joke!") { getData(from: url) { completed in
            if completed {
                DispatchQueue.main.async { [self] in
                    setupLabel.text = jokes?.setup
                    punchlineLabel.isHidden = true
                }
            } else {
                print("fail case")
            }
        }
        sender.setTitle("What's the answer?", for: .normal)
        timer.invalidate()
        } else if (buttonLabel.titleLabel?.text == "What's the answer?") {
            punchlineLabel.isHidden = false
            punchlineLabel.text = jokes?.punchline
            sender.setTitle("Tell me a joke!", for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(fieldsClearer), userInfo: nil, repeats: false)
        }
    }
    @objc func fieldsClearer() {
        if buttonLabel.titleLabel?.text != "What's the answer" {
            setupLabel.text = ""
            punchlineLabel.text = ""
        }
    }
    
    func changeTextColorOfViewDidLoad() {
        setupLabel.textColor = UIColor.white
        punchlineLabel.textColor = UIColor.white
        buttonLabel.titleLabel?.textColor = UIColor.white
    }
}

 
