package com.example.application

import com.google.vr.sdk.audio.GvrAudioEngine
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.logging.Logger
import com.example.application.R;

class MainActivity: FlutterActivity() {
    private val CHANNEL = "application.flutter.dev/playSound";
    private var audioEngine: GvrAudioEngine? = null;
    @Volatile
    private var sourceId = GvrAudioEngine.INVALID_ID;


    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if(call.method == "playAudio"){
                //Run the native code to play audio using resonance engine
                var fileName: String ="Sounds/"+ call.argument<String>("fileName")!!;
                playAudio(fileName);
            }
        }
    }

    private fun playAudio(fileName: String){
        Thread(
            Runnable {
                prepareAudio();
                // Preload the sound file
                //audioEngine?.preloadSoundFile(fileName)!!;
                sourceId = R.raw.totalitarian;
                audioEngine?.setSoundObjectPosition(
                        sourceId, 0.0F,0.0F, 0.0F);
                audioEngine?.playSound(sourceId, true /* looped playback */);
                Logger.getLogger(MainActivity::class.java.name).warning("Playing sound effect");
            })
            .start()
    }

    private fun prepareAudio(){
        audioEngine = GvrAudioEngine(this, GvrAudioEngine.RenderingMode.BINAURAL_HIGH_QUALITY);
    }
}
