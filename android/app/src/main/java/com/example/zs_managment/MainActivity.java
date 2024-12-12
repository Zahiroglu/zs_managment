package com.example.zs_managment;

import android.os.Bundle;  // Bundle importu
import io.flutter.embedding.android.FlutterActivity;  // FlutterActivity importu
import android.app.NotificationChannel;  // NotificationChannel importu
import android.app.NotificationManager;  // NotificationManager importu
import android.os.Build;  // Build importu

public class MainActivity extends FlutterActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // Android 8.0 və daha yuxarı versiyalar üçün Notification kanalının yaradılması
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            String channelId = "zs0001";  // Kanal ID-si
            CharSequence channelName = "zs-controll";  // Kanal adı
           // String channelDescription = "Bu kanal ZS-CONTROL tətbiqi üçün aktivdir.";  // Kanal təsviri
            int importance = NotificationManager.IMPORTANCE_HIGH;  // Yüksək prioritet

            // NotificationChannel obyektinin yaradılması
            NotificationChannel channel = new NotificationChannel(channelId, channelName, importance);
           // channel.setDescription(channelDescription);

            // NotificationManager vasitəsilə kanalı qeydiyyatdan keçirmək
            NotificationManager notificationManager = getSystemService(NotificationManager.class);
            notificationManager.createNotificationChannel(channel);
        }
    }
}
