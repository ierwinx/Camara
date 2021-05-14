import UIKit
//Librerias de Reproductor de videos
import AVFoundation
import AVKit
import MobileCoreServices

class ViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet weak var previewImageView: UIImageView!
    
    // MARK: Properties
    private var imagePicker: UIImagePickerController?
    var currentVideoURL: URL?
    
    // MARK: Ciclo de vida
    override func viewDidLoad() {
        super.viewDidLoad()
        videoButton.isHidden = true
    }
    
    // MARK: Actions
    @IBAction func abrirAction(_ sender: Any) {
        let alerta = UIAlertController(title: "Acceso a camara", message: "Selecciona una opcion", preferredStyle: .actionSheet)
        alerta.addAction(UIAlertAction(title: "Foto", style: .default, handler: { (_) in
            self.abrirCamara()
        }))
        alerta.addAction(UIAlertAction(title: "Video", style: .default, handler: { (_) in
            self.abrirVideoCamara()
        }))
        alerta.addAction(UIAlertAction(title: "Cancelar", style: .destructive, handler: nil))
        
        present(alerta, animated: true, completion: nil)
    }
    
    @IBAction func verVideoAction(_ sender: Any) {
        guard let currentVideoURLx = currentVideoURL else {
            return
        }
        
        let avPlayer = AVPlayer(url: currentVideoURLx)
        let avPlayerController = AVPlayerViewController()
        avPlayerController.player = avPlayer
        
        // se abre reproductor nativo de iOS
        present(avPlayerController, animated: true) {
            avPlayerController.player?.play()
        }
    }

    // MARK: Methods
    private func abrirCamara() -> Void {
        imagePicker = UIImagePickerController()
        imagePicker?.sourceType = .camera
        imagePicker?.cameraFlashMode = .off
        imagePicker?.cameraCaptureMode = .photo
        imagePicker?.allowsEditing = true
        imagePicker?.delegate = self
        
        guard let imagenPicker = imagePicker else {
            return
        }
        
        present(imagenPicker, animated: true, completion: nil)
    }
    
    private func abrirVideoCamara() -> Void {
        imagePicker = UIImagePickerController()
        imagePicker?.sourceType = .camera
        imagePicker?.mediaTypes = [kUTTypeMovie as String]
        imagePicker?.cameraFlashMode = .off
        imagePicker?.cameraCaptureMode = .video
        imagePicker?.videoQuality = .type640x480
        imagePicker?.videoMaximumDuration = TimeInterval(5)  // 5 segundos
        imagePicker?.allowsEditing = true
        imagePicker?.delegate = self
        
        guard let imagenPicker = imagePicker else {
            return
        }
        
        present(imagenPicker, animated: true, completion: nil)
    }
    
}

// MARK: Extencion delegados
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //cerrar camara
        self.imagePicker?.dismiss(animated: true, completion: nil)
        
        //agregamos imagen a imageView
        if info.keys.contains(.originalImage) {
            self.previewImageView.isHidden = false
            self.previewImageView.image = info[.originalImage] as? UIImage
        }
        
        //capturar video URL
        if info.keys.contains(.mediaURL), let recordedVideoUrl = (info[.mediaURL] as? URL)?.absoluteURL {
            videoButton.isHidden = false
            currentVideoURL = recordedVideoUrl
        }
        
    }
    
}
