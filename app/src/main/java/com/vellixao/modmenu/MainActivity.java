package com.vellixao.modmenu;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.provider.Settings;
import android.widget.Toast;

/**
 * MainActivity - Launcher untuk memulai Mod Menu
 */
public class MainActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // Cek izin overlay (penting untuk Android 6.0+)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && !Settings.canDrawOverlays(this)) {
            Intent intent = new Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                    Uri.parse("package:" + getPackageName()));
            startActivityForResult(intent, 123);
            Toast.makeText(this, "Izinkan Overlay untuk Mod Menu", Toast.LENGTH_SHORT).show();
        } else {
            startModMenu();
        }
    }

    private void startModMenu() {
        startService(new Intent(this, FloatingMenuService.class));
        finish(); // Tutup activity setelah start service
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == 123) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && Settings.canDrawOverlays(this)) {
                startModMenu();
            } else {
                Toast.makeText(this, "Izin Overlay ditolak!", Toast.LENGTH_SHORT).show();
            }
        }
    }
}
