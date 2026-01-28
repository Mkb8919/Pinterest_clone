package com.example.pinterest_clone   // <-- YAHAN APNA PACKAGE NAME DAALO

import io.flutter.embedding.android.FlutterActivity
import android.provider.MediaStore
import android.content.ContentValues
import android.os.Environment
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileInputStream

class MainActivity: FlutterActivity() {
    private val CHANNEL = "save_image_channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "saveImage") {

                    val filePath = call.argument<String>("filePath")!!
                    val file = File(filePath)

                    val values = ContentValues().apply {
                        put(MediaStore.Images.Media.DISPLAY_NAME, "Pinterest_${System.currentTimeMillis()}.jpg")
                        put(MediaStore.Images.Media.MIME_TYPE, "image/jpeg")
                        put(MediaStore.Images.Media.RELATIVE_PATH, Environment.DIRECTORY_PICTURES)
                    }

                    val uri = contentResolver.insert(
                        MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
                        values
                    )

                    uri?.let {
                        val outputStream = contentResolver.openOutputStream(uri)
                        val inputStream = FileInputStream(file)

                        inputStream.copyTo(outputStream!!)
                        inputStream.close()
                        outputStream.close()

                        result.success(true)
                    } ?: result.error("SAVE_FAILED", "Unable to save image", null)
                }
            }
    }
}
