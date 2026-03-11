package com.evmoto.user.app

import android.content.Context
import androidx.annotation.NonNull
import com.sendbird.calls.*
import com.sendbird.calls.SendBirdCall.addListener
import com.sendbird.calls.SendBirdCall.dial
import com.sendbird.calls.handler.AuthenticateHandler
import com.sendbird.calls.handler.DialHandler
import com.sendbird.calls.handler.DirectCallListener
import com.sendbird.calls.handler.SendBirdCallListener
import com.sendbird.calls.handler.CompletionHandler
import com.sendbird.calls.SendBirdException
import com.sendbird.calls.AudioDevice

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import java.util.*
import android.util.Log
import android.os.Handler
import android.os.Looper
import org.json.JSONObject


class MainActivity: FlutterActivity() {
    private val METHOD_CHANNEL_NAME = "com.sendbird.calls/method"
    private val ERROR_CODE = "Sendbird Calls"
    private var methodChannel: MethodChannel? = null
    private var directCall: DirectCall? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Setup
        setupChannels(this, flutterEngine.dartExecutor.binaryMessenger)
    }

    override fun onDestroy() {
        disposeChannels()
        super.onDestroy()
    }

    private fun setupChannels(context:Context, messenger: BinaryMessenger) {
        methodChannel = MethodChannel(messenger, METHOD_CHANNEL_NAME)
        methodChannel!!.setMethodCallHandler { call, result ->
            when(call.method) {
                "init" -> {
                    val appId: String? = call.argument("app_id")
                    val userId: String? = call.argument("user_id")
                    val accessToken: String? = call.argument("access_token")
                    val pushToken: String? = call.argument("push_token")

                    when {
                        appId == null -> {
                            result.error(ERROR_CODE, "Failed Init", "Missing app_id")
                        }
                        userId == null -> {
                            result.error(ERROR_CODE, "Failed Init", "Missing user_id")
                        }
                        else -> {
                            initSendbird(context, appId!!, userId!!, accessToken!!, pushToken!!) { successful -> 
                            }

                            result.success(true)
                        }
                    }
                }
                "handle_firebase_push_notification_data" -> {
                    val data: Map<String, String> = call.argument("data")!!
                    SendBirdCall.handleFirebaseMessageData(data)
                    result.success(true);
                }
                "answer_direct_call"->{
                    val callId: String? = call.argument("call_id")
                    directCall = SendBirdCall.getCall(callId!!)
                    directCall?.accept(AcceptParams());
                    result.success(true);
                }
                "reject_direct_call"->{
                    val callId: String? = call.argument("call_id")
                    directCall = SendBirdCall.getCall(callId!!)
                    directCall?.end();
                    result.success(true);
                }
                "start_direct_call" -> {
                    val calleeId: String? = call.argument("callee_id")
                    if (calleeId == null) {
                        result.error(ERROR_CODE, "Failed call", "Missing callee_id")
                    }
                    var params = DialParams(calleeId!!)
                    params.setCallOptions(CallOptions())
                    directCall = dial(params, object : DialHandler {
                        override fun onResult(call: DirectCall?, e: SendBirdException?) {
                            if (e != null) {
                                result.error(ERROR_CODE, "Failed call", e.message)
                                return
                            }
                            result.success(true)
                        }
                    })
                    directCall?.setListener(object : DirectCallListener() {
                        override fun onEstablished(call: DirectCall) {}
                        override fun onConnected(call: DirectCall) {
                            val args = HashMap<String, String?>()
                            args["call_id"] = call?.callId
                            methodChannel?.invokeMethod("start_direct_call_connected", args)
                        }
                        override fun onEnded(call: DirectCall) {
                            val args = HashMap<String, String?>()
                            args["call_id"] = call?.callId
                            directCall = null
                            methodChannel?.invokeMethod("start_direct_call_ended", args)
                        }
                    })
                }
                "end_direct_call" -> {
                    // End a call
                    directCall?.end();
                    result.success(true);
                }
                "microphone_on" -> {
                    directCall?.unmuteMicrophone();
                    result.success(true);
                }
                "microphone_off" -> {
                    directCall?.muteMicrophone();
                    result.success(true);
                }
                "loadspeaker_on" -> {
                    directCall?.selectAudioDevice(AudioDevice.SPEAKERPHONE, null);
                    result.success(true);
                }
                "loadspeaker_off" -> {
                    directCall?.selectAudioDevice(AudioDevice.EARPIECE, null);
                    result.success(true);
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun initSendbird(context: Context, appId: String , userId: String, accessToken: String, pushToken: String, callback: (Boolean)->Unit){
        // Initialize SendBirdCall instance to use APIs in your app.
        if(SendBirdCall.init(context, appId)){
            var params = AuthenticateParams(userId).setAccessToken(accessToken)

            SendBirdCall.authenticate(params, object : AuthenticateHandler {
                override fun onResult(user: User?, e: SendBirdException?) {
                    if (e == null) {
                        SendBirdCall.registerPushToken(pushToken!!, true, object : CompletionHandler {
                            override fun onResult(e: SendBirdException?) { // Nama method harus onResult
                                if (e == null) {
                                    // Berhasil
                                } else {
                                    // Gagal
                                }
                            }
                        })

                        SendBirdCall.addListener(UUID.randomUUID().toString(), object : SendBirdCallListener() {
                            override fun onRinging(call: DirectCall) {
                                directCall = call

                                directCall?.setListener(object : DirectCallListener() {
                                    override fun onConnected(call: DirectCall) {}
                                    override fun onEnded(call: DirectCall) {
                                        val args = HashMap<String, String?>()
                                        args["call_id"] = directCall?.callId
                                        directCall = null
                                        methodChannel?.invokeMethod("direct_call_ended", args)
                                    }
                                })
                            }
                        })
                        callback(true)
                    } else {
                        callback(false)
                    }
                }
            })
        }
    }

    private fun disposeChannels(){
        methodChannel!!.setMethodCallHandler(null)
    }
}
