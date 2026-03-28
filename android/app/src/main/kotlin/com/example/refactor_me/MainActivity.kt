package com.example.refactor_me

import android.appwidget.AppWidgetManager
import android.content.ComponentName
import androidx.annotation.NonNull
import androidx.glance.appwidget.GlanceAppWidgetManager
import androidx.glance.appwidget.state.updateAppWidgetState
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class MainActivity : FlutterActivity() {
    // メソッドチャンネル名
    private val CHANNEL = "com.example.refactor_me/glance"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "update") { // Flutter側のinvokedの第一引数に合わせる
                // widgetのアップデートを行うため、CoroutineScopeを利用する
                CoroutineScope(Dispatchers.Main).launch {
                    try {
                        // Flutterから受信したデータをMapに変換する
                        val arguments = call.arguments as? Map<String, Any>
                        android.util.Log.d("MainActivity", "Flutteのデータを受信しました: $arguments")

                        // Glance DataStoreに保存する
                        if (arguments != null) {
                            try {
                                val exerciseName = arguments["exerciseName"] as? String ?: "ワークアウト名がありません"
                                // 現在のセット数
                                val currentSet = arguments["currentSet"] as? Int ?: 1
                                // トータルセット数
                                val totalSets = arguments["totalSets"] as? Int ?: 3
                                // 目標のレップ数
                                val targetReps = arguments["targetReps"] as? Int ?: 10
                                val isActive = arguments["isActive"] as? Boolean ?: false

                                // ホーム画面からウィジェットを取得する。配置されているかを確認する
                                val appWidgetManager = AppWidgetManager.getInstance(context)
                                // MuscleWidgetReceiverを特定
                                val componentName = ComponentName(context, MuscleWidgetReceiver::class.java)
                                val appWidgetIds = appWidgetManager.getAppWidgetIds(componentName)

                                if (appWidgetIds.isEmpty()) {
                                    android.util.Log.w("MainActivity", "ウィジェットが見つかりませんでした。ホーム画面にウィジェットを配置してください")
                                    result.success(null)
                                    return@launch
                                }

                                // Glanceの描画を更新するため、データストアを更新する
                                val glanceManager = GlanceAppWidgetManager(context)
                                // MuscleWidgetの特定
                                val glanceIds = glanceManager.getGlanceIds(MuscleWidget::class.java)

                                // ユーザーがウィジェットを配置している分だけループさせている
                                glanceIds.forEach { glanceId ->
                                    updateAppWidgetState(context, glanceId) { prefs ->
                                        prefs[MuscleWidget.EXERCISE_NAME_KEY] = exerciseName
                                        prefs[MuscleWidget.CURRENT_SET_KEY] = currentSet
                                        prefs[MuscleWidget.TOTAL_SETS_KEY] = totalSets
                                        prefs[MuscleWidget.TARGET_REPS_KEY] = targetReps
                                        prefs[MuscleWidget.IS_ACTIVE_KEY] = isActive
                                    }
                                    android.util.Log.d("MainActivity", "Glance Datastoreを更新しました: $glanceId")
                                }
                            } catch (e: Exception) {
                                android.util.Log.e("MainActivity", "処理に失敗しました", e)
                            }
                        }

                        // Glanceの値を更新したので、画面描画を更新する
                        val widget = MuscleWidget()
                        val glanceManager = GlanceAppWidgetManager(context)
                        val glanceIds = glanceManager.getGlanceIds(MuscleWidget::class.java)

                        glanceIds.forEach { glanceId ->
                            widget.update(context, glanceId)
                        }
                        result.success(null)
                    } catch (e: Exception) {
                        android.util.Log.e("MainActivity", "Glance widgetのupdateに失敗しました", e)
                        result.error("UPDATE_ERROR", e.message, null)
                    }
                }
            } else {
                result.notImplemented()
            }
        }
    }
}
