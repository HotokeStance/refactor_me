package com.example.refactor_me

import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.GlanceAppWidgetManager
import androidx.glance.appwidget.GlanceAppWidgetReceiver
import kotlinx.coroutines.MainScope
import kotlinx.coroutines.launch

// Androidにウィジェットを登録している
// AndroidManifestと同じ名前で定義する
class MuscleWidgetReceiver : GlanceAppWidgetReceiver() {
    override val glanceAppWidget: GlanceAppWidget = MuscleWidget()

    override fun onReceive(context: android.content.Context, intent: android.content.Intent) {
        android.util.Log.d("MuscleWidgetReceiver", "onReceive called with action: ${intent.action}")
        super.onReceive(context, intent)
    }
}

