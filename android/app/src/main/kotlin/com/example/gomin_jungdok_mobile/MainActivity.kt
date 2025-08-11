package com.example.gomin_jungdok_mobile

import android.os.Build
import android.os.Bundle
import android.view.View
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // 상태바와 네비게이션 바 색상을 주황색(#FA743E)으로 설정
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            window.statusBarColor = android.graphics.Color.parseColor("#FA743E")
            window.navigationBarColor = android.graphics.Color.parseColor("#FA743E")

            // 상태바 아이콘 색을 어둡게(=배경 밝게)
            window.decorView.systemUiVisibility = (
                View.SYSTEM_UI_FLAG_LAYOUT_STABLE
            )
        }
    }
}
