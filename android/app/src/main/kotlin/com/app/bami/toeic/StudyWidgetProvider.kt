package com.app.bami.toeic

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.view.View
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider
import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Locale

/** Widget màn hình chính: chuỗi ngày học, nhiệm vụ hôm nay, thẻ từ cần ôn (số liệu do app ghi). */
class StudyWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences,
    ) {
        val state = WidgetState.read(widgetData)
        for (id in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.study_widget).apply {
                setOnClickPendingIntent(
                    R.id.widget_root,
                    HomeWidgetLaunchIntent.getActivity(context, MainActivity::class.java),
                )
                if (state == null) {
                    setViewVisibility(R.id.widget_stats, View.GONE)
                    setTextViewText(R.id.widget_streak, context.getString(R.string.widget_title))
                    setTextViewText(R.id.widget_status, context.getString(R.string.widget_signed_out))
                } else {
                    setViewVisibility(R.id.widget_stats, View.VISIBLE)
                    setTextViewText(
                        R.id.widget_streak,
                        context.getString(R.string.widget_streak, state.streak),
                    )
                    setTextViewText(
                        R.id.widget_status,
                        context.getString(
                            when {
                                state.studiedToday -> R.string.widget_done_today
                                state.streak > 0 -> R.string.widget_keep_streak
                                else -> R.string.widget_start_today
                            },
                        ),
                    )
                    setTextViewText(
                        R.id.widget_missions,
                        context.getString(
                            R.string.widget_missions,
                            state.missionsDone,
                            state.missionsTotal,
                        ),
                    )
                    setTextViewText(
                        R.id.widget_due,
                        context.getString(R.string.widget_due, state.dueWords),
                    )
                }
            }
            appWidgetManager.updateAppWidget(id, views)
        }
    }
}

/** Số liệu đã chỉnh theo ngày hiện tại (app ghi hôm qua thì "hôm nay" chưa học, nhiệm vụ về 0). */
private data class WidgetState(
    val streak: Int,
    val studiedToday: Boolean,
    val missionsDone: Int,
    val missionsTotal: Int,
    val dueWords: Int,
) {
    companion object {
        fun read(prefs: SharedPreferences): WidgetState? {
            if (!prefs.getBoolean("bami_signed_in", false)) return null
            fun int(key: String) = (prefs.all[key] as? Number)?.toInt() ?: 0
            val age = prefs.getString("bami_day", null)?.let(::daysAgo) ?: return null
            val studied = prefs.getBoolean("bami_studied_today", false)
            val streak = int("bami_streak")
            return when {
                age <= 0L -> WidgetState(
                    streak, studied, int("bami_missions_done"), int("bami_missions_total"),
                    int("bami_due_words"),
                )
                // Hôm qua có học thì chuỗi vẫn còn, chờ học hôm nay.
                age == 1L -> WidgetState(
                    if (studied) streak else 0, false, 0, int("bami_missions_total"),
                    int("bami_due_words"),
                )
                else -> WidgetState(0, false, 0, int("bami_missions_total"), int("bami_due_words"))
            }
        }

        /** Số ngày (theo lịch máy) từ ngày "yyyy-MM-dd" tới hôm nay; null nếu sai định dạng. */
        private fun daysAgo(day: String): Long? {
            val format = SimpleDateFormat("yyyy-MM-dd", Locale.US).apply { isLenient = false }
            val then = runCatching { format.parse(day) }.getOrNull() ?: return null
            fun dayNumber(cal: Calendar): Long {
                val utcMillis = cal.timeInMillis + cal.get(Calendar.ZONE_OFFSET) + cal.get(Calendar.DST_OFFSET)
                return Math.floorDiv(utcMillis, 86_400_000L)
            }
            val past = Calendar.getInstance().apply { time = then }
            return dayNumber(Calendar.getInstance()) - dayNumber(past)
        }
    }
}
