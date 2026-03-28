package com.example.refactor_me

import android.content.Context
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.core.booleanPreferencesKey
import androidx.datastore.preferences.core.intPreferencesKey
import androidx.datastore.preferences.core.stringPreferencesKey
import androidx.glance.Button
import androidx.glance.GlanceId
import androidx.glance.GlanceModifier
import androidx.glance.action.ActionParameters
import androidx.glance.action.actionParametersOf
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.action.ActionCallback
import androidx.glance.appwidget.action.actionRunCallback
import androidx.glance.appwidget.provideContent
import androidx.glance.appwidget.state.getAppWidgetState
import androidx.glance.appwidget.state.updateAppWidgetState
import androidx.glance.state.PreferencesGlanceStateDefinition
import androidx.glance.background
import androidx.glance.currentState
import androidx.glance.layout.Alignment
import androidx.glance.layout.Box
import androidx.glance.layout.Column
import androidx.glance.layout.Row
import androidx.glance.layout.Spacer
import androidx.glance.layout.fillMaxSize
import androidx.glance.layout.height
import androidx.glance.layout.padding
import androidx.glance.layout.width
import androidx.glance.text.FontWeight
import androidx.glance.text.Text
import androidx.glance.text.TextStyle
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.HomeWidgetPlugin
import kotlinx.coroutines.delay

// ウィジェット本体と、ボタンクリック時のハンドラー

class MuscleWidget : GlanceAppWidget() {

    companion object {
        // Flutter側のSharedPrefsのキーと名前を合わせる（管理しやすいので）
        val EXERCISE_NAME_KEY = stringPreferencesKey("exerciseName")
        // 現在のセット数
        val CURRENT_SET_KEY = intPreferencesKey("currentSet")
        // トータルのセット数
        val TOTAL_SETS_KEY = intPreferencesKey("totalSets")
        // 目標レップ数
        val TARGET_REPS_KEY = intPreferencesKey("targetReps")
        // アクティブ状態
        val IS_ACTIVE_KEY = booleanPreferencesKey("isActive")
    }

    override suspend fun provideGlance(context: Context, id: GlanceId) {
        android.util.Log.d("MuscleWidget", "Glanceのid: $id")

        // 状態更新を監視
        provideContent {
            // Glance Datastoreからの読み込み
            val prefs = currentState<Preferences>()
            val exerciseName = prefs[EXERCISE_NAME_KEY] ?: "ワークアウトがありません"
            val currentSetInt = prefs[CURRENT_SET_KEY] ?: 1
            val totalSetsInt = prefs[TOTAL_SETS_KEY] ?: 3
            val targetRepsInt = prefs[TARGET_REPS_KEY] ?: 10
            val isActive = prefs[IS_ACTIVE_KEY] ?: false

            MuscleWidgetContent(
                exerciseName = exerciseName,
                currentSet = currentSetInt,
                totalSets = totalSetsInt,
                targetReps = targetRepsInt,
                isActive = isActive
            )
        }
    }

    // ウィジェットのUIを作る
    @Composable
    private fun MuscleWidgetContent(
        exerciseName: String,
        currentSet: Int,
        totalSets: Int,
        targetReps: Int,
        isActive: Boolean
    ) {
        Box(
            modifier = GlanceModifier.fillMaxSize()
                .background(Color(0xFF1E1E1E))
                .padding(16.dp),
            contentAlignment = Alignment.Center
        ) {
            if (isActive) {
                Column(
                    horizontalAlignment = Alignment.CenterHorizontally
                ) {
                    Text(
                        text = exerciseName,
                        style = TextStyle(fontSize = 18.sp, fontWeight = FontWeight.Bold, color = androidx.glance.unit.ColorProvider(Color.White))
                    )
                    Spacer(modifier = GlanceModifier.height(8.dp))
                    Text(
                        text = "セット $currentSet / $totalSets",
                        style = TextStyle(fontSize = 16.sp, color = androidx.glance.unit.ColorProvider(Color.White))
                    )
                    Text(
                        text = "目標: $targetReps 回",
                        style = TextStyle(fontSize = 14.sp, color = androidx.glance.unit.ColorProvider(Color(0xFFBBBBBB)))
                    )
                    Spacer(modifier = GlanceModifier.height(16.dp))
                    Button(
                        text = "セット完了",
                        onClick = actionRunCallback<CompleteSetAction>()
                    )
                }
            } else {
                 Column(
                    horizontalAlignment = Alignment.CenterHorizontally
                ) {
                    Text(text = "トレーニングなし", style = TextStyle(color = androidx.glance.unit.ColorProvider(Color.White)))
                    Spacer(modifier = GlanceModifier.height(8.dp))
                    Text(text = "アプリから開始", style = TextStyle(color = androidx.glance.unit.ColorProvider(Color.White)))
                }
            }
        }
    }
}

// ボタンのアクション
// メニューの状態を管理する
class CompleteSetAction : ActionCallback {
    override suspend fun onAction(context: Context, glanceId: GlanceId, parameters: ActionParameters) {
        try {
            android.util.Log.d("CompleteSetAction", "=== Button clicked ===")

            // 1. 現在の状態をデータストアから取得
            val currentState = getAppWidgetState(context, PreferencesGlanceStateDefinition, glanceId)
            val exerciseName = currentState[MuscleWidget.EXERCISE_NAME_KEY] ?: "ワークアウトがありません"
            val currentSet = currentState[MuscleWidget.CURRENT_SET_KEY] ?: 1
            val totalSets = currentState[MuscleWidget.TOTAL_SETS_KEY] ?: 3
            val targetReps = currentState[MuscleWidget.TARGET_REPS_KEY] ?: 10
            val isActive = currentState[MuscleWidget.IS_ACTIVE_KEY] ?: false

            // 2. アクティブ状態でなければ終了する
            if (!isActive) {
                android.util.Log.d("CompleteSetAction", "ワークアウトはActiveではありません")
                return
            }

            val flutterPrefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)

            val allSetsCompleted = currentSet >= totalSets

            // 5a. ワークアウトのセット完了
            if (allSetsCompleted) {
                // ログ送信用に、次のExerciseに切り替わる前の現在のIDを保存
                val completedExerciseId = flutterPrefs.getLong("flutter.currentExerciseId", 0L).toInt()

                // remainingから次のExerciseを取得
                val remainingIds = flutterPrefs.getString("flutter.remainingExerciseIds", null)
                val remainingNames = flutterPrefs.getString("flutter.remainingExerciseNames", null)
                val remainingSets = flutterPrefs.getString("flutter.remainingTotalSets", null)
                val remainingReps = flutterPrefs.getString("flutter.remainingTargetReps", null)

                val ids = remainingIds?.split("|")?.filter { it.isNotEmpty() } ?: emptyList()
                val names = remainingNames?.split("|")?.filter { it.isNotEmpty() } ?: emptyList()
                val sets = remainingSets?.split("|")?.filter { it.isNotEmpty() } ?: emptyList()
                val reps = remainingReps?.split("|")?.filter { it.isNotEmpty() } ?: emptyList()

                if (ids.isNotEmpty() && names.isNotEmpty()) {
                    android.util.Log.d("CompleteSetAction", "次のExercise")
                    // 5a-1 次のExerciseに切り替え
                    val nextId = ids.first().toLongOrNull() ?: 0L
                    val nextName = names.first()
                    val nextSets = sets.firstOrNull()?.toIntOrNull() ?: 3
                    val nextReps = reps.firstOrNull()?.toIntOrNull() ?: 10

                    // Glanceデータストアの更新（ウィジェットの描画更新）
                    updateAppWidgetState(context, glanceId) { prefs ->
                        prefs[MuscleWidget.EXERCISE_NAME_KEY] = nextName
                        prefs[MuscleWidget.CURRENT_SET_KEY] = 1
                        prefs[MuscleWidget.TOTAL_SETS_KEY] = nextSets
                        prefs[MuscleWidget.TARGET_REPS_KEY] = nextReps
                        prefs[MuscleWidget.IS_ACTIVE_KEY] = true
                    }

                    // SharedPreferencesを更新する。アプリと同期するため
                    flutterPrefs.edit().apply {
                        putString("flutter.exerciseName", nextName)
                        putLong("flutter.currentSet", 1L)
                        putLong("flutter.totalSets", nextSets.toLong())
                        putLong("flutter.targetReps", nextReps.toLong())
                        putLong("flutter.currentExerciseId", nextId)
                        putBoolean("flutter.isActive", true)

                        // 残りキューを更新（先頭を消費して残りを保存）
                        if (ids.size > 1) {
                            putString("flutter.remainingExerciseIds", ids.drop(1).joinToString("|"))
                            putString("flutter.remainingExerciseNames", names.drop(1).joinToString("|"))
                            putString("flutter.remainingTotalSets", sets.drop(1).joinToString("|"))
                            putString("flutter.remainingTargetReps", reps.drop(1).joinToString("|"))
                        } else {
                            remove("flutter.remainingExerciseIds")
                            remove("flutter.remainingExerciseNames")
                            remove("flutter.remainingTotalSets")
                            remove("flutter.remainingTargetReps")
                        }
                        commit()
                    }
                } else {
                    // キューが空 ＝ ワークアウト終了
                    android.util.Log.d("CompleteSetAction", "すべてのワークアウトが完了")

                    updateAppWidgetState(context, glanceId) { prefs ->
                        prefs[MuscleWidget.IS_ACTIVE_KEY] = false
                        prefs[MuscleWidget.EXERCISE_NAME_KEY] = "ワークアウト完了"
                    }

                    flutterPrefs.edit().apply {
                        putBoolean("flutter.isActive", false)
                        putString("flutter.exerciseName", "ワークアウト完了")
                        remove("flutter.remainingExerciseIds")
                        remove("flutter.remainingExerciseNames")
                        remove("flutter.remainingTotalSets")
                        remove("flutter.remainingTargetReps")
                        commit() // 書き込み完了を保証する
                    }
                }

                 // Flutter側にログを保存する（カレンダー表示に利用）
                // =======Flutterに値送信

                // SharedPreferencesからmenuIdを取得
                val menuId = flutterPrefs.getLong("flutter.currentMenuId", 0L).toInt()

                // HomeWidget経由でFlutterにバックグラウンド通知する（completedExerciseIdは切り替え前に保存した値）
                val uri = android.net.Uri.parse("homewidget://logset?exerciseId=$completedExerciseId&menuId=$menuId")
                val intent = HomeWidgetBackgroundIntent.getBroadcast(context, uri)
                intent.send()
                android.util.Log.d("CompleteSetAction", "バックグラウンドに送信完了 $currentSet")

                // =======Flutterに値送信終わり
            } else {
                // セット数をインクリメントする
                val newSet = currentSet + 1

                // Glanceデータストアを更新する
                updateAppWidgetState(context, glanceId) { prefs ->
                    prefs[MuscleWidget.CURRENT_SET_KEY] = newSet
                }

                // Flutterに反映
                val success = flutterPrefs.edit().apply {
                    putLong("flutter.currentSet", newSet.toLong())
                    putBoolean("flutter.isActive", true)
                }.commit()

                android.util.Log.d("CompleteSetAction", "セットをインクリメントしました")
            }

            // ウィジェットを更新する
            MuscleWidget().update(context, glanceId)
            android.util.Log.d("CompleteSetAction", "=== Widget更新の完了 ===")

        } catch (e: Exception) {
            android.util.Log.e("CompleteSetAction", "ウィジェット更新に失敗しました", e)
            try {
                MuscleWidget().update(context, glanceId)
            } catch (updateError: Exception) {
                android.util.Log.e("CompleteSetAction", "catch内ウィジェット更新に失敗しました", updateError)
            }
        }
    }
}
