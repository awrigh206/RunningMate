package com.example.application
import java.io.InputStream
import java.util.logging.Logger
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    // private val CHANNEL = "application.flutter.dev/playSound";
    // private var audioEngine: GvrAudioEngine? = null;
    // @Volatile
    // private var sourceId = GvrAudioEngine.INVALID_ID;

    // override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    //     super.configureFlutterEngine(flutterEngine)
    //     MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
    //         call, result ->
    //         if(call.method == "playAudio"){
    //             //Run the native code to play audio using resonance engine
    //             var fileName: String ="Sounds/" + call.argument<String>("fileName")!!;
    //             Logger.getLogger(MainActivity::class.java.name).warning(fileName);
    //             val assetLookupKey =  getLookupKeyForAsset(fileName);
    //             playAudio(assetLookupKey);
    //         }
    //     }
    // }

    // private fun playAudio(fileName: String){
    //     Thread(
    //         Runnable {
    //             prepareAudio();
    //             // Preload the sound file
    //             audioEngine?.preloadSoundFile(fileName)!!;
    //             sourceId = audioEngine?.createSoundObject(fileName)!!;
    //             audioEngine?.setSoundObjectPosition(
    //                     sourceId, 0.0F,0.0F, 0.0F);
    //             audioEngine?.playSound(sourceId, true /* looped playback */);
    //             Logger.getLogger(MainActivity::class.java.name).warning("Play Sound");
    //         })
    //         .start()
    // }

    // private fun prepareAudio(){
    //     audioEngine = GvrAudioEngine(this, GvrAudioEngine.RenderingMode.BINAURAL_HIGH_QUALITY);
    // }
}
